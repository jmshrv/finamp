import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:finamp/services/FinampLogsHelper.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

import 'JellyfinApiData.dart';
import 'DownloadsHelper.dart';
import 'FinampSettingsHelper.dart';
import '../models/JellyfinModels.dart';
import '../main.dart';
import '../setupLogging.dart';

class _FinampShuffleOrder extends DefaultShuffleOrder {
  final int? initialIndex;

  _FinampShuffleOrder({this.initialIndex});

  @override
  void shuffle({int? initialIndex}) {
    super.shuffle(initialIndex: initialIndex);
  }
}

/// This provider handles the currently playing music so that multiple widgets can control music.
class MusicPlayerBackgroundTask extends BackgroundAudioTask {
  final _player = AudioPlayer();
  List<MediaItem> _queue = [];
  ConcatenatingAudioSource _queueAudioSource =
      ConcatenatingAudioSource(children: []);
  AudioProcessingState? _skipState;
  StreamSubscription<PlaybackEvent>? _eventSubscription;
  DateTime? _lastUpdateTime;
  late Logger audioServiceBackgroundTaskLogger;

  /// Set when shuffle mode is changed. If true, [onUpdateQueue] will create a
  /// shuffled [ConcatenatingAudioSource].
  bool shuffleNextQueue = false;

  /// Set when creating a new queue. Will be used to set the first index in a
  /// new queue.
  int? nextInitialIndex;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    try {
      // Set up Hive in this isolate
      await setupHive();
      setupLogging();
      audioServiceBackgroundTaskLogger = Logger("MusicPlayerBackgroundTask");
      audioServiceBackgroundTaskLogger.info("Starting audio service");

      // Set up an instance of JellyfinApiData and DownloadsHelper since get_it
      // can't talk across isolates
      GetIt.instance.registerLazySingleton(() => JellyfinApiData());
      GetIt.instance.registerLazySingleton(() => DownloadsHelper());

      // Initialise FlutterDownloader in this isolate (only needed to check if
      // file download is complete)
      await FlutterDownloader.initialize();

      // Broadcast that we're connecting, and what controls are available.
      _broadcastState();

      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.music());

      // These values will be null if we don't set them here
      await _player.setLoopMode(LoopMode.off);
      await _player.setShuffleModeEnabled(false);

      // Broadcast media item changes.
      _player.currentIndexStream.listen((index) {
        if (index != null) AudioServiceBackground.setMediaItem(_queue[index]);
      });

      // Propagate all events from the audio player to AudioService clients.
      _eventSubscription = _player.playbackEventStream.listen((event) {
        _broadcastState();

        // We don't want to attempt updating playback progress with the server if we're in offline mode
        // We also check if the player actually has the current index, since it is null when we first start playing
        if (!FinampSettingsHelper.finampSettings.isOffline &&
            _player.currentIndex != null) _updatePlaybackProgress();
      });

      await _broadcastState();

