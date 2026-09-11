import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/favorite_provider.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/playback_history_service.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:finamp/services/radio_service_helper.dart' as radio_service_helper;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

import 'android_auto_helper.dart';
import 'finamp_settings_helper.dart';
import 'ios_helpers.dart';
import 'metadata_provider.dart';

enum FadeDirection { fadeIn, fadeOut, none }

class FadeState {
  late final double fadeVolume;

  final double volumeFadeOutStepSize;
  final double volumeFadeInStepSize;

  final FadeDirection fadeDirection;

  FadeState({
    required this.fadeVolume,
    this.volumeFadeInStepSize = 0.0,
    this.volumeFadeOutStepSize = 0.0,
    this.fadeDirection = FadeDirection.none,
  });

  FadeState copyWith({
    double? recoverVolume,
    double? fadeVolume,
    double? volumeFadeInStepSize,
    double? volumeFadeOutStepSize,
    FadeDirection? fadeDirection,
  }) {
    return FadeState(
      fadeVolume: fadeVolume ?? this.fadeVolume,
      volumeFadeInStepSize: volumeFadeInStepSize ?? this.volumeFadeInStepSize,
      volumeFadeOutStepSize: volumeFadeOutStepSize ?? this.volumeFadeOutStepSize,
      fadeDirection: fadeDirection ?? this.fadeDirection,
    );
  }
}

class PlayerVolumeController {
  static final _volumeLogger = Logger("Volume");

  PlayerVolumeController(this._player) {
    _updateVolume();
  }

  final AudioPlayer _player;

  double _internalVolume = FinampSettingsHelper.finampSettings.currentVolume;
  double _replayGainVolume = 1.0;
  double _fadeVolume = 1.0;
  bool isDucked = false;

  Future<void> setInternalVolume(double volume) {
    if (volume == _internalVolume) return Future.value();
    _internalVolume = volume;
    FinampSetters.setCurrentVolume(volume);
    return _updateVolume();
  }

  Future<void> setReplayGainVolume(double volume) {
    if (volume == _replayGainVolume) return Future.value();
    _replayGainVolume = volume;
    return _updateVolume();
  }

  Future<void> setFadeVolume(double volume) {
    if (volume == _fadeVolume) return Future.value();
    _fadeVolume = volume;
    return _updateVolume();
  }

  void duck() {
    if (isDucked) return;
    isDucked = true;
    _updateVolume();
  }

  void unduck() {
    if (!isDucked) return;
    isDucked = false;
    _updateVolume();
  }

  Future<void> _updateVolume() {
    var vol1 = _internalVolume.clamp(0.0, 1.0);
    var vol2 = _replayGainVolume.clamp(0.0, 1.0);
    var vol3 = _fadeVolume.clamp(0.0, 1.0);
    var duckingFactor = isDucked ? 0.3 : 1.0;
    var totalVol = vol1 * vol2 * vol3 * duckingFactor;
    _volumeLogger.info(
      "Setting volume to $totalVol - user: $_internalVolume gain: $_replayGainVolume fade: $_fadeVolume, ducking: $isDucked",
    );
    return _player.setVolume(totalVol.clamp(0.0, 1.0));
  }
}

class MusicPlayerBackgroundTask extends BaseAudioHandler with SeekHandler, QueueHandler {
  final _androidAutoHelper = GetIt.instance<AndroidAutoHelper>();

  AppLocalizations? _appLocalizations;

  late final AudioPlayer _player;
  late final AudioPipeline _audioPipeline;
  late final List<AndroidAudioEffect> _androidAudioEffects;
  late final List<DarwinAudioEffect> _iosAudioEffects;
  late final AndroidLoudnessEnhancer? _loudnessEnhancerEffect;

  final _audioServiceBackgroundTaskLogger = Logger("MusicPlayerBackgroundTask");
  final _volumeNormalizationLogger = Logger("VolumeNormalization");
  final _outputLogger = Logger("Output");

  static const Duration _skipPlayPauseGuardWindow = Duration(milliseconds: 50);

  DateTime? _lastSkipCommandAt;

  final ValueNotifier<SleepTimer?> _timer = ValueNotifier<SleepTimer?>(null);
  ValueListenable<SleepTimer?> get timer => _timer;

  Future<bool> Function()? _queueCallbackPreviousTrack;

  List<int> get shuffleIndices => _player.shuffleIndices;
  List<AudioSource> get audioSources => _player.audioSources;

  double iosBaseVolumeGainFactor = 1.0;
  late final PlayerVolumeController _volume = PlayerVolumeController(_player);
  Duration minBufferDuration = Duration(seconds: 90);

  final _audioFadeStepDuration = Duration(milliseconds: 50);
  late final BehaviorSubject<FadeState> fadeState;

  final outputSwitcherChannel = MethodChannel('com.unicornsonlsd.finamp/output_switcher');

  bool get _shouldIgnorePlayPauseAfterRecentSkip {
    final lastSkipCommandAt = _lastSkipCommandAt;
    if (lastSkipCommandAt == null) return false;

    final elapsed = DateTime.now().difference(lastSkipCommandAt);
    if (elapsed <= _skipPlayPauseGuardWindow) {
      _audioServiceBackgroundTaskLogger.fine(
        "Ignoring play/pause because skip was ${elapsed.inMilliseconds}ms ago (threshold ${_skipPlayPauseGuardWindow.inMilliseconds}ms)",
      );
      return true;
    }
    return false;
  }

