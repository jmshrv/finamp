import 'dart:async';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:audio_service/audio_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'finamp_settings_helper.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';

/// This provider handles the currently playing music so that multiple widgets
/// can control music.
class MusicPlayerBackgroundTask extends BaseAudioHandler {
  final _player = AudioPlayer(
    audioLoadConfiguration: AudioLoadConfiguration(
        androidLoadControl: AndroidLoadControl(
          minBufferDuration: FinampSettingsHelper.finampSettings.bufferDuration,
          maxBufferDuration: FinampSettingsHelper.finampSettings.bufferDuration,
          prioritizeTimeOverSizeThresholds: true,
        ),
        darwinLoadControl: DarwinLoadControl(
          preferredForwardBufferDuration:
              FinampSettingsHelper.finampSettings.bufferDuration,
        )),
  );
  ConcatenatingAudioSource _queueAudioSource =
      ConcatenatingAudioSource(children: []);
  final _audioServiceBackgroundTaskLogger = Logger("MusicPlayerBackgroundTask");
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  /// Set when shuffle mode is changed. If true, [onUpdateQueue] will create a
  /// shuffled [ConcatenatingAudioSource].
  bool shuffleNextQueue = false;

  /// Set when creating a new queue. Will be used to set the first index in a
  /// new queue.
  int? nextInitialIndex;

  /// The item that was previously played. Used for reporting playback status.
  MediaItem? _previousItem;

  /// Set to true when we're stopping the audio service. Used to avoid playback
  /// progress reporting.
  bool _isStopping = false;

  /// Holds the current sleep timer, if any. This is a ValueNotifier so that
  /// widgets like SleepTimerButton can update when the sleep timer is/isn't
  /// null.
  bool _sleepTimerIsSet = false;
  Duration _sleepTimerDuration = Duration.zero;
  final ValueNotifier<Timer?> _sleepTimer = ValueNotifier<Timer?>(null);

  List<int>? get shuffleIndices => _player.shuffleIndices;

  ValueListenable<Timer?> get sleepTimer => _sleepTimer;

  MusicPlayerBackgroundTask() {
    _audioServiceBackgroundTaskLogger.info("Starting audio service");

    // Propagate all events from the audio player to AudioService clients.
    _player.playbackEventStream.listen((event) async {
      playbackState.add(_transformEvent(event));

      if (playbackState.valueOrNull != null &&
          playbackState.valueOrNull?.processingState !=
              AudioProcessingState.idle &&
          playbackState.valueOrNull?.processingState !=
              AudioProcessingState.completed &&
          !FinampSettingsHelper.finampSettings.isOffline &&
          !_isStopping) {
        await _updatePlaybackProgress();
      }
    });

    // Special processing for state transitions.
    _player.processingStateStream.listen((event) {
      if (event == ProcessingState.completed) {
        stop();
      }
    });

    _player.currentIndexStream.listen((event) async {
      if (event == null) return;

      final currentItem = _getQueueItem(event);
      mediaItem.add(currentItem);

      if (!FinampSettingsHelper.finampSettings.isOffline) {
        final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

        if (_previousItem != null) {
          final playbackData = generatePlaybackProgressInfo(
            item: _previousItem,
            includeNowPlayingQueue: true,
          );

          if (playbackData != null) {
            await jellyfinApiHelper.stopPlaybackProgress(playbackData);
          }
        }

        final playbackData = generatePlaybackProgressInfo(
          item: currentItem,
          includeNowPlayingQueue: true,
        );

        if (playbackData != null) {
          await jellyfinApiHelper.reportPlaybackStart(playbackData);
        }

        // Set item for next index update
        _previousItem = currentItem;
      }
    });

    // PlaybackEvent doesn't include shuffle/loops so we listen for changes here
    _player.shuffleModeEnabledStream.listen(
        (_) => playbackState.add(_transformEvent(_player.playbackEvent)));
    _player.loopModeStream.listen(
        (_) => playbackState.add(_transformEvent(_player.playbackEvent)));
  }

  @override
  Future<void> play() {
    // If a sleep timer has been set and the timer went off
    //  causing play to pause, if the user starts to play
    //  audio again, and the sleep timer hasn't been explicitly
    //  turned off, then reset the sleep timer.
    // This is useful if the sleep timer pauses play too early
    //  and the user wants to continue listening
    if (_sleepTimerIsSet && _sleepTimer.value == null) {
      // restart the sleep timer for another period
      setSleepTimer(_sleepTimerDuration);
    }

    return _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    try {
      _audioServiceBackgroundTaskLogger.info("Stopping audio service");

      _isStopping = true;

      // Clear the previous item.
      _previousItem = null;

      // Tell Jellyfin we're no longer playing audio if we're online
      if (!FinampSettingsHelper.finampSettings.isOffline) {
        final playbackInfo =
            generatePlaybackProgressInfo(includeNowPlayingQueue: false);
        if (playbackInfo != null) {
          await _jellyfinApiHelper.stopPlaybackProgress(playbackInfo);
        }
      }

      // Stop playing audio.
      await _player.stop();

      // Seek to the start of the first item in the queue
      await _player.seek(Duration.zero, index: 0);

      _sleepTimerIsSet = false;
      _sleepTimerDuration = Duration.zero;

      _sleepTimer.value?.cancel();
      _sleepTimer.value = null;

      await super.stop();

      // await _player.dispose();
      // await _eventSubscription?.cancel();
      // // It is important to wait for this state to be broadcast before we shut
      // // down the task. If we don't, the background task will be destroyed before
      // // the message gets sent to the UI.
      // await _broadcastState();
      // // Shut down this background task
      // await super.stop();

      _isStopping = false;
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    try {
      await _queueAudioSource.add(await _mediaItemToAudioSource(mediaItem));
      queue.add(_queueFromSource());
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    try {
      // Convert the MediaItems to AudioSources
      List<AudioSource> audioSources = [];
      for (final mediaItem in newQueue) {
        audioSources.add(await _mediaItemToAudioSource(mediaItem));
      }

      // Create a new ConcatenatingAudioSource with the new queue.
      _queueAudioSource = ConcatenatingAudioSource(
        children: audioSources,
      );

      try {
        await _player.setAudioSource(
          _queueAudioSource,
          initialIndex: nextInitialIndex,
        );
      } on PlayerException catch (e) {
        _audioServiceBackgroundTaskLogger
            .severe("Player error code ${e.code}: ${e.message}");
      } on PlayerInterruptedException catch (e) {
        _audioServiceBackgroundTaskLogger
            .warning("Player interrupted: ${e.message}");
      } catch (e) {
        _audioServiceBackgroundTaskLogger
            .severe("Player error ${e.toString()}");
      }
      queue.add(_queueFromSource());

      // Sets the media item for the new queue. This will be whatever is
      // currently playing from the new queue (for example, the first song in
      // an album). If the player is shuffling, set the index to the player's
      // current index. Otherwise, set it to nextInitialIndex. nextInitialIndex
      // is much more stable than the current index as we know the value is set
      // when running this function.
      if (_player.shuffleModeEnabled) {
        if (_player.currentIndex == null) {
          _audioServiceBackgroundTaskLogger.severe(
              "_player.currentIndex is null during onUpdateQueue, not setting new media item");
        } else {
          mediaItem.add(_getQueueItem(_player.currentIndex!));
        }
      } else {
        if (nextInitialIndex == null) {
          _audioServiceBackgroundTaskLogger.severe(
              "nextInitialIndex is null during onUpdateQueue, not setting new media item");
        } else {
          mediaItem.add(_getQueueItem(nextInitialIndex!));
        }
      }

      shuffleNextQueue = false;
      nextInitialIndex = null;
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    try {
      await _player.seekToPrevious();
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> skipToNext() async {
    try {
      await _player.seekToNext();
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> skipToIndex(int index) async {
    try {
      await _player.seek(Duration.zero, index: index);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    try {
      switch (shuffleMode) {
        case AudioServiceShuffleMode.all:
          await _player.shuffle();
          await _player.setShuffleModeEnabled(true);
          shuffleNextQueue = true;
          break;
        case AudioServiceShuffleMode.none:
          await _player.setShuffleModeEnabled(false);
          shuffleNextQueue = false;
          break;
        default:
          return Future.error(
              "Unsupported AudioServiceRepeatMode! Recieved ${shuffleMode.toString()}, requires all or none.");
      }
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    try {
      switch (repeatMode) {
        case AudioServiceRepeatMode.all:
          await _player.setLoopMode(LoopMode.all);
          break;
        case AudioServiceRepeatMode.none:
          await _player.setLoopMode(LoopMode.off);
          break;
        case AudioServiceRepeatMode.one:
          await _player.setLoopMode(LoopMode.one);
          break;
        default:
          return Future.error(
              "Unsupported AudioServiceRepeatMode! Recieved ${repeatMode.toString()}, requires all, none, or one.");
      }
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    try {
      await _queueAudioSource.removeAt(index);
      queue.add(_queueFromSource());
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Generates PlaybackProgressInfo from current player info. Returns null if
  /// _queue is empty. If an item is not supplied, the current queue index will
  /// be used.
  PlaybackProgressInfo? generatePlaybackProgressInfo({
    MediaItem? item,
    required bool includeNowPlayingQueue,
  }) {
    if (_queueAudioSource.length == 0 && item == null) {
      // This function relies on _queue having items, so we return null if it's
      // empty to avoid more errors.
      return null;
    }

    try {
      return PlaybackProgressInfo(
        itemId: item?.extras?["itemJson"]["Id"] ??
            _getQueueItem(_player.currentIndex ?? 0).extras!["itemJson"]["Id"],
        isPaused: !_player.playing,
        isMuted: _player.volume == 0,
        positionTicks: _player.position.inMicroseconds * 10,
        repeatMode: _jellyfinRepeatMode(_player.loopMode),
        playMethod: item?.extras!["shouldTranscode"] ??
                _getQueueItem(_player.currentIndex ?? 0)
                    .extras!["shouldTranscode"]
            ? "Transcode"
            : "DirectPlay",
        // We don't send the queue since it seems useless and it can cause
        // issues with large queues.
        // https://github.com/jmshrv/finamp/issues/387

        // nowPlayingQueue: includeNowPlayingQueue
        //     ? _queueFromSource()
        //         .map(
        //           (e) => QueueItem(
        //               id: e.extras!["itemJson"]["Id"], playlistItemId: e.id),
        //         )
        //         .toList()
        //     : null,
      );
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      rethrow;
    }
  }

  void setNextInitialIndex(int index) {
    nextInitialIndex = index;
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    // When we're moving an item forwards, we need to reduce newIndex by 1
    // to account for the current item being removed before re-insertion.
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    await _queueAudioSource.move(oldIndex, newIndex);
    queue.add(_queueFromSource());
    _audioServiceBackgroundTaskLogger.log(Level.INFO, "Published queue");
  }

  /// Sets the sleep timer with the given [duration].
  Timer setSleepTimer(Duration duration) {
    _sleepTimerIsSet = true;
    _sleepTimerDuration = duration;

    _sleepTimer.value = Timer(duration, () async {
      _sleepTimer.value = null;
      return await pause();
    });
    return _sleepTimer.value!;
  }

  /// Cancels the sleep timer and clears it.
  void clearSleepTimer() {
    _sleepTimerIsSet = false;
    _sleepTimerDuration = Duration.zero;

    _sleepTimer.value?.cancel();
    _sleepTimer.value = null;
  }

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
      shuffleMode: _player.shuffleModeEnabled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      repeatMode: _audioServiceRepeatMode(_player.loopMode),
    );
  }

  Future<void> _updatePlaybackProgress() async {
    try {
      JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

      final playbackInfo =
          generatePlaybackProgressInfo(includeNowPlayingQueue: false);
      if (playbackInfo != null) {
        await jellyfinApiHelper.updatePlaybackProgress(playbackInfo);
      }
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  MediaItem _getQueueItem(int index) {
    return _queueAudioSource.sequence[index].tag as MediaItem;
  }

  List<MediaItem> _queueFromSource() {
    return _queueAudioSource.sequence.map((e) => e.tag as MediaItem).toList();
  }

  /// Syncs the list of MediaItems (_queue) with the internal queue of the player.
  /// Called by onAddQueueItem and onUpdateQueue.
  Future<AudioSource> _mediaItemToAudioSource(MediaItem mediaItem) async {
    if (mediaItem.extras!["downloadedSongJson"] == null) {
      // If DownloadedSong wasn't passed, we assume that the item is not
      // downloaded.

      // If offline, we throw an error so that we don't accidentally stream from
      // the internet. See the big comment in _songUri() to see why this was
      // passed in extras.
      if (mediaItem.extras!["isOffline"]) {
        return Future.error(
            "Offline mode enabled but downloaded song not found.");
      } else {
        if (mediaItem.extras!["shouldTranscode"] == true) {
          return HlsAudioSource(await _songUri(mediaItem), tag: mediaItem);
        } else {
          return AudioSource.uri(await _songUri(mediaItem), tag: mediaItem);
        }
      }
    } else {
      // We have to deserialise this because Dart is stupid and can't handle
      // sending classes through isolates.
      final downloadedSong =
          DownloadedSong.fromJson(mediaItem.extras!["downloadedSongJson"]);

      // Path verification and stuff is done in AudioServiceHelper, so this path
      // should be valid.
      final downloadUri = Uri.file(downloadedSong.file.path);
      return AudioSource.uri(downloadUri, tag: mediaItem);
    }
  }

  Future<Uri> _songUri(MediaItem mediaItem) async {
    // We need the platform to be Android or iOS to get device info
    assert(Platform.isAndroid || Platform.isIOS,
        "_songUri() only supports Android and iOS");

    // When creating the MediaItem (usually in AudioServiceHelper), we specify
    // whether or not to transcode. We used to pull from FinampSettings here,
    // but since audio_service runs in an isolate (or at least, it does until
    // 0.18), the value would be wrong if changed while a song was playing since
    // Hive is bad at multi-isolate stuff.

    final androidId =
        Platform.isAndroid ? await const AndroidId().getId() : null;
    final iosDeviceInfo =
        Platform.isIOS ? await DeviceInfoPlugin().iosInfo : null;

    final parsedBaseUrl = Uri.parse(_finampUserHelper.currentUser!.baseUrl);

    List<String> builtPath = List<String>.from(parsedBaseUrl.pathSegments);
    builtPath.addAll([
      "Audio",
      mediaItem.extras!["itemJson"]["Id"],
      "universal",
    ]);

    Uri uri = Uri(
      host: parsedBaseUrl.host,
      port: parsedBaseUrl.port,
      scheme: parsedBaseUrl.scheme,
      pathSegments: builtPath,
      queryParameters: {
        "UserId": _finampUserHelper.currentUser!.id,
        "DeviceId": androidId ?? iosDeviceInfo!.identifierForVendor,
        "ApiKey": _finampUserHelper.currentUser!.accessToken,
      },
    );

    if (mediaItem.extras!["shouldTranscode"]) {
      final queryParameters = Map.of(uri.queryParameters);

      queryParameters.addAll({
        "TranscodingProtocol": "hls",
        "AudioBitRate":
            FinampSettingsHelper.finampSettings.transcodeBitrate.toString(),
      });

      uri = uri.replace(queryParameters: queryParameters);
    }

    return uri;
  }
}

String _jellyfinRepeatMode(LoopMode loopMode) {
  switch (loopMode) {
    case LoopMode.all:
      return "RepeatAll";
    case LoopMode.one:
      return "RepeatOne";
    case LoopMode.off:
      return "RepeatNone";
  }
}

AudioServiceRepeatMode _audioServiceRepeatMode(LoopMode loopMode) {
  switch (loopMode) {
    case LoopMode.off:
      return AudioServiceRepeatMode.none;
    case LoopMode.one:
      return AudioServiceRepeatMode.one;
    case LoopMode.all:
      return AudioServiceRepeatMode.all;
  }
}
