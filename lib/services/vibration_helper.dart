import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class VibrationHelper {
  static void feedback(FeedbackType feedbackType) {
    if (!FinampSettingsHelper.finampSettings.disableVibration) {
      Vibrate.feedback(feedbackType);
    }
  }
}