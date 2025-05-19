import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/locale_helper.dart';
import 'package:flutter/material.dart';
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
    }
  }
}

class DateTimeHelper {
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final locale = LocaleHelper.localeString;

    final isSameDay = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    if (isSameDay) {
      final formatted = DateFormat.jm(locale).format(dateTime);
      final is12HourClock =
          formatted.toLowerCase().contains(RegExp(r'am|pm'));

      return is12HourClock
          ? formatted
          : (formatted.contains(':') ? formatted : '$formatted:00');
    }

    final isSameYear = dateTime.year == now.year;
    final format = isSameYear
        ? DateFormat.MMMMd(locale)
        : DateFormat.yMMMd(locale);

    return format.format(dateTime);
  }

  static String? formatFromString(String? dateString) {
    if (dateString == null) return null;

    try {
      final parsed = DateTime.parse(dateString);
      return format(parsed);
    } catch (e) {
      return null;
    }
  }

  static String formatRelativeTime(BuildContext context, DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    final l10n = AppLocalizations.of(context)!;

    if (diff.inMinutes < 1) return l10n.formattedRelativeTime('just_now', 0);
    if (diff.inMinutes < 60) return l10n.formattedRelativeTime('minutes', diff.inMinutes);
    if (diff.inHours < 24 &&
        now.day == dateTime.day &&
        now.month == dateTime.month &&
        now.year == dateTime.year) {
      return l10n.formattedRelativeTime('hours', diff.inHours);
    }

    final nowMidnight = DateTime(now.year, now.month, now.day);
    final yesterdayMidnight = nowMidnight.subtract(const Duration(days: 1));

    if (dateTime.isAfter(yesterdayMidnight)) {
      return l10n.formattedRelativeTime('yesterday', 0);
    } else if (dateTime.isBefore(yesterdayMidnight)) {
      final dateTimeDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
      final daysAgo = nowMidnight.difference(dateTimeDay).inDays;
      if (daysAgo < 7) {
        return l10n.formattedRelativeTime('days', daysAgo);
      }
    }

    final isSameYear = dateTime.year == now.year;
    final locale = LocaleHelper.localeString;
    final format = isSameYear
        ? DateFormat.MMMMd(locale)
        : DateFormat.yMMMd(locale);

    return format.format(dateTime);
  }

  static String? formatRelativeTimeFromString(BuildContext context, String? dateString) {
    if (dateString == null) return null;

    try {
      final parsed = DateTime.parse(dateString);
      return formatRelativeTime(context, parsed);
    } catch (e) {
      return null;
    }
  }

  static Stream<DateTime> get minuteTicker =>
      Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
}

class RelativeDateTimeText extends StatelessWidget {
  final DateTime dateTime;
  final TextStyle? style;

  const RelativeDateTimeText({
    required this.dateTime,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: DateTimeHelper.minuteTicker,
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final text = DateTimeHelper.formatRelativeTime(context, dateTime);
        return Text(text, style: style);
      },
    );
  }
}

class RelativeDateTimeTextFromString extends StatelessWidget {
  final String? dateString;
  final TextStyle? style;
  final String? fallback;

  const RelativeDateTimeTextFromString({
    required this.dateString,
    this.style,
    this.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? parsed;

    try {
      parsed = DateTime.parse(dateString!);
    } catch (_) {}

    final String fallbackText =
        fallback ?? AppLocalizations.of(context)!.unknown;

    if (parsed == null) {
      return Text(fallbackText, style: style);
    }

    return RelativeDateTimeText(dateTime: parsed, style: style);
  }
}