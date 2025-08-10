// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'loadQueueOnStartup_selector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension LoadQueueOnStartupSelectorSearchable on LoadQueueOnStartupSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.autoloadLastQueueOnStartup is String
          ? l.autoloadLastQueueOnStartup
          : l.autoloadLastQueueOnStartup.toString(),
      l.autoloadLastQueueOnStartupSubtitle is String
          ? l.autoloadLastQueueOnStartupSubtitle
          : l.autoloadLastQueueOnStartupSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
