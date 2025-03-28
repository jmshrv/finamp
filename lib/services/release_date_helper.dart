import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:intl/intl.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';

class ReleaseDateHelper {
  /// Formats the release date of a [BaseItemDto] based on the user's settings.
  static String? autoFormat(BaseItemDto? baseItem) {
    final format = FinampSettingsHelper.finampSettings.releaseDateFormat;

    final premiereDate = baseItem?.premiereDate != null
        ? DateTime.parse(baseItem!.premiereDate!)
        : null;
    if (premiereDate == null) {
      return null;
    }
    switch (format) {
      case ReleaseDateFormat.year:
        return DateFormat.y().format(premiereDate);
      case ReleaseDateFormat.iso:
        return premiereDate.toIso8601String().split("T").first;
      case ReleaseDateFormat.monthYear:
        return "${DateFormat.MMMM().format(premiereDate)} ${DateFormat.y().format(premiereDate)}";
      case ReleaseDateFormat.monthDayYear:
        return "${DateFormat.MMMM().format(premiereDate)} ${DateFormat.d().format(premiereDate)}, ${DateFormat.y().format(premiereDate)}";
      default:
        return premiereDate.toLocal().toString();
    }
  }
}
