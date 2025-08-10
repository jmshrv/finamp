// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'stop_foreground_selector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension StopForegroundSelectorSearchable on StopForegroundSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.enterLowPriorityStateOnPause is String
          ? l.enterLowPriorityStateOnPause
          : l.enterLowPriorityStateOnPause.toString(),
      l.enterLowPriorityStateOnPauseSubtitle is String
          ? l.enterLowPriorityStateOnPauseSubtitle
          : l.enterLowPriorityStateOnPauseSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
