import 'package:battery_plus/battery_plus.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/screens/lyrics_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:logging/logging.dart';

/// Implements ability to keep screen on according to various conditions
class KeepScreenOnHelper {
  static bool keepingScreenOn = false;

  static bool _isPlaying = false;
  static bool _isLyricsShowing = false;
  static bool _isPluggedIn = false;

  static final _keepScreenOnLogger = Logger("KeepScreenOnHelper");

  static void init() {
    // Subscribe to audio playback events
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    audioHandler.playbackState.listen((event) async {
      KeepScreenOnHelper.setCondition(isPlaying: event.playing);
    });

    // Subscribe to battery state change events
    var battery = Battery();
    battery.onBatteryStateChanged.listen((BatteryState state) {
      KeepScreenOnHelper.setCondition(batteryState: state);
    });

    FinampSettingsHelper.finampSettingsListener.addListener(() {
      // When a settings change occurs, check keepScreenOnState.
      setKeepScreenOn();
    });
  }

  static void setKeepScreenOn() {
    if (FinampSettingsHelper.finampSettings.keepScreenOnWhilePluggedIn && !_isPluggedIn) {
      _turnOff();
    } else {
      switch (FinampSettingsHelper.finampSettings.keepScreenOnOption) {
        case KeepScreenOnOption.disabled:
          if (keepingScreenOn) _turnOff();
          break;
        case KeepScreenOnOption.whilePlaying:
          if (_isPlaying) {
            _turnOn();
          } else {
            _turnOff();
          }
          break;
        case KeepScreenOnOption.whileLyrics:
          if (_isPlaying && _isLyricsShowing) {
            _turnOn();
          } else {
            _turnOff();
          }
          break;
      }
    }
    _keepScreenOnLogger.fine(
        "keepingScreenOn: $keepingScreenOn | mainSetting: ${FinampSettingsHelper.finampSettings.keepScreenOnOption} | whilePluggedInSetting: ${FinampSettingsHelper.finampSettings.keepScreenOnWhilePluggedIn} | isPlaying: $_isPlaying | lyricsShowing: $_isLyricsShowing | isPluggedIn: $_isPluggedIn");
  }

  static void setCondition({bool? isPlaying, bool? isLyricsShowing, BatteryState? batteryState}) {
    if (isPlaying != null) _isPlaying = isPlaying;
    if (isLyricsShowing != null) _isLyricsShowing = isLyricsShowing;
    if (batteryState != null) {
      _keepScreenOnLogger.fine("reported battery state: $batteryState");
      switch (batteryState) {
        case BatteryState.charging:
        case BatteryState.connectedNotCharging:
        case BatteryState.full:
          _isPluggedIn = true;
          break;
        case BatteryState.discharging:
        case BatteryState.unknown:
          _isPluggedIn = false;
          break;
        default:
          // Do nothing
          break;
      }
    }

    setKeepScreenOn();
  }

  static void _turnOn() {
    if (!keepingScreenOn) {
      keepingScreenOn = true;
      KeepScreenOn.turnOn();
    }
  }

  static void _turnOff() {
    if (keepingScreenOn) {
      keepingScreenOn = false;
      KeepScreenOn.turnOff();
    }
  }
}

class KeepScreenOnObserver extends NavigatorObserver {
  static final _lyricsCheck = ModalRoute.withName(LyricsScreen.routeName);
  @override
  void didPush(Route route, Route? previousRoute) {
    // Just pushed to lyrics?
    if (_lyricsCheck(route)) KeepScreenOnHelper.setCondition(isLyricsShowing: true);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // Just popped lyrics?
    if (_lyricsCheck(route)) KeepScreenOnHelper.setCondition(isLyricsShowing: false);
    super.didPop(route, previousRoute);
  }
}