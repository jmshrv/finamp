import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:finamp/services/offline_listen_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

import 'audio_service_helper.dart';
import 'finamp_settings_helper.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'locale_helper.dart';
import 'android_auto_helper.dart';

/// This provider handles the currently playing music so that multiple widgets
/// can control music.
class MusicPlayerBackgroundTask extends BaseAudioHandler {
  final _androidAutoHelper = GetIt.instance<AndroidAutoHelper>();

  AppLocalizations? _appLocalizations;
  bool _localizationsInitialized = false;

  final _player = AudioPlayer(
    audioLoadConfiguration: AudioLoadConfiguration(
        androidLoadControl: AndroidLoadControl(
          minBufferDuration: FinampSettingsHelper.finampSettings.bufferDuration,
          maxBufferDuration: FinampSettingsHelper
                  .finampSettings.bufferDuration *
              1.5, // allows the player to fetch a bit more data in exchange for reduced request frequency
          prioritizeTimeOverSizeThresholds: true,
        ),
        darwinLoadControl: DarwinLoadControl(
          preferredForwardBufferDuration:
              FinampSettingsHelper.finampSettings.bufferDuration,
        )),
  );
  ConcatenatingAudioSource _queueAudioSource = ConcatenatingAudioSource(
    children: [],
  );
  final _audioServiceBackgroundTaskLogger = Logger("MusicPlayerBackgroundTask");

  /// Set when creating a new queue. Will be used to set the first index in a
  /// new queue.
  int? nextInitialIndex;

  Duration _sleepTimerDuration = Duration.zero;
  DateTime _sleepTimerStartTime = DateTime.now();
  /// Holds the current sleep timer, if any. This is a ValueNotifier so that
  /// widgets like SleepTimerButton can update when the sleep timer is/isn't
  /// null.
  final ValueNotifier<Timer?> _sleepTimer = ValueNotifier<Timer?>(null);

  Future<bool> Function()? _queueCallbackPreviousTrack;

  List<int>? get shuffleIndices => _player.shuffleIndices;

  ValueListenable<Timer?> get sleepTimer => _sleepTimer;

  MusicPlayerBackgroundTask() {
    _audioServiceBackgroundTaskLogger.info("Starting audio service");

    // Propagate all events from the audio player to AudioService clients.
    _player.playbackEventStream.listen((event) async {
      playbackState.add(_transformEvent(event));
    });

    // Special processing for state transitions.
    _player.processingStateStream.listen((event) {
      if (event == ProcessingState.completed) {
        stop();
      }
    });

    // PlaybackEvent doesn't include shuffle/loops so we listen for changes here
    _player.shuffleModeEnabledStream.listen((_) {
      final event = _transformEvent(_player.playbackEvent);
      playbackState.add(event);
      _audioServiceBackgroundTaskLogger.info(
          "Shuffle mode changed to ${event.shuffleMode} (${_player.shuffleModeEnabled}).");
    });
    _player.loopModeStream.listen((_) {
      final event = _transformEvent(_player.playbackEvent);
      playbackState.add(event);
      _audioServiceBackgroundTaskLogger.info(
          "Loop mode changed to ${event.repeatMode} (${_player.loopMode}).");
    });
  }

  /// this could be useful for updating queue state from this player class, but isn't used right now due to limitations with just_audio
  void setQueueCallbacks({
    required Future<bool> Function() previousTrackCallback,
  }) {
    _queueCallbackPreviousTrack = previousTrackCallback;
  }