      // Special processing for state transitions.
      _player.processingStateStream.listen((state) {
        switch (state) {
          case ProcessingState.completed:
            // In this example, the service stops when reaching the end.
            onStop();
            break;
          case ProcessingState.ready:
            // If we just came from skipping between tracks, clear the skip
            // state now that we're ready to play.
            _skipState = null;
            break;
          default:
            break;
        }
      });
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onPlay() async {
    try {
      await _player.play();
      // Broadcast that we're playing, and what controls are available.
      _broadcastState();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onStop() async {
    try {
      JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
      audioServiceBackgroundTaskLogger.info("Stopping audio service");

      // Tell Jellyfin we're no longer playing audio if we're online
      if (!FinampSettingsHelper.finampSettings.isOffline) {
        jellyfinApiData.stopPlaybackProgress(_generatePlaybackProgressInfo());
      }

      // Stop playing audio.
      await _player.stop();
      await _player.dispose();
      await _eventSubscription?.cancel();
      // It is important to wait for this state to be broadcast before we shut
      // down the task. If we don't, the background task will be destroyed before
      // the message gets sent to the UI.
      await _broadcastState();
      // Shut down this background task
      await super.onStop();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onPause() async {
    try {
      // Pause the audio.
      await _player.pause();
      // Broadcast that we're paused, and what controls are available.
      _broadcastState();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onAddQueueItem(MediaItem mediaItem) async {
    try {
      _queue.add(mediaItem);
      await _queueAudioSource.add(await _mediaItemToAudioSource(mediaItem));
      await _broadcastState();
      await AudioServiceBackground.setQueue(_queue);
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> newQueue) async {
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

      await _broadcastState();
      await AudioServiceBackground.setQueue(_queue);

      // Sets the media item for the new queue. This will be whatever is
      // currently playing from the new queue (for example, the first song in
      // an album). If the player is shuffling, set the index to the player's
      // current index. Otherwise, set it to nextInitialIndex. nextInitialIndex
      // is much more stable than the current index as we know the value is set
      // when running this function.
      if (_player.shuffleModeEnabled) {
        if (_player.currentIndex == null) {
          audioServiceBackgroundTaskLogger.severe(
              "_player.currentIndex is null during onUpdateQueue, not setting new media item");
        } else {
          await AudioServiceBackground.setMediaItem(
              _queue[_player.currentIndex!]);
        }
      } else {
        if (nextInitialIndex == null) {
          audioServiceBackgroundTaskLogger.severe(
              "nextInitialIndex is null during onUpdateQueue, not setting new media item");
        } else {
          await AudioServiceBackground.setMediaItem(_queue[nextInitialIndex!]);
        }
      }

      shuffleNextQueue = false;
      nextInitialIndex = null;
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    try {
      await onStop();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onSkipToPrevious() async {
    try {
      await _player.seekToPrevious();
      await _broadcastState();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onSkipToNext() async {
    try {
      await _player.seekToNext();
      await _broadcastState();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    try {
      await _player.seek(position);
      await _broadcastState();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onSetShuffleMode(AudioServiceShuffleMode shuffleMode) async {
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
      await _broadcastState();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) async {
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
      await _broadcastState();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<dynamic> onCustomAction(String name, dynamic arguments) async {
    try {
      switch (name) {
        case "removeQueueItem":
          await _removeQueueItemAt(arguments);
          break;
        case "getLogs":
          FinampLogsHelper finampLogsHelper =
              GetIt.instance<FinampLogsHelper>();
          return jsonEncode(finampLogsHelper.logs);
        case "copyLogs":
          FinampLogsHelper finampLogsHelper =
              GetIt.instance<FinampLogsHelper>();
          await finampLogsHelper.copyLogs();
          break;
        case "generatePlaybackProgressInfo":
          return _generatePlaybackProgressInfo();
        case "setNextInitialIndex":
          nextInitialIndex = arguments;
          break;
        case "getShuffleIndices":
          return _player.shuffleIndices;
        default:
          return Future.error("Invalid custom action!");
      }
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    try {
      await AudioServiceBackground.setState(
          controls: [
            MediaControl.skipToPrevious,
            if (_player.playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
          ],
          systemActions: [
            MediaAction.seekTo,
            MediaAction.seekForward,
            MediaAction.seekBackward,
            MediaAction.skipToQueueItem,
          ],
          processingState: _getProcessingState(),
          playing: _player.playing,
          position: _player.position,
          bufferedPosition: _player.bufferedPosition,
          repeatMode: _getRepeatMode(),
          shuffleMode: _getShuffleMode());
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> _updatePlaybackProgress() async {
    try {
      JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

      if (_lastUpdateTime == null ||
          DateTime.now().millisecondsSinceEpoch -
                  _lastUpdateTime!.millisecondsSinceEpoch >=
              10000) {
        await jellyfinApiData
            .updatePlaybackProgress(_generatePlaybackProgressInfo());

        // if updatePlaybackProgress fails, the last update time won't be set.
        _lastUpdateTime = DateTime.now();
      }
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState!;
    switch (_player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }

  AudioServiceRepeatMode _getRepeatMode() {
    switch (_player.loopMode) {
      case LoopMode.all:
        return AudioServiceRepeatMode.all;
      case LoopMode.off:
        return AudioServiceRepeatMode.none;
      case LoopMode.one:
        return AudioServiceRepeatMode.one;
      default:
        throw ("Unsupported AudioServiceRepeatMode! Recieved ${_player.loopMode.toString()}, requires all, off, or one.");
    }
  }

  AudioServiceShuffleMode _getShuffleMode() {
    if (_player.shuffleModeEnabled) {
      return AudioServiceShuffleMode.all;
    } else {
      return AudioServiceShuffleMode.none;
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
      audioServiceBackgroundTaskLogger.info("Using transcode URL");
      int transcodeBitRate =
          FinampSettingsHelper.finampSettings.transcodeBitrate;
      return Uri.parse(
          "${jellyfinApiData.currentUser!.baseUrl}/Audio/${mediaItem.extras!["itemId"]}/stream?audioBitRate=$transcodeBitRate&audioCodec=aac&static=false");
    } else {
      return Uri.parse(
          "${jellyfinApiData.currentUser!.baseUrl}/Audio/${mediaItem.extras!["itemId"]}/stream?static=true");
    }
  }

  /// audio_service doesn't have a removeQueueItemAt so I wrote my own.
  /// Pops an item from the queue with the given index and refreshes the queue.
  Future<void> _removeQueueItemAt(int index) async {
    try {
      _queue.removeAt(index);
      await _queueAudioSource.removeAt(index);
      await _broadcastState();
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Generates PlaybackProgressInfo from current player info
  PlaybackProgressInfo _generatePlaybackProgressInfo() {
    try {
      return PlaybackProgressInfo(
        itemId: _queue[_player.currentIndex ?? 0].extras!["itemId"],
        isPaused: !_player.playing,
        isMuted: _player.volume == 0,
        positionTicks: _player.position.inMicroseconds * 10,
        repeatMode: _convertRepeatMode(_player.loopMode),
        playMethod: _queue[_player.currentIndex ?? 0].extras!["shouldTranscode"]
            ? "Transcode"
            : "DirectPlay",
      );
    } catch (e) {
      audioServiceBackgroundTaskLogger.severe(e);
      rethrow;
    }
  }
}

String _convertRepeatMode(LoopMode loopMode) {
  switch (loopMode) {
    case LoopMode.all:
      return "RepeatAll";
    case LoopMode.one:
      return "RepeatOne";
    case LoopMode.off:
      return "RepeatNone";
    default:
      return "RepeatNone";
  }
}
