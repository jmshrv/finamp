// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'auto_offline_selector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension AutoOfflineSelectorSearchable on AutoOfflineSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.autoOfflineSettingTitle,
      l.autoOfflineSettingDescription,
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