  Future<void> initializeAudioSource(ConcatenatingAudioSource source) async {
    _queueAudioSource = source;

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
      _audioServiceBackgroundTaskLogger.severe("Player error ${e.toString()}");
    }
  }

  @override
  Future<void> play() {
    return _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  Future<void> togglePlayback() {
    if (_player.playing) {
      return pause();
    } else {
      return play();
    }
  }

  @override
  Future<void> stop() async {
    try {
      _audioServiceBackgroundTaskLogger.info("Stopping audio service");

      // Stop playing audio.
      await _player.stop();

      mediaItem.add(null);
      playbackState.add(playbackState.value
          .copyWith(processingState: AudioProcessingState.completed));

      // // Seek to the start of the current item
      await _player.seek(Duration.zero);

      _sleepTimerDuration = Duration.zero;

      _sleepTimer.value?.cancel();
      _sleepTimer.value = null;

      await super.stop();
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  int getPlayPositionInSeconds() {
    return _player.position.inSeconds;
  }

  @override
  Future<void> skipToPrevious() async {
    bool doSkip = true;

    try {
      if (_queueCallbackPreviousTrack != null) {
        doSkip = await _queueCallbackPreviousTrack!();
      } else {
        doSkip = _player.position.inSeconds < 5;
      }

      if (!_player.hasPrevious) {
        await _player.seek(Duration.zero);
      } else {
        if (doSkip) {
          if (_player.loopMode == LoopMode.one) {
            // if the user manually skips to the previous track, they probably want to actually skip to the previous track
            await skipByOffset(
                -1); //!!! don't use _player.previousIndex here, because that adjusts based on loop mode
          } else {
            await _player.seekToPrevious();
          }
        } else {
          await _player.seek(Duration.zero);
        }
      }
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> skipToNext() async {
    try {
      if (_player.loopMode == LoopMode.one && _player.hasNext) {
        // if the user manually skips to the next track, they probably want to actually skip to the next track
        await skipByOffset(
            1); //!!! don't use _player.nextIndex here, because that adjusts based on loop mode
      } else {
        await _player.seekToNext();
      }
      _audioServiceBackgroundTaskLogger
          .finer("_player.nextIndex: ${_player.nextIndex}");
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> skipByOffset(int offset) async {
    _audioServiceBackgroundTaskLogger.fine("skipping by offset: $offset");

    try {
      await _player.seek(Duration.zero,
          index: _player.shuffleModeEnabled
              ? _queueAudioSource.shuffleIndices[_queueAudioSource
                      .shuffleIndices
                      .indexOf(_player.currentIndex ?? 0) + offset]
              : (_player.currentIndex ?? 0) + offset);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> skipToIndex(int index) async {
    _audioServiceBackgroundTaskLogger.fine("skipping to index: $index");

    try {
      await _player.seek(Duration.zero, index: _player.shuffleModeEnabled
              ? _queueAudioSource.shuffleIndices[index]
              : index);
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

  Future<void> shuffle() async {
    try {
      await _player.shuffle();
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
          break;
        case AudioServiceShuffleMode.none:
          await _player.setShuffleModeEnabled(false);
          break;
        default:
          return Future.error(
              "Unsupported AudioServiceRepeatMode! Received ${shuffleMode.toString()}, requires all or none.");
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
              "Unsupported AudioServiceRepeatMode! Received ${repeatMode.toString()}, requires all, none, or one.");
      }
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  // menus
  @override
  Future<List<MediaItem>> getChildren(String parentMediaId, [Map<String, dynamic>? options]) async {

    // display root category/parent
    if (parentMediaId == AudioService.browsableRootId) {
      if (!_localizationsInitialized) {
        _appLocalizations = await AppLocalizations.delegate.load(
            LocaleHelper.locale ?? const Locale("en", "US"));
        _localizationsInitialized = true;
      }

      return !FinampSettingsHelper.finampSettings.isOffline ? [
        MediaItem(
            id: MediaItemId(contentType: TabContentType.albums, parentType: MediaItemParentType.rootCollection).toString(),
            title: _appLocalizations?.albums ?? TabContentType.albums.toString(),
            playable: false
        ),
        MediaItem(
            id: MediaItemId(contentType: TabContentType.artists, parentType: MediaItemParentType.rootCollection).toString(),
            title: _appLocalizations?.artists ?? TabContentType.artists.toString(),
            playable: false
        ),
        MediaItem(
            id: MediaItemId(contentType: TabContentType.playlists, parentType: MediaItemParentType.rootCollection).toString(),
            title: _appLocalizations?.playlists ?? TabContentType.playlists.toString(),
            playable: false
        ),
        MediaItem(
            id: MediaItemId(contentType: TabContentType.genres, parentType: MediaItemParentType.rootCollection).toString(),
            title: _appLocalizations?.genres ?? TabContentType.genres.toString(),
            playable: false
        )] : [ // display only albums and playlists if in offline mode
        MediaItem(
            id: MediaItemId(contentType: TabContentType.albums, parentType: MediaItemParentType.rootCollection).toString(),
            title: _appLocalizations?.albums ?? TabContentType.albums.toString(),
            playable: false
        ),
        MediaItem(
            id: MediaItemId(contentType: TabContentType.playlists, parentType: MediaItemParentType.rootCollection).toString(),
            title: _appLocalizations?.playlists ?? TabContentType.playlists.toString(),
            playable: false
        ),
      ];
    }
    // else if (parentMediaId == AudioService.recentRootId) {
    //   return await _androidAutoHelper.getRecentItems();
    // }

    try {
      final itemId = MediaItemId.fromJson(jsonDecode(parentMediaId));

      return await _androidAutoHelper.getMediaItems(itemId);
      
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return super.getChildren(parentMediaId);
    }
  }

  // play specific item
  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) async {
    try {
      
      final mediaItemId = MediaItemId.fromJson(jsonDecode(mediaId));

      return await _androidAutoHelper.playFromMediaId(mediaItemId);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return super.playFromMediaId(mediaId, extras);
    }
  }

  // keyboard search
  @override
  Future<List<MediaItem>> search(String query, [Map<String, dynamic>? extras]) async {
    _audioServiceBackgroundTaskLogger.info("search: $query ; extras: $extras");

    return await _androidAutoHelper.searchItems(query, extras);
    
  }

  // voice search
  @override
  Future<void> playFromSearch(String query, [Map<String, dynamic>? extras]) async {
    _audioServiceBackgroundTaskLogger.info("playFromSearch: $query ; extras: $extras");
    await _androidAutoHelper.playFromSearch(query, extras);
  }

  @override
  Future<dynamic> customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'shuffle':
          return await _androidAutoHelper.toggleShuffle();
    }

    return await super.customAction(name, extras);
  }

  // triggers when skipping to specific item in android auto queue
  @override
  Future<void> skipToQueueItem(int index) async {
    skipToIndex(index);
  }

  void setNextInitialIndex(int index) {
    nextInitialIndex = index;
  }

  /// Sets the sleep timer with the given [duration].
  Timer setSleepTimer(Duration duration) {
    _sleepTimerDuration = duration;
    _sleepTimerStartTime = DateTime.now();

    _sleepTimer.value = Timer(duration, () async {
      _sleepTimer.value = null;
      return await pause();
    });
    return _sleepTimer.value!;
  }

  /// Cancels the sleep timer and clears it.
  void clearSleepTimer() {
    _sleepTimerDuration = Duration.zero;

    _sleepTimer.value?.cancel();
    _sleepTimer.value = null;
  }

  Duration get sleepTimerRemaining {
    if (_sleepTimer.value == null) {
      return Duration.zero;
    } else {
      return _sleepTimerStartTime
          .add(_sleepTimerDuration)
          .difference(DateTime.now());
    }
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
        MediaControl.custom(
            androidIcon: _player.shuffleModeEnabled
                ? "drawable/baseline_shuffle_on_24"
                : "drawable/baseline_shuffle_24",
            label: "Shuffle",
            name: "shuffle"
      )],
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
      queueIndex: _player.shuffleModeEnabled && (shuffleIndices?.isNotEmpty ?? false) && event.currentIndex != null ? shuffleIndices!.indexOf(event.currentIndex!) : event.currentIndex,
      shuffleMode: _player.shuffleModeEnabled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      repeatMode: _audioServiceRepeatMode(_player.loopMode),
    );
  }

  List<IndexedAudioSource>? get effectiveSequence =>
      _player.sequenceState?.effectiveSequence;
  double get volume => _player.volume;
  bool get paused => !_player.playing;
  Duration get playbackPosition => _player.position;
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
