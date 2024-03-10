import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
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
  final _audioServiceBackgroundTaskLogger = Logger("MusicPlayerBackgroundTask");
  final _replayGainLogger = Logger("ReplayGain");

  final _androidAutoHelper = GetIt.instance<AndroidAutoHelper>();

  AppLocalizations? _appLocalizations;
  bool _localizationsInitialized = false;

  late final AudioPlayer _player;
  late final AudioPipeline _audioPipeline;
  late final List<AndroidAudioEffect> _androidAudioEffects;
  late final List<DarwinAudioEffect> _iosAudioEffects;
  late final AndroidLoudnessEnhancer? _loudnessEnhancerEffect;

  ConcatenatingAudioSource _queueAudioSource =
      ConcatenatingAudioSource(children: []);

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

  double iosBaseVolumeGainFactor = 1.0;

  MusicPlayerBackgroundTask() {
    _audioServiceBackgroundTaskLogger.info("Starting audio service");

    _androidAudioEffects = [];
    _iosAudioEffects = [];

    if (Platform.isAndroid) {
      _loudnessEnhancerEffect = AndroidLoudnessEnhancer();
      _androidAudioEffects.add(_loudnessEnhancerEffect!);
    } else {
      _loudnessEnhancerEffect = null;
    }

    _audioPipeline = AudioPipeline(
      androidAudioEffects: _androidAudioEffects,
      darwinAudioEffects: _iosAudioEffects,
    );

    _player = AudioPlayer(
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
        ),
      ),
      audioPipeline: _audioPipeline,
    );

    _loudnessEnhancerEffect
        ?.setEnabled(FinampSettingsHelper.finampSettings.replayGainActive);
    _loudnessEnhancerEffect?.setTargetGain(0.0 /
        10.0); //!!! always divide by 10, the just_audio implementation has a bug so it expects a value in Bel and not Decibel (remove once https://github.com/ryanheise/just_audio/pull/1092/commits/436b3274d0233818a061ecc1c0856a630329c4e6 is merged)
    // calculate base volume gain for iOS as a linear factor, because just_audio doesn't yet support AudioEffect on iOS
    iosBaseVolumeGainFactor = pow(10.0,
            FinampSettingsHelper.finampSettings.replayGainIOSBaseGain / 20.0)
        as double; // https://sound.stackexchange.com/questions/38722/convert-db-value-to-linear-scale
    if (!Platform.isAndroid) {
      _replayGainLogger.info(
          "non-Android base volume gain factor: $iosBaseVolumeGainFactor");
    }

    // Propagate all events from the audio player to AudioService clients.
    _player.playbackEventStream.listen((event) async {
      playbackState.add(_transformEvent(event));
    });

    FinampSettingsHelper.finampSettingsListener.addListener(() {
      // update replay gain settings every time settings are changed
      iosBaseVolumeGainFactor = pow(10.0,
              FinampSettingsHelper.finampSettings.replayGainIOSBaseGain / 20.0)
          as double; // https://sound.stackexchange.com/questions/38722/convert-db-value-to-linear-scale
      if (FinampSettingsHelper.finampSettings.replayGainActive) {
        _loudnessEnhancerEffect?.setEnabled(true);
        _applyReplayGain(mediaItem.valueOrNull);
      } else {
        _loudnessEnhancerEffect?.setEnabled(false);
        _player.setVolume(1.0); // disable replay gain on iOS
        _replayGainLogger.info("Replay gain disabled");
      }
    });

    mediaItem.listen((currentTrack) {
      _applyReplayGain(currentTrack);
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
  Future<void> skipToPrevious({
    bool forceSkip = false,
  }) async {
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
        if (doSkip || forceSkip) {
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
      await _player.seek(Duration.zero,
          index: _player.shuffleModeEnabled
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

  List<MediaItem> _getRootMenu() {
    return [
      MediaItem(
          id: MediaItemId(contentType: TabContentType.albums, parentType: MediaItemParentType.rootCollection).toString(),
          title: _appLocalizations?.albums ?? TabContentType.albums.toString(),
          playable: false,
      ),
      MediaItem(
          id: MediaItemId(contentType: TabContentType.artists, parentType: MediaItemParentType.rootCollection).toString(),
          title: _appLocalizations?.artists ?? TabContentType.artists.toString(),
          playable: false,
      ),
      MediaItem(
          id: MediaItemId(contentType: TabContentType.playlists, parentType: MediaItemParentType.rootCollection).toString(),
          title: _appLocalizations?.playlists ?? TabContentType.playlists.toString(),
          playable: false,
      ),
      MediaItem(
          id: MediaItemId(contentType: TabContentType.genres, parentType: MediaItemParentType.rootCollection).toString(),
          title: _appLocalizations?.genres ?? TabContentType.genres.toString(),
          playable: false,
      )];
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

      return _getRootMenu();
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
    
    final previousItemTitle = _androidAutoHelper.lastSearchQuery?.extras?["android.intent.extra.title"];
    
    final currentSearchQuery = AndroidAutoSearchQuery(query, extras);
    
    if (previousItemTitle != null) {
      // when voice searching for a song with title + artist, Android Auto / Google Assistant combines the title and artist into a single query, with no way to differentiate them
      // so we try to instead use the title provided in the extras right after the voice search, and just search for that
      if (query.contains(previousItemTitle)) {
        // if the the title is fully contained in the query, we can assume that the user clicked on the "Search Results" button on the player screen
        currentSearchQuery.query = previousItemTitle;
        currentSearchQuery.extras = _androidAutoHelper.lastSearchQuery?.extras;
      } else {
        // otherwise, we assume they're searching for something else, and discard the previous search query
        _androidAutoHelper.setLastSearchQuery(null);
      }
    }

    return await _androidAutoHelper.searchItems(currentSearchQuery);
    
  }

  // voice search
  @override
  Future<void> playFromSearch(String query, [Map<String, dynamic>? extras]) async {
    _audioServiceBackgroundTaskLogger.info("playFromSearch: $query ; extras: $extras");
    final searchQuery = AndroidAutoSearchQuery(query, extras);
    _androidAutoHelper.setLastSearchQuery(searchQuery);
    await _androidAutoHelper.playFromSearch(searchQuery);
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

  void _applyReplayGain(MediaItem? currentTrack) {
    if (FinampSettingsHelper.finampSettings.replayGainActive &&
        currentTrack != null) {
      final baseItem = jellyfin_models.BaseItemDto.fromJson(
          currentTrack.extras?["itemJson"]);

      double? effectiveLufs;
      switch (FinampSettingsHelper.finampSettings.replayGainMode) {
        case ReplayGainMode.hybrid:
          // use context LUFS if available, otherwise use track LUFS
          effectiveLufs = currentTrack.extras?["contextLufs"] ?? baseItem.lufs;
          break;
        case ReplayGainMode.trackOnly:
          // only ever use track LUFS
          effectiveLufs = baseItem.lufs;
          break;
        case ReplayGainMode.albumOnly:
          // only ever use context LUFS, don't normalize tracks out of special contexts
          effectiveLufs = currentTrack.extras?["contextLufs"];
          break;
      }

      _replayGainLogger.info(
          "LUFS for '${baseItem.name}': ${effectiveLufs} (track lufs: ${baseItem.lufs})");
      if (effectiveLufs != null) {
        final gainChange = (FinampSettingsHelper
                    .finampSettings.replayGainTargetLufs -
                effectiveLufs!) *
            FinampSettingsHelper.finampSettings.replayGainNormalizationFactor;
        _replayGainLogger.info(
            "Gain change: ${FinampSettingsHelper.finampSettings.replayGainTargetLufs - effectiveLufs} (raw), $gainChange (adjusted)");
        if (Platform.isAndroid) {
          _loudnessEnhancerEffect?.setTargetGain(gainChange /
              10.0); //!!! always divide by 10, the just_audio implementation has a bug so it expects a value in Bel and not Decibel (remove once https://github.com/ryanheise/just_audio/pull/1092/commits/436b3274d0233818a061ecc1c0856a630329c4e6 is merged)
        } else {
          final newVolume = iosBaseVolumeGainFactor *
              pow(
                  10.0,
                  gainChange /
                      20.0); // https://sound.stackexchange.com/questions/38722/convert-db-value-to-linear-scale
          final newVolumeClamped = newVolume.clamp(0.0, 1.0);
          _replayGainLogger
              .finer("new volume: $newVolume ($newVolumeClamped clipped)");
          _player.setVolume(newVolumeClamped);
        }
      } else {
        // reset gain offset
        _loudnessEnhancerEffect?.setTargetGain(0 /
            10.0); //!!! always divide by 10, the just_audio implementation has a bug so it expects a value in Bel and not Decibel (remove once https://github.com/ryanheise/just_audio/pull/1092/commits/436b3274d0233818a061ecc1c0856a630329c4e6 is merged)
        _player.setVolume(
            iosBaseVolumeGainFactor); //!!! it's important that the base gain is used instead of 1.0, so that any tracks without LUFS information don't fall back to full volume, but to the base volume for iOS
      }
    }
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
