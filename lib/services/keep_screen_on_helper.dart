import 'package:battery_plus/battery_plus.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

/// KeepScreenOn
/// 
/// Added dependencies:
///   - keep_screen_on: ^3.0.0
///   - battery_plus: ^6.0.2
/// This functionality adds two options in settings under "Interactions":
///   - Keep Screen On: Main Setting
///   - Keep Screen On: Only while plugged in
/// 
/// Ties into the following actions:
///   - MusicPlayerBackgroundTask.play() -- Sets _isPlaying to true.
///   - MusicPlayerBackgroundTask.pause() -- Sets _isPlaying to false.
///   - LyricsScreen.draw() -- Sets _isLyricsShowing to true.
///   - LyricsScreen.dispose() -- Sets _isLyricsShowing to false.
///   - FinAmp constructor -- Creates an event listener for battery status change.  Sets _isPluggedIn value.
///   - KeepScreenOnOption -- Changes to this option re-evaluates the keepScreenOn status.
///   - KeepScreenOnWhilePluggedIn -- Changes to this option re-evaluates the keepsScreenOn status.
class KeepScreenOnHelper {
  static bool keepingScreenOn = false;

  static bool _isPlaying = false;
  static bool _isLyricsShowing = false;
  static bool _isPluggedIn = false;

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
    debugPrint(
        "KeepScreenOnHelper keepingScreenOn: $keepingScreenOn | mainSetting: ${FinampSettingsHelper.finampSettings.keepScreenOnOption} | whilePluggedInSetting: ${FinampSettingsHelper.finampSettings.keepScreenOnWhilePluggedIn} | isPlaying: $_isPlaying | lyricsShowing: $_isLyricsShowing | isPluggedIn: $_isPluggedIn");
  }

  static void setCondition({bool? isPlaying, bool? isLyricsShowing, BatteryState? batteryState}) {
    if (isPlaying != null) _isPlaying = isPlaying;
    if (isLyricsShowing != null) _isLyricsShowing = isLyricsShowing;
    if (batteryState != null) {
      debugPrint("KeepScreenOnHelper reported battery state: $batteryState");
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