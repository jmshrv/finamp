import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import 'JellyfinApiData.dart';
import '../models/JellyfinModels.dart';

/// This provider handles the currently playing music so that multiple widgets can control music.
class MusicPlayerBackgroundTask extends BackgroundAudioTask {
  final _player = AudioPlayer();
  List<MediaItem> _queue = [];
  ConcatenatingAudioSource _queueAudioSource =
      ConcatenatingAudioSource(children: []);
  AudioProcessingState _skipState;
  StreamSubscription<PlaybackEvent> _eventSubscription;

  // This map holds the response from getPlaybackInfo so we don't have to keep calling it every time we change the queue.
  // It will gradually grow as the user listens to different songs but won't be wiped unless the user closes the app/stops the service.
  Map<String, MediaSourceInfo> _queueSourceInfo = {};

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    print("Starting audio service");

    // Set up an instance of JellyfinApiData since get_it can't talk across isolates
    _setupLogging();
    GetIt.instance.registerLazySingleton(() => JellyfinApiData());

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
  }

  @override
  Future<void> onPlay() async {
    await _player.play();
    // Broadcast that we're playing, and what controls are available.
    _broadcastState();
  }

  @override
  Future<void> onStop() async {
    print("Stopping audio service");
    // Stop playing audio.
    await _player.stop();
    await _player.dispose();
    await _eventSubscription.cancel();
    // It is important to wait for this state to be broadcast before we shut
    // down the task. If we don't, the background task will be destroyed before
    // the message gets sent to the UI.
    await _broadcastState();
    // Shut down this background task
    await super.onStop();
  }

  @override
  Future<void> onPause() async {
    // Pause the audio.
    await _player.pause();
    // Broadcast that we're paused, and what controls are available.
    _broadcastState();
  }

  @override
  Future<void> onAddQueueItem(MediaItem mediaItem) async {
    _queue.add(mediaItem);
    await _queueAudioSource.add(await _mediaItemToAudioSource(mediaItem));
    await _player.load(_queueAudioSource);
    await _broadcastState();
    await AudioServiceBackground.setQueue(_queue);
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> newQueue) async {
    _queue = newQueue;
    await _queueAudioSource.clear();

    List<AudioSource> audioSources = [];
    for (final mediaItem in _queue) {
      audioSources.add(await _mediaItemToAudioSource(mediaItem));
    }

    await _queueAudioSource.addAll(audioSources);
    await _player.load(_queueAudioSource);
    await _broadcastState();
    await AudioServiceBackground.setQueue(_queue);
    await AudioServiceBackground.setMediaItem(_queue[0]);
  }

  @override
  Future<void> onTaskRemoved() async {
    await onStop();
    await _broadcastState();
  }

  @override
  Future<void> onSkipToPrevious() async {
    await _player.seekToPrevious();
    await _broadcastState();
  }

  @override
  Future<void> onSkipToNext() async {
    await _player.seekToNext();
    await _broadcastState();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    await _player.seek(position);
    await _broadcastState();
  }

  @override
  Future<void> onSetShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    switch (shuffleMode) {
      case AudioServiceShuffleMode.all:
        await _player.setShuffleModeEnabled(true);
        break;
      case AudioServiceShuffleMode.none:
        await _player.setShuffleModeEnabled(false);
        break;
      default:
        return Future.error(
            "Unsupported AudioServiceRepeatMode! Recieved ${shuffleMode.toString()}, requires all or none.");
    }
    await _broadcastState();
  }

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) async {
    // TODO: This may not work on iOS
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
  }

  @override
  Future<dynamic> onCustomAction(String name, dynamic arguments) async {
    switch (name) {
      case "removeQueueItem":
        await _removeQueueItemAt(arguments);
        break;
      default:
        return Future.error("Invalid custom action!");
    }
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
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
        ],
        processingState: _getProcessingState(),
        playing: _player.playing,
        position: _player.position,
        bufferedPosition: _player.bufferedPosition,
        repeatMode: _getRepeatMode(),
        shuffleMode: _getShuffleMode());
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState;
    switch (_player.processingState) {
      case ProcessingState.none:
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
        break;
      case LoopMode.off:
        return AudioServiceRepeatMode.none;
        break;
      case LoopMode.one:
        return AudioServiceRepeatMode.one;
        break;
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
    JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
    String baseUrl = await jellyfinApiData.getBaseUrl();
    Directory appDir = await getApplicationDocumentsDirectory();
    File offlineBaseItemDtoFile =
        File("${appDir.path}/songs/${mediaItem.id}-BaseItemDto.json");
    File offlineMediaSourceInfoFile =
        File("${appDir.path}/songs/${mediaItem.id}-MediaSourceInfo.json");

    if (await offlineBaseItemDtoFile.exists()) {
      // TODO: Check if the download is complete before deciding to use the offline file
      print("Song exists offline, using local file");
      BaseItemDto offlineBaseItemDto = BaseItemDto.fromJson(
          jsonDecode(await offlineBaseItemDtoFile.readAsString()));
      MediaSourceInfo offlineMediaSourceInfo = MediaSourceInfo.fromJson(
          jsonDecode(await offlineMediaSourceInfoFile.readAsString()));
      return AudioSource.uri(Uri.file(
          "${appDir.path}/songs/${mediaItem.id}.${offlineMediaSourceInfo.container}"));
    } else {
      return AudioSource.uri(
          Uri.parse("$baseUrl/Audio/${mediaItem.id}/stream?static=true"));
    }
  }

  /// audio_service doesn't have a removeQueueItemAt so I wrote my own.
  /// Pops an item from the queue with the given index and refreshes the queue.
  Future<void> _removeQueueItemAt(int index) async {
    _queue.removeAt(index);
    await _queueAudioSource.removeAt(index);
    await _player.load(_queueAudioSource);
    await _broadcastState();
    await AudioServiceBackground.setQueue(_queue);
  }
}

// Future<void> setUrl(BaseItemDto item) async {
//   String baseUrl = await _jellyfinApiData.getBaseUrl();
//   print(
//       "Setting audio URL to $baseUrl/Audio/${item.id}/stream?Container=flac");
//   player.setUrl("$baseUrl/Audio/${item.id}/stream?Container=flac");
//   player.play();
// }

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) =>
      print("[${event.level.name}] ${event.time}: ${event.message}"));
}
