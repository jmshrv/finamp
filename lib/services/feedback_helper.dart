import 'dart:io';

import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:gaimon/gaimon.dart';
import 'package:logging/logging.dart';

enum FeedbackType { success, error, warning, selection, heavy, medium, light }

class FeedbackHelper {
  static void feedback(FeedbackType feedbackType) {
    try {
      if (FinampSettingsHelper.finampSettings.enableVibration &&
          (Platform.isIOS || Platform.isAndroid)) {
        switch (feedbackType) {
          case FeedbackType.selection:
            Gaimon.selection();
            break;
          case FeedbackType.success:
            Gaimon.success();
            break;
          case FeedbackType.error:
            Gaimon.error();
            break;
          case FeedbackType.warning:
            Gaimon.warning();
            break;
          case FeedbackType.heavy:
            Gaimon.heavy();
            break;
          case FeedbackType.medium:
            Gaimon.medium();
            break;
          case FeedbackType.light:
            Gaimon.light();
            break;
        }
      }
    } catch (error, trace) {
      // Handle any exceptions that may occur during feedback, like Hive errors on startup
      Logger("Feedback").severe("Feedback error: $error", error, trace);
    }
  }
}
