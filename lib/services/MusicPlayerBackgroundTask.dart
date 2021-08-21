import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

import 'JellyfinApiData.dart';
import 'DownloadsHelper.dart';
import 'FinampSettingsHelper.dart';
import '../models/JellyfinModels.dart';

class _FinampShuffleOrder extends DefaultShuffleOrder {
  final int? initialIndex;

  _FinampShuffleOrder({this.initialIndex});

  @override
  void shuffle({int? initialIndex}) {
    super.shuffle(initialIndex: initialIndex);
  }
}

/// This provider handles the currently playing music so that multiple widgets
/// can control music.
class MusicPlayerBackgroundTask extends BaseAudioHandler {
  final _player = AudioPlayer();
  List<MediaItem> _queue = [];
  ConcatenatingAudioSource _queueAudioSource =
      ConcatenatingAudioSource(children: []);
  DateTime? _lastUpdateTime;
  final _audioServiceBackgroundTaskLogger = Logger("MusicPlayerBackgroundTask");
  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();

  /// Set when shuffle mode is changed. If true, [onUpdateQueue] will create a
  /// shuffled [ConcatenatingAudioSource].
  bool shuffleNextQueue = false;

  /// Set when creating a new queue. Will be used to set the first index in a
  /// new queue.
  int? nextInitialIndex;

  /// The item that was previously played. Used for reporting playback status.
  MediaItem? _previousItem;

  MusicPlayerBackgroundTask() {
    _audioServiceBackgroundTaskLogger.info("Starting audio service");

    // Propagate all events from the audio player to AudioService clients.
    _player.playbackEventStream.listen((event) {
      playbackState.add(_transformEvent(event));

      // We don't want to attempt updating playback progress with the server
      // if we're in offline mode We also check if the player actually has the
      // current index, since it is null when we first start playing. We also
      // don't update the progress if the processing state is completed to
      // avoid sending a progress update after a stop command.
      if (!FinampSettingsHelper.finampSettings.isOffline &&
          _player.currentIndex != null &&
          event.processingState != ProcessingState.completed)
        _updatePlaybackProgress();
    });

    // // Special processing for state transitions.
    // _player.processingStateStream.listen((state) {
    //   switch (state) {
    //     case ProcessingState.completed:
    //       // In this example, the service stops when reaching the end.
    //       onStop();
    //       break;
    //     case ProcessingState.ready:
    //       // If we just came from skipping between tracks, clear the skip
    //       // state now that we're ready to play.
    //       _skipState = null;
    //       break;
    //     default:
    //       break;
    //   }
    // });

    _player.currentIndexStream.listen((event) async {
      if (event != null) {
        mediaItem.add(_queue[event]);
      }

      if (event != null && !FinampSettingsHelper.finampSettings.isOffline) {
        final _jellyfinApiData = GetIt.instance<JellyfinApiData>();

        if (_previousItem != null) {
          final playbackData = generatePlaybackProgressInfo(
            item: _previousItem,
            includeNowPlayingQueue: true,
          );

          if (playbackData != null) {
            await _jellyfinApiData.stopPlaybackProgress(playbackData);
          }
        }

        final playbackData = generatePlaybackProgressInfo(
          item: _queue[event],
          includeNowPlayingQueue: true,
        );

        if (playbackData != null) {
          await _jellyfinApiData.reportPlaybackStart(playbackData);
        }

        _previousItem = _queue[event];
      }
    });

    // PlaybackEvent doesn't include shuffle/loops so we listen for changes here
    _player.shuffleModeEnabledStream.listen(
        (_) => playbackState.add(_transformEvent(_player.playbackEvent)));
    _player.loopModeStream.listen(
        (_) => playbackState.add(_transformEvent(_player.playbackEvent)));
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    try {
      _audioServiceBackgroundTaskLogger.info("Stopping audio service");

      // Clear the previous item.
      _previousItem = null;

      // Tell Jellyfin we're no longer playing audio if we're online
      if (!FinampSettingsHelper.finampSettings.isOffline) {
        final playbackInfo =
            generatePlaybackProgressInfo(includeNowPlayingQueue: false);
        if (playbackInfo != null) {
          await _jellyfinApiData.stopPlaybackProgress(playbackInfo);
        }
      }

      // // Stop playing audio.
      await _player.stop();
      // await _player.dispose();
      // await _eventSubscription?.cancel();
      // // It is important to wait for this state to be broadcast before we shut
      // // down the task. If we don't, the background task will be destroyed before
      // // the message gets sent to the UI.
      // await _broadcastState();
      // // Shut down this background task
      // await super.stop();
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    try {
      _queue.add(mediaItem);
      await _queueAudioSource.add(await _mediaItemToAudioSource(mediaItem));
      queue.add(_queue);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    try {
      _queue = newQueue;

      // Convert the MediaItems to AudioSources
      List<AudioSource> audioSources = [];
      for (final mediaItem in _queue) {
        audioSources.add(await _mediaItemToAudioSource(mediaItem));
      }

      // Create a new ConcatenatingAudioSource with the new queue. If shuffleNextQueue is set, we shuffle songs.
      _queueAudioSource = ConcatenatingAudioSource(
        children: audioSources,
        shuffleOrder: shuffleNextQueue
            ? _FinampShuffleOrder(initialIndex: nextInitialIndex)
            : null,
      );

      await _player.setAudioSource(
        _queueAudioSource,
        initialIndex: nextInitialIndex,
      );
      queue.add(_queue);

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
          mediaItem.add(_queue[_player.currentIndex!]);
        }
      } else {
        if (nextInitialIndex == null) {
          _audioServiceBackgroundTaskLogger.severe(
              "nextInitialIndex is null during onUpdateQueue, not setting new media item");
        } else {
          mediaItem.add(_queue[nextInitialIndex!]);
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
  Future<void> onTaskRemoved() async {
    try {
      await stop();
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
      _queue.removeAt(index);
      await _queueAudioSource.removeAt(index);
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
    if (_queue.length == 0 && item == null) {
      // This function relies on _queue having items, so we return null if it's
      // empty to avoid more errors.
      return null;
    }

    try {
      return PlaybackProgressInfo(
          itemId: item?.extras!["itemId"] ??
              _queue[_player.currentIndex ?? 0].extras!["itemId"],
          isPaused: !_player.playing,
          isMuted: _player.volume == 0,
          positionTicks: _player.position.inMicroseconds * 10,
          repeatMode: _jellyfinRepeatMode(_player.loopMode),
          playMethod: item?.extras!["shouldTranscode"] ??
                  _queue[_player.currentIndex ?? 0].extras!["shouldTranscode"]
              ? "Transcode"
              : "DirectPlay",
          nowPlayingQueue: includeNowPlayingQueue
              ? _queue
                  .map((e) =>
                      QueueItem(id: e.extras!["itemId"], playlistItemId: e.id))
                  .toList()
              : null);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      rethrow;
    }
  }

  void setNextInitialIndex(int index) {
    nextInitialIndex = index;
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

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    // When we're moving an item backwards, we need to reduce newIndex by 1 to
    // account for there being a new item added before newIndex.
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final oldMediaItem = _queue.removeAt(oldIndex);
    final oldAudioSource = _queueAudioSource[oldIndex];
    await _queueAudioSource.removeAt(oldIndex);

    _queue.insert(newIndex, oldMediaItem);
    await _queueAudioSource.insert(newIndex, oldAudioSource);
  }

  List<int>? get shuffleIndices => _player.shuffleIndices;

  Future<void> _updatePlaybackProgress() async {
    try {
      JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

      if (_lastUpdateTime == null ||
          DateTime.now().millisecondsSinceEpoch -
                  _lastUpdateTime!.millisecondsSinceEpoch >=
              10000) {
        final playbackInfo =
            generatePlaybackProgressInfo(includeNowPlayingQueue: false);
        if (playbackInfo != null) {
          await jellyfinApiData.updatePlaybackProgress(playbackInfo);
        }

        // if updatePlaybackProgress fails, the last update time won't be set.
        _lastUpdateTime = DateTime.now();
      }
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Syncs the list of MediaItems (_queue) with the internal queue of the player.
  /// Called by onAddQueueItem and onUpdateQueue.
  Future<AudioSource> _mediaItemToAudioSource(MediaItem mediaItem) async {
    if (mediaItem.extras!["downloadedSongJson"] == "null") {
      // If DownloadedSong wasn't passed, we assume that the item is not
      // downloaded.

      // If offline, we throw an error so that we don't accidentally stream from
      // the internet. See the big comment in _songUri() to see why this was
      // passed in extras.
      if (mediaItem.extras!["isOffline"]) {
        return Future.error(
            "Offline mode enabled but downloaded song not found.");
      } else {
        return AudioSource.uri(_songUri(mediaItem));
      }
    } else {
      // We have to deserialise this because Dart is stupid and can't handle
      // sending classes through isolates.
      final downloadedSong = DownloadedSong.fromJson(
          jsonDecode(mediaItem.extras!["downloadedSongJson"]));

      // Path verification and stuff is done in AudioServiceHelper, so this path
      // should be valid.
      return AudioSource.uri(Uri.file(downloadedSong.path));
    }
  }

  Uri _songUri(MediaItem mediaItem) {
    JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

    // When creating the MediaItem (usually in AudioServiceHelper), we specify
    // whether or not to transcode. We used to pull from FinampSettings here,
    // but since audio_service runs in an isolate (or at least, it does until
    // 0.18), the value would be wrong if changed while a song was playing since
    // Hive is bad at multi-isolate stuff.
    if (mediaItem.extras!["shouldTranscode"]) {
      _audioServiceBackgroundTaskLogger.info("Using transcode URL");
      int transcodeBitRate =
          FinampSettingsHelper.finampSettings.transcodeBitrate;
      return Uri.parse(
          "${jellyfinApiData.currentUser!.baseUrl}/Audio/${mediaItem.extras!["itemId"]}/stream?audioBitRate=$transcodeBitRate&audioCodec=aac&static=false");
    } else {
      return Uri.parse(
          "${jellyfinApiData.currentUser!.baseUrl}/Audio/${mediaItem.extras!["itemId"]}/stream?static=true");
    }
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