  Future<void> showOutputSwitcherDialog() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      _outputLogger.fine("Showing output switcher dialog");
      await outputSwitcherChannel.invokeMethod('showOutputSwitcherDialog');
      _outputLogger.finer("Output switcher dialog shown");
    } on PlatformException catch (e) {
      _outputLogger.severe("Failed to show output switcher dialog: ${e.message}");
    } catch (e) {
      _outputLogger.severe("Failed to show output switcher dialog: $e");
    }
  }

  Future<void> openBluetoothSettings() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      _outputLogger.fine("Opening Bluetooth settings");
      await outputSwitcherChannel.invokeMethod('openBluetoothSettings');
    } on PlatformException catch (e) {
      _outputLogger.severe("Failed to open Bluetooth settings: ${e.message}");
    } catch (e) {
      _outputLogger.severe("Failed to open Bluetooth settings: $e");
    }
  }

  Future<List<FinampOutputRoute>> getRoutes() async {
    if (!Platform.isAndroid) {
      return [];
    }
    try {
      final List<Object?>? rawObjects = await outputSwitcherChannel.invokeMethod<List<Object?>>('getRoutes');

      final routes =
          rawObjects
              ?.map((obj) => Map<String, dynamic>.from(obj as Map))
              .map((route) => FinampOutputRoute.fromJson(route))
              .toList() ??
          [];
      return routes;
    } on PlatformException catch (e) {
      _outputLogger.severe("Failed to get routes: ${e.message}");
      return [];
    } catch (e) {
      _outputLogger.severe("Failed to get routes: $e");
      return [];
    }
  }

  Future<void> setOutputToDeviceSpeaker() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      await outputSwitcherChannel.invokeMethod('setOutputToDeviceSpeaker');
    } on PlatformException catch (e) {
      _outputLogger.severe("Failed to switch output: ${e.message}");
    } catch (e) {
      _outputLogger.severe("Failed to switch output: $e");
    }
  }

  Future<void> setOutputToBluetoothDevice() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      await outputSwitcherChannel.invokeMethod('setOutputToBluetoothDevice');
    } on PlatformException catch (e) {
      _outputLogger.severe("Failed to switch output: ${e.message}");
    } catch (e) {
      _outputLogger.severe("Failed to switch output: $e");
    }
  }

  Future<void> setOutputToRoute(FinampOutputRoute route) async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      await outputSwitcherChannel.invokeMethod('setOutputToRouteByName', {'name': route.name});
    } on PlatformException catch (e) {
      _outputLogger.severe("Failed to switch output: ${e.message}");
    } catch (e) {
      _outputLogger.severe("Failed to switch output: $e");
    }
  }

  static Future<void> configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(
      FinampSettingsHelper.finampSettings.duckOnAudioInterruption
          ? const AudioSessionConfiguration.music()
          : const AudioSessionConfiguration.music().copyWith(
              androidAudioAttributes: const AndroidAudioAttributes(
                contentType: AndroidAudioContentType.speech,
                usage: AndroidAudioUsage.media,
              ),
            ),
    );
  }

  MusicPlayerBackgroundTask() {
    _audioServiceBackgroundTaskLogger.info("Starting audio service");

    if (Platform.isWindows || Platform.isLinux) {
      _audioServiceBackgroundTaskLogger.info("Initializing media-kit for Windows/Linux");
      JustAudioMediaKit.title = "Finamp";
      JustAudioMediaKit.prefetchPlaylist = true;
      JustAudioMediaKit.bufferSize = FinampSettingsHelper.finampSettings.bufferSizeMegabytes * 1024 * 1024;
      JustAudioMediaKit.ensureInitialized(linux: true, windows: true, macOS: false, iOS: false, android: false);
    }

    _androidAudioEffects = [];
    _iosAudioEffects = [];

    if (Platform.isAndroid && FinampSettingsHelper.finampSettings.useAndroidGainEffect) {
      _loudnessEnhancerEffect = AndroidLoudnessEnhancer();
      _androidAudioEffects.add(_loudnessEnhancerEffect!);
    } else {
      _loudnessEnhancerEffect = null;
    }

    _audioPipeline = AudioPipeline(androidAudioEffects: _androidAudioEffects, darwinAudioEffects: _iosAudioEffects);

    Duration maxBufferDuration = Duration(
      seconds: max(minBufferDuration.inSeconds, FinampSettingsHelper.finampSettings.bufferDuration.inSeconds),
    );

    AudioSession.instance.then((session) {
      bool wasPlayingBeforeInterruption = false;
      session.interruptionEventStream.listen((event) {
        bool customInterruptionHandlingNeeded = !FinampSettingsHelper.finampSettings.duckOnAudioInterruption;
        if (!customInterruptionHandlingNeeded) {
          return;
        }
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              wasPlayingBeforeInterruption = _player.playing;
              pause();
              break;
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              _volume.unduck();
              break;
            case AudioInterruptionType.pause:
              if (wasPlayingBeforeInterruption) {
                play();
              }
              break;
            case AudioInterruptionType.unknown:
              break;
          }
        }
      });
      session.becomingNoisyEventStream.listen((_) {
        if (!FinampSettingsHelper.finampSettings.duckOnAudioInterruption) {
          pause();
        }
      });
      session.devicesChangedEventStream.listen((event) {
        _outputLogger.info('Devices added:   ${event.devicesAdded}');
        _outputLogger.info('Devices removed: ${event.devicesRemoved}');
      });
    });

    _player = AudioPlayer(
      maxSkipsOnError: 0,
      handleInterruptions: FinampSettingsHelper.finampSettings.duckOnAudioInterruption,
      androidAudioOffloadPreferences: AndroidAudioOffloadPreferences(
        audioOffloadMode: FinampSettingsHelper.finampSettings.forceAudioOffloadingOnAndroid
            ? AndroidAudioOffloadMode.enabled
            : AndroidAudioOffloadMode.disabled,
        isGaplessSupportRequired: true,
        isSpeedChangeSupportRequired: true,
      ),
      audioLoadConfiguration: AudioLoadConfiguration(
        androidLoadControl: AndroidLoadControl(
          targetBufferBytes: FinampSettingsHelper.finampSettings.bufferDisableSizeConstraints
              ? null
              : 1024 * 1024 * FinampSettingsHelper.finampSettings.bufferSizeMegabytes,
          minBufferDuration: FinampSettingsHelper.finampSettings.bufferDisableSizeConstraints
              ? maxBufferDuration
              : minBufferDuration,
          maxBufferDuration: FinampSettingsHelper.finampSettings.bufferDisableSizeConstraints
              ? (maxBufferDuration + Duration(seconds: 90))
              : maxBufferDuration,
          prioritizeTimeOverSizeThresholds: FinampSettingsHelper.finampSettings.bufferDisableSizeConstraints,
          bufferForPlaybackDuration: Duration(seconds: 5),
          bufferForPlaybackAfterRebufferDuration: Duration(seconds: 10),
        ),
        darwinLoadControl: DarwinLoadControl(
          preferredForwardBufferDuration: FinampSettingsHelper.finampSettings.bufferDisableSizeConstraints
              ? FinampSettingsHelper.finampSettings.bufferDuration
              : null,
        ),
      ),
      audioPipeline: _audioPipeline,
    );

    try {
      _loudnessEnhancerEffect?.setEnabled(FinampSettingsHelper.finampSettings.volumeNormalizationActive);
      _loudnessEnhancerEffect?.setTargetGain(0.0);
    } catch (_) {
      FinampSetters.setUseAndroidGainEffect(false);
      _loudnessEnhancerEffect = null;
      GlobalSnackbar.message((context) => AppLocalizations.of(context)!.androidGainDisabled);
    }

    iosBaseVolumeGainFactor = pow(10.0, FinampSettingsHelper.finampSettings.volumeNormalizationIOSBaseGain / 20.0)
        as double;
    if (_loudnessEnhancerEffect == null) {
      _volumeNormalizationLogger.info("non-Android base volume gain factor: $iosBaseVolumeGainFactor");
    }

    int? replayQueueIndex;
    _player.playbackEventStream.listen((event) async {
      final playerSequence = _player.sequenceState.sequence;
      if (playerSequence.isNotEmpty) {
        if (event.currentIndex != replayQueueIndex) {
          replayQueueIndex = event.currentIndex;
          if (replayQueueIndex != null && playerSequence.elementAtOrNull(replayQueueIndex!) != null) {
            var queueItem = playerSequence[replayQueueIndex!].tag as FinampQueueItem?;
            if (queueItem != null) {
              _applyVolumeNormalization(queueItem.item);
            }
          }
        }
      }
      playbackState.add(_transformEvent(event));
    });

    double prevIosGain = FinampSettingsHelper.finampSettings.volumeNormalizationIOSBaseGain;
    bool? prevNormActive = FinampSettingsHelper.finampSettings.volumeNormalizationActive;
    VolumeNormalizationMode prevNormMode = FinampSettingsHelper.finampSettings.volumeNormalizationMode;
    FinampSettingsHelper.finampSettingsListener.addListener(() {
      var iosGain = FinampSettingsHelper.finampSettings.volumeNormalizationIOSBaseGain;
      var normalizationActive = FinampSettingsHelper.finampSettings.volumeNormalizationActive;
      var normalizationMode = FinampSettingsHelper.finampSettings.volumeNormalizationMode;
      if (iosGain == prevIosGain && normalizationActive == prevNormActive && normalizationMode == prevNormMode) {
        return;
      }
      prevIosGain = iosGain;
      prevNormActive = normalizationActive;
      prevNormMode = normalizationMode;
      iosBaseVolumeGainFactor = pow(10.0, iosGain / 20.0) as double;
      if (normalizationActive) {
        _loudnessEnhancerEffect?.setEnabled(true);
        _applyVolumeNormalization(mediaItem.valueOrNull);
      } else {
        _loudnessEnhancerEffect?.setEnabled(false);
        _volume.setReplayGainVolume(1.0);
        _volumeNormalizationLogger.info("Replay gain disabled");
      }
    });

    mediaItem.listen((currentTrack) {
      _applyVolumeNormalization(currentTrack);
    });

    mediaItem.distinct().listen((currentTrack) {
      sleepTimer?.onTrackCompleted();
    });

    _player.errorStream.listen((error) {
      _audioServiceBackgroundTaskLogger.severe("Player error: $error", error);
    });

    _player.positionStream.listen((position) {
      if (sleepTimer?.remainingTracks == 1 &&
          ((mediaItem.value?.duration ?? Duration.zero) - position).inMilliseconds / _player.speed <=
              max(
                Duration(milliseconds: 500).inMilliseconds,
                FinampSettingsHelper.finampSettings.audioFadeOutDuration.inMilliseconds,
              )) {
        sleepTimer?.onTrackCompleted();
      }
    });

    _player.processingStateStream.listen((event) async {
      if (event == ProcessingState.completed) {
        await handleEndOfQueue();
      }
    });

    fadeState = BehaviorSubject.seeded(FadeState(fadeVolume: 1.0));
  }

  SleepTimer? get sleepTimer => _timer.value;

  void setQueueCallbacks({required Future<bool> Function() previousTrackCallback}) {
    _queueCallbackPreviousTrack = previousTrackCallback;
  }

  Future<Duration?> setQueueItems(
    List<FinampQueueItem> queueItems, {
    bool preload = true,
    int? initialIndex,
    Duration? initialPosition,
    ShuffleOrder? shuffleOrder,
  }) async {
    try {
      List<AudioSource> audioSources = [];

      for (final queueItem in queueItems) {
        audioSources.add(await _queueItemToAudioSource(queueItem));
      }
      return await _player.setAudioSources(
        audioSources,
        preload: preload,
        initialIndex: initialIndex,
        initialPosition: initialPosition,
        shuffleOrder: shuffleOrder,
      );
    } on PlayerException catch (e) {
      _audioServiceBackgroundTaskLogger.severe("Player error code ${e.code}: ${e.message}");
      GlobalSnackbar.error(e);
    } on PlayerInterruptedException catch (e) {
      _audioServiceBackgroundTaskLogger.warning("Player interrupted: ${e.message}");
      GlobalSnackbar.error(e);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe("Player error ${e.toString()}");
      GlobalSnackbar.error(e);
    }
    return null;
  }

  Future<void> appendFinampQueueItem(FinampQueueItem queueItem) async {
    return _player.addAudioSource(await _queueItemToAudioSource(queueItem));
  }

  Future<void> appendFinampQueueItems(List<FinampQueueItem> queueItems) async {
    return _player.addAudioSources(await Future.wait(queueItems.map(_queueItemToAudioSource)));
  }

  Future<void> insertFinampQueueItemAt(int index, FinampQueueItem queueItem) async {
    return _player.insertAudioSource(index, await _queueItemToAudioSource(queueItem));
  }

  Future<void> insertFinampQueueItems(int index, List<FinampQueueItem> queueItems) async {
    return _player.insertAudioSources(index, await Future.wait(queueItems.map(_queueItemToAudioSource)));
  }

  Future<void> moveFinampQueueItem(int currentIndex, int newIndex) {
    return _player.moveAudioSource(currentIndex, newIndex);
  }

  Future<void> removeFinampQueueItemAt(int index) {
    return _player.removeAudioSourceAt(index);
  }

  Future<void> removeFinampQueueItemRange(int start, int end) {
    return _player.removeAudioSourceRange(start, end);
  }

  Future<void> clearFinampQueueItems() {
    return _player.clearAudioSources();
  }

  Future<void> dispose() => _player.dispose();

  @override
  Future<void> play({bool disableFade = false}) async {
    _audioServiceBackgroundTaskLogger.info(
      "play() start: disableFade=$disableFade, playing=${_player.playing}, fadeDirection=${fadeState.value.fadeDirection}, currentIndex=${_player.currentIndex}, position=${_player.position}",
    );
    if (_shouldIgnorePlayPauseAfterRecentSkip) {
      return;
    }
    if (!disableFade && FinampSettingsHelper.finampSettings.audioFadeInDuration > Duration.zero) {
      return fadeInAndPlay();
    } else {
      await _volume.setFadeVolume(1.0);
      return _player.play();
    }
  }

  double get speed => _player.speed;

  @override
  Future<void> setSpeed(final double speed) async {
    return _player.setSpeed(speed);
  }

  Future<void> setPitch(final double pitch) async {
    return _player.setPitch(pitch);
  }

  void setVolume(final double volume) async {
    return _volume.setInternalVolume(volume);
  }

  @override
  Future<void> pause({bool disableFade = false}) async {
    _audioServiceBackgroundTaskLogger.info(
      "pause() start: disableFade=$disableFade, playing=${_player.playing}, fadeDirection=${fadeState.value.fadeDirection}, currentIndex=${_player.currentIndex}, position=${_player.position}",
    );
    if (_shouldIgnorePlayPauseAfterRecentSkip) {
      return;
    }
    if (!disableFade && FinampSettingsHelper.finampSettings.audioFadeOutDuration > Duration.zero) {
      return fadeOutAndPause();
    } else {
      return _player.pause();
    }
  }

  int getFadeSteps(Duration fadeDuration) {
    return (fadeDuration.inMilliseconds / _audioFadeStepDuration.inMilliseconds).toInt();
  }

  double _getVolumeFadeInStepSize() {
    final steps = getFadeSteps(FinampSettingsHelper.finampSettings.audioFadeInDuration);
    return 1.0 / steps;
  }

  double _getVolumeFadeOutStepSize() {
    final steps = getFadeSteps(FinampSettingsHelper.finampSettings.audioFadeOutDuration);
    return 1.0 / steps;
  }

  Future<void> _fadeAudio(FadeDirection direction) async {
    fadeState.add(
      FadeState(
        fadeVolume: direction == FadeDirection.fadeIn ? 0.0 : 1.0,
        volumeFadeInStepSize: _getVolumeFadeInStepSize(),
        volumeFadeOutStepSize: _getVolumeFadeOutStepSize(),
        fadeDirection: direction,
      ),
    );

    Future<void>? fut;
    if (direction == FadeDirection.fadeIn) {
      await _volume.setFadeVolume(0.0);
      fut = _player.play();
    }

    bool cancelled = false;
    await Stream.periodic(
      _audioFadeStepDuration,
      (_) => fadeState.value,
    ).takeWhile((fade) => fade.fadeDirection != FadeDirection.none && !cancelled).forEach((state) async {
      switch (state.fadeDirection) {
        case FadeDirection.fadeIn:
          var newVolume = state.fadeVolume + state.volumeFadeInStepSize;
          await _volume.setFadeVolume(newVolume);
          fadeState.add(state.copyWith(fadeVolume: newVolume));
          if (newVolume >= 1.0) {
            fadeState.add(state.copyWith(fadeDirection: FadeDirection.none));
            cancelled = true;
          }
          break;
        case FadeDirection.fadeOut:
          var newVolume = state.fadeVolume - state.volumeFadeOutStepSize;
          await _volume.setFadeVolume(newVolume);
          fadeState.add(state.copyWith(fadeVolume: newVolume));
          if (newVolume <= 0.0) {
            fadeState.add(state.copyWith(fadeDirection: FadeDirection.none));
            cancelled = true;
            fut = _player.pause();
          }
          break;
        default:
          break;
      }
    });

    return fut;
  }

  Future<void> fadeOutAndPause() async {
    switch (fadeState.value.fadeDirection) {
      case FadeDirection.fadeOut:
        return;
      case FadeDirection.fadeIn:
        fadeState.add(fadeState.value.copyWith(fadeDirection: FadeDirection.fadeOut));
        return;
      case FadeDirection.none:
        return _fadeAudio(FadeDirection.fadeOut);
    }
  }

  Future<void> fadeInAndPlay() async {
    switch (fadeState.value.fadeDirection) {
      case FadeDirection.fadeIn:
        return;
      case FadeDirection.fadeOut:
        fadeState.add(fadeState.value.copyWith(fadeDirection: FadeDirection.fadeIn));
        return;
      case FadeDirection.none:
        return _fadeAudio(FadeDirection.fadeIn);
    }
  }

  Future<void> togglePlayback() {
    if (_player.playing && fadeState.value.fadeDirection != FadeDirection.fadeOut) {
      return pause();
    } else {
      return play();
    }
  }

  @override
  Future<void> stop() async {
    try {
      _audioServiceBackgroundTaskLogger.info("Audio service received stop command");

      if (FinampSettingsHelper.finampSettings.clearQueueOnStopEvent) {
        await GetIt.instance<QueueService>().stopAndClearQueue();
      } else {
        await stopPlayback();
      }
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> stopPlayback() async {
    try {
      clearSleepTimer();
      await _player.stop();
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> handleEndOfQueue() async {
    try {
      _audioServiceBackgroundTaskLogger.info("Queue completed.");
      await pause(disableFade: true);
      if (FinampSettingsHelper.finampSettings.radioEnabled) {
        await seek(playbackPosition - Duration(milliseconds: 500));
      } else if (_player.effectiveIndices.isNotEmpty) {
        await skipToIndex(0);
      }
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  int getPlayPositionInSeconds() {
    return _player.position.inSeconds;
  }

  @override
  Future<void> skipToPrevious({bool forceSkip = false}) async {
    _audioServiceBackgroundTaskLogger.fine(
      "skipToPrevious() start: forceSkip=$forceSkip, playing=${_player.playing}, fadeDirection=${fadeState.value.fadeDirection}, hasPrevious=${_player.hasPrevious}, loopMode=${_player.loopMode}, currentIndex=${_player.currentIndex}, position=${_player.position}",
    );
    _lastSkipCommandAt = DateTime.now();
    bool doSkip = true;

    try {
      if (_queueCallbackPreviousTrack != null) {
        doSkip = await _queueCallbackPreviousTrack!();
      } else {
        doSkip = _player.position.inSeconds < 5;
      }

      if (!_player.hasPrevious) {
        await _player.seek(Duration.zero);
      } else if (doSkip || forceSkip) {
        if (_player.loopMode == LoopMode.one) {
          await skipByOffset(-1);
        } else {
          await _player.seekToPrevious();
        }
      } else {
        await _player.seek(Duration.zero);
      }
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> skipToNext() async {
    _audioServiceBackgroundTaskLogger.fine(
      "skipToNext() start: playing=${_player.playing}, fadeDirection=${fadeState.value.fadeDirection}, hasNext=${_player.hasNext}, loopMode=${_player.loopMode}, currentIndex=${_player.currentIndex}, position=${_player.position}",
    );
    _lastSkipCommandAt = DateTime.now();
    try {
      if (_player.loopMode == LoopMode.one || !_player.hasNext) {
        await skipByOffset(1);
      } else {
        await _player.seekToNext();
      }
      _audioServiceBackgroundTaskLogger.finer("_player.nextIndex: ${_player.nextIndex}");
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> skipByOffset(int offset) async {
    _audioServiceBackgroundTaskLogger.fine("skipping by offset: $offset");

    try {
      int queueIndex = _player.shuffleModeEnabled
          ? shuffleIndices.indexOf((_player.currentIndex ?? 0)) + offset
          : (_player.currentIndex ?? 0) + offset;
      if (queueIndex >= _player.effectiveIndices.length) {
        if (_player.loopMode == LoopMode.off) {
          return await _player.seek(_player.duration);
        }
        queueIndex %= (_player.effectiveIndices.length);
      }
      if (queueIndex < 0) {
        if (_player.loopMode == LoopMode.off) {
          queueIndex = 0;
        } else {
          queueIndex %= (_player.effectiveIndices.length);
        }
      }
      await _player.seek(Duration.zero, index: _player.shuffleModeEnabled ? shuffleIndices[queueIndex] : queueIndex);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> skipToIndex(int index) async {
    _audioServiceBackgroundTaskLogger.fine("skipping to index: $index");

    try {
      await _player.seek(Duration.zero, index: _player.shuffleModeEnabled ? shuffleIndices[index] : index);
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
            "Unsupported AudioServiceShuffleMode! Received ${shuffleMode.toString()}, requires all or none.",
          );
      }
      _audioServiceBackgroundTaskLogger.info("Set shuffle mode to $shuffleMode");
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      rethrow;
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
            "Unsupported AudioServiceRepeatMode! Received ${repeatMode.toString()}, requires all, none, or one.",
          );
      }
      _audioServiceBackgroundTaskLogger.info("Set repeat mode to $repeatMode");
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      rethrow;
    }
  }

  List<MediaItem> _getRootMenu() {
    return [
      MediaItem(
        id: MediaItemId(contentType: ContentType.albums, parentType: MediaItemParentType.rootCollection).toString(),
        title: _appLocalizations?.albums ?? ContentType.albums.toString(),
        playable: false,
      ),
      MediaItem(
        id: MediaItemId(
          contentType: ContentType.performingArtists,
          parentType: MediaItemParentType.rootCollection,
        ).toString(),
        title: _appLocalizations?.artists ?? ContentType.performingArtists.toString(),
        playable: false,
      ),
      MediaItem(
        id: MediaItemId(contentType: ContentType.playlists, parentType: MediaItemParentType.rootCollection).toString(),
        title: _appLocalizations?.playlists ?? ContentType.playlists.toString(),
        playable: false,
      ),
      MediaItem(
        id: MediaItemId(contentType: ContentType.genres, parentType: MediaItemParentType.rootCollection).toString(),
        title: _appLocalizations?.genres ?? ContentType.genres.toString(),
        playable: false,
      ),
      MediaItem(
        id: MediaItemId(contentType: ContentType.tracks, parentType: MediaItemParentType.rootCollection).toString(),
        title: _appLocalizations?.tracks ?? ContentType.tracks.toString(),
        playable: false,
      ),
    ];
  }

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId, [Map<String, dynamic>? options]) async {
    if (parentMediaId == AudioService.browsableRootId) {
      _appLocalizations ??= await AppLocalizations.delegate.load(
        FinampSettingsHelper.finampSettings.locale ?? const Locale("en", "US"),
      );

      return _getRootMenu();
    } else if (parentMediaId == AudioService.recentRootId) {
      return await _androidAutoHelper.getMediaItems(
        MediaItemId(contentType: ContentType.playlists, parentType: MediaItemParentType.rootCollection),
      );
    } else {
      try {
        final itemId = MediaItemId.fromJson(jsonDecode(parentMediaId) as Map<String, dynamic>);

        return await _androidAutoHelper.getMediaItems(itemId);
      } catch (e) {
        _audioServiceBackgroundTaskLogger.severe(e);
        return super.getChildren(parentMediaId);
      }
    }
  }

  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) async {
    try {
      if (mediaId == QueueItemSourceNameType.shuffleAll.name) {
        return await _androidAutoHelper.shuffleAllTracks();
      }
      final mediaItemId = MediaItemId.fromJson(jsonDecode(mediaId) as Map<String, dynamic>);

      return await _androidAutoHelper.playFromMediaId(mediaItemId);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe(e);
      return super.playFromMediaId(mediaId, extras);
    }
  }

  @override
  Future<List<MediaItem>> search(String query, [Map<String, dynamic>? extras]) async {
    _audioServiceBackgroundTaskLogger.info("search: $query ; extras: $extras");

    final previousItemTitle = _androidAutoHelper.lastSearchQuery?.extras?["android.intent.extra.title"] as String?;

    final currentSearchQuery = AndroidAutoSearchQuery(query, extras);

    if (previousItemTitle != null) {
      if (query.contains(previousItemTitle)) {
        currentSearchQuery.rawQuery = previousItemTitle;
        currentSearchQuery.extras = _androidAutoHelper.lastSearchQuery?.extras;
      } else {
        _androidAutoHelper.setLastSearchQuery(null);
      }
    }

    final results = await _androidAutoHelper.searchItems(currentSearchQuery);
    return results;
  }

  @override
  Future<void> playFromSearch(String query, [Map<String, dynamic>? extras]) async {
    _audioServiceBackgroundTaskLogger.info("playFromSearch: $query ; extras: $extras");
    final searchQuery = AndroidAutoSearchQuery(query, extras);
    _androidAutoHelper.setLastSearchQuery(searchQuery);
    await _androidAutoHelper.playFromSearch(searchQuery);
  }

  @override
  Future<dynamic> customAction(String name, [Map<String, dynamic>? extras]) async {
    late final CustomPlaybackActions action;
    try {
      action = CustomPlaybackActions.values.firstWhere((element) => element.name == name);
    } catch (e) {
      _audioServiceBackgroundTaskLogger.severe("Custom action '$name' not found.", e);
      return super.customAction(name, extras);
    }

    switch (action) {
      case CustomPlaybackActions.shuffle:
        final queueService = GetIt.instance<QueueService>();
        return queueService.togglePlaybackOrder();
      case CustomPlaybackActions.radio:
        return radio_service_helper.toggleRadio();
      case CustomPlaybackActions.toggleFavorite:
        return toggleFavoriteStatusOfCurrentTrack();
      case CustomPlaybackActions.dbusVolume:
        final volume = extras?["value"] as double?;
        if (volume != null) {
          _audioServiceBackgroundTaskLogger.info("Setting volume to $volume from dbus.");
          await _volume.setInternalVolume(volume);
        }
        return;
    }
  }

  Future<void> toggleFavoriteStatusOfCurrentTrack() async {
    final ref = GetIt.instance<ProviderContainer>();
    jellyfin_models.BaseItemDto? currentItem;

    if (mediaItem.valueOrNull?.extras?["itemJson"] != null) {
      currentItem = jellyfin_models.BaseItemDto.fromJson(
        mediaItem.valueOrNull?.extras!["itemJson"] as Map<String, dynamic>,
      );
    } else {
      return;
    }

    bool isFavorite = currentItem.userData?.isFavorite ?? false;
    isFavorite = ref.read(isFavoriteProvider(currentItem));
    isFavorite = ref.read(isFavoriteProvider(currentItem).notifier).updateFavorite(!isFavorite);
    return refreshPlaybackStateAndMediaNotification();
  }

  Future<void> refreshPlaybackStateAndMediaNotification() async {
    final event = _transformEvent(_player.playbackEvent);
    return playbackState.add(event);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    return skipToIndex(index);
  }

  void _applyVolumeNormalization(MediaItem? currentTrack) {
    if (FinampSettingsHelper.finampSettings.volumeNormalizationActive && currentTrack != null) {
      final baseItem = jellyfin_models.BaseItemDto.fromJson(currentTrack.extras?["itemJson"] as Map<String, dynamic>);

      double? effectiveGainChange = getGainForCurrentPlayback(currentTrack, baseItem);

      _volumeNormalizationLogger.info(
        "normalization gain for '${baseItem.name}': $effectiveGainChange (track gain change: ${baseItem.normalizationGain})",
      );
      if (effectiveGainChange != null) {
        if (_loudnessEnhancerEffect != null) {
          _loudnessEnhancerEffect.setTargetGain(effectiveGainChange);
        } else {
          num linearGainVolumeFactor = pow(
            10.0,
            (effectiveGainChange + FinampSettingsHelper.finampSettings.volumeNormalizationIOSBaseGain) / 20.0,
          );
          if (Platform.isLinux || Platform.isWindows) {
            linearGainVolumeFactor = pow(linearGainVolumeFactor, 1 / 3).clamp(0.0, 1.0).toDouble();
          }
          _volumeNormalizationLogger.finer("new volume: $linearGainVolumeFactor");
          _volume.setReplayGainVolume(linearGainVolumeFactor.toDouble());
        }
      } else {
        if (_loudnessEnhancerEffect != null) {
          _loudnessEnhancerEffect.setTargetGain(0);
        }
        _volume.setReplayGainVolume(iosBaseVolumeGainFactor);
      }
    }
  }

  void completeSleepTimer() {
    pause();
    _timer.value?.cancel();
    _timer.value = null;
    GetIt.instance<PlaybackHistoryService>().reportPlaybackStopped();
  }

  void startSleepTimer(SleepTimer newSleepTimer) {
    _timer.value = newSleepTimer;
    sleepTimer?.start(completeSleepTimer);
  }

  void clearSleepTimer() {
    _timer.value?.cancel();
    _timer.value = null;
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    jellyfin_models.BaseItemDto? currentItem;
    bool isFavorite = false;

    IosPlaybackStateSync.setPlaybackState(isPlaying: _player.playing);

    if (mediaItem.valueOrNull?.extras?["itemJson"] != null) {
      currentItem = jellyfin_models.BaseItemDto.fromJson(
        mediaItem.valueOrNull?.extras!["itemJson"] as Map<String, dynamic>,
      );
      isFavorite = GetIt.instance<ProviderContainer>().read(isFavoriteProvider(currentItem));
    }

    final radioEnabled = FinampSettingsHelper.finampSettings.radioEnabled;
    final radioActive = GetIt.instance<ProviderContainer>()
        .read(radio_service_helper.currentRadioAvailabilityStatusProvider)
        .isAvailable;

    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        if (FinampSettingsHelper.finampSettings.showFavoriteButtonOnMediaNotification &&
            !FinampSettingsHelper.finampSettings.isOffline)
          MediaControl.custom(
            name: CustomPlaybackActions.toggleFavorite.name,
            androidIcon: isFavorite ? "drawable/baseline_heart_filled_24" : "drawable/baseline_heart_24",
            label: isFavorite ? GlobalSnackbar.requireL10n.removeFavorite : GlobalSnackbar.requireL10n.addFavorite,
          ),
        if (FinampSettingsHelper.finampSettings.showShuffleButtonOnMediaNotification)
          radioEnabled
              ? MediaControl.custom(
                  name: CustomPlaybackActions.radio.name,
                  androidIcon: radioActive ? "drawable/tabler_icons_radio_24" : "drawable/tabler_icons_radio_off_24",
                  label: radioActive
                      ? GlobalSnackbar.requireL10n.radioModeActiveTitle
                      : GlobalSnackbar.requireL10n.radioModeInactiveTitle,
                )
              : MediaControl.custom(
                  name: CustomPlaybackActions.shuffle.name,
                  androidIcon: _player.shuffleModeEnabled
                      ? "drawable/baseline_shuffle_on_24"
                      : "drawable/baseline_shuffle_24",
                  label: _player.shuffleModeEnabled
                      ? GlobalSnackbar.requireL10n.playbackOrderShuffledButtonLabel
                      : GlobalSnackbar.requireL10n.playbackOrderLinearButtonLabel,
                ),
        if (FinampSettingsHelper.finampSettings.showStopButtonOnMediaNotification)
          MediaControl.stop.copyWith(androidIcon: "drawable/baseline_stop_24"),
      ],
      systemActions: FinampSettingsHelper.finampSettings.showSeekControlsOnMediaNotification
          ? const {MediaAction.seek, MediaAction.seekForward, MediaAction.seekBackward}
          : {},
      androidCompactActionIndices: const [0, 1, 2],
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
      queueIndex: _player.shuffleModeEnabled && shuffleIndices.isNotEmpty && event.currentIndex != null
          ? shuffleIndices.indexOf(event.currentIndex!)
          : event.currentIndex,
      shuffleMode: _player.shuffleModeEnabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
      repeatMode: _audioServiceRepeatMode(_player.loopMode),
    );
  }

  int? get queueIndex => _player.shuffleModeEnabled && shuffleIndices.isNotEmpty && _player.currentIndex != null
      ? shuffleIndices.indexOf(_player.currentIndex!)
      : _player.currentIndex;
  SequenceState get sequenceState => _player.sequenceState;
  double get volume => (_volume._internalVolume * 100).roundToDouble() / 100;
  bool get paused => !_player.playing;
  Duration get playbackPosition => _player.position;

  void onQueueServiceAvailable() {
    GetIt.instance<ProviderContainer>().listen(currentTrackMetadataProvider, (previous, next) {
      refreshPlaybackStateAndMediaNotification();

      if (FinampSettingsHelper.finampSettings.volumeNormalizationMode != VolumeNormalizationMode.albumBased &&
          FinampSettingsHelper.finampSettings.volumeNormalizationMode != VolumeNormalizationMode.hybrid) {
        return;
      }
      if (previous?.valueOrNull?.albumNormalizationGain != next.valueOrNull?.albumNormalizationGain) {
        _applyVolumeNormalization(mediaItem.valueOrNull);
      }
    });
  }

  Future<AudioSource> _queueItemToAudioSource(FinampQueueItem queueItem) async {
    if (queueItem.item.extras!["downloadedTrackPath"] == null) {
      if (queueItem.item.extras!["isOffline"] as bool) {
        return Future.error("Offline mode enabled but downloaded track not found.");
      } else {
        final trackUri = await _trackUri(queueItem.item);
        return AudioSource.uri(trackUri, tag: queueItem);
      }
    } else {
      final downloadedTrackPath = queueItem.item.extras!["downloadedTrackPath"] as String;
      final downloadUri = Uri.file(downloadedTrackPath);
      return AudioSource.uri(downloadUri, tag: queueItem);
    }
  }

  Future<Uri> _trackUri(MediaItem mediaItem) async {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    final parsedBaseUrl = Uri.parse(finampUserHelper.currentUser!.baseURL);

    List<String> builtPath = List.from(parsedBaseUrl.pathSegments);
    Map<String, String> queryParameters = Map.from(parsedBaseUrl.queryParameters);

    queryParameters["ApiKey"] = finampUserHelper.currentUser!.accessToken;

    if (mediaItem.extras!["shouldTranscode"] as bool) {
      builtPath.addAll(["Audio", mediaItem.extras!["itemJson"]["Id"] as String, "main.m3u8"]);

      queryParameters.addAll({
        "audioCodec": FinampSettingsHelper.finampSettings.transcodingStreamingFormat.codec,
        "playSessionId": mediaItem.extras!["playSessionId"] as String? ?? "",
        "audioSampleRate": FinampSettingsHelper.finampSettings.transcodingStreamingFormat.sampleRate.toString(),
        "segmentContainer": FinampSettingsHelper.finampSettings.transcodingStreamingFormat.container,
      });

      if (!FinampSettingsHelper.finampSettings.transcodingStreamingFormat.lossless) {
        queryParameters.addAll({"audioBitRate": FinampSettingsHelper.finampSettings.transcodeBitrate.toString()});
      }

      if (!FinampSettingsHelper.finampSettings.transcodingStreamingFormat.lossless) {
        queryParameters.addAll({"audioBitRate": FinampSettingsHelper.finampSettings.transcodeBitrate.toString()});
      }

      if (FinampSettingsHelper.finampSettings.multichannelHandlingSetting ==
              MultichannelHandlingSetting.stereoDownmixAll ||
          (FinampSettingsHelper.finampSettings.multichannelHandlingSetting ==
                  MultichannelHandlingSetting.stereoDownmixLossy &&
              FinampSettingsHelper.finampSettings.transcodingStreamingFormat.codec != "flac")) {
        queryParameters.addAll({"maxAudioChannels": "2"});
      }
    } else {
      builtPath.addAll(["Items", mediaItem.extras!["itemJson"]["Id"] as String, "File"]);
    }

    return Uri(
      host: parsedBaseUrl.host,
      port: parsedBaseUrl.port,
      scheme: parsedBaseUrl.scheme,
      userInfo: parsedBaseUrl.userInfo,
      pathSegments: builtPath,
      queryParameters: queryParameters,
    );
  }

  @override
  @Deprecated("Don't use this method, we're using methods based on FinampQueueItem")
  Future<void> addQueueItem(MediaItem mediaItem) async {}
  @override
  @Deprecated("Don't use this method, we're using methods based on FinampQueueItem")
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {}
  @override
  @Deprecated("Don't use this method, we're using methods based on FinampQueueItem")
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {}
  @override
  @Deprecated("Don't use this method, we're using methods based on FinampQueueItem")
  Future<void> updateQueue(List<MediaItem> queue) async {}
  @override
  @Deprecated("Don't use this method, we're using methods based on FinampQueueItem")
  Future<void> updateMediaItem(MediaItem mediaItem) async {}
  @override
  @Deprecated(
    "Don't use this method, we're using methods based on FinampQueueItem. This implementation is just for best-effort platform compatibility.",
  )
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    final index = queue.valueOrNull?.indexOf(mediaItem);
    if (index != null) {
      return removeFinampQueueItemAt(index);
    }
  }

  @override
  @Deprecated(
    "Don't use this method, we're using methods based on FinampQueueItem. This implementation is just for best-effort platform compatibility.",
  )
  Future<void> removeQueueItemAt(int index) async {
    return removeFinampQueueItemAt(index);
  }

  @override
  @Deprecated(
    "Don't use this method, we're using methods based on FinampQueueItem. This implementation is just for best-effort platform compatibility.",
  )
  Future<void> setRating(Rating rating, [Map<String, dynamic>? extras]) async {
    jellyfin_models.BaseItemDto? currentItem;

    if (mediaItem.valueOrNull?.extras?["itemJson"] != null) {
      currentItem = jellyfin_models.BaseItemDto.fromJson(
        mediaItem.valueOrNull?.extras!["itemJson"] as Map<String, dynamic>,
      );
    } else {
      return;
    }
    bool isFavorite = currentItem.userData?.isFavorite ?? false;
    switch (rating.getRatingStyle()) {
      case RatingStyle.heart:
        if (rating.hasHeart() && !isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        } else if (!rating.hasHeart() && isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        }
        break;
      case RatingStyle.thumbUpDown:
        if (rating.isThumbUp() && !isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        } else if (!rating.isThumbUp() && isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        }
        break;
      case RatingStyle.percentage:
        final percentage = rating.getPercentRating();
        if (percentage > 0.5 && !isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        } else if (percentage < 0.5 && isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        }
        break;
      case RatingStyle.range3stars:
        final stars = rating.getStarRating();
        if (stars >= 1.5 && !isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        } else if (stars <= 0.5 && isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        }
        break;
      case RatingStyle.range4stars:
        final stars = rating.getStarRating();
        if (stars >= 2.0 && !isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        } else if (stars <= 1.0 && isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        }
        break;
      case RatingStyle.range5stars:
        final stars = rating.getStarRating();
        if (stars >= 3 && !isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        } else if (stars <= 2.0 && isFavorite) {
          await toggleFavoriteStatusOfCurrentTrack();
        }
        break;
      default:
    }
  }

  @override
  @Deprecated("Don't use this method yet, it has no implementation")
  Future<void> setCaptioningEnabled(bool enabled) async {}
}

double? getGainForCurrentPlayback(MediaItem currentTrack, jellyfin_models.BaseItemDto? item) {
  final baseItem =
      item ?? jellyfin_models.BaseItemDto.fromJson(currentTrack.extras?["itemJson"] as Map<String, dynamic>);

  double? effectiveGainChange;
  final providerContainer = GetIt.instance<ProviderContainer>();
  providerContainer.read(currentTrackMetadataProvider);

  switch (FinampSettingsHelper.finampSettings.volumeNormalizationMode) {
    case VolumeNormalizationMode.hybrid
        when GetIt.instance<QueueService>().getQueue().isCurrentlyPlayingTracksFromSameAlbum():
    case VolumeNormalizationMode.albumBased:
      final albumNormalizationGain =
          baseItem.albumNormalizationGain ??
          providerContainer.read(metadataProvider(baseItem)).valueOrNull?.albumNormalizationGain;

      effectiveGainChange =
          albumNormalizationGain ??
          (currentTrack.extras?["contextNormalizationGain"] as double?) ??
          baseItem.normalizationGain;
      break;
    case VolumeNormalizationMode.hybrid:
    case VolumeNormalizationMode.trackBased:
      effectiveGainChange = baseItem.normalizationGain;
      break;
    case VolumeNormalizationMode.albumOnly:
      effectiveGainChange = currentTrack.extras?["contextNormalizationGain"] as double?;
      break;
  }
  return effectiveGainChange;
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
