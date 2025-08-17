// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'keep_screen_on_while_charging_selector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension KeepScreenOnWhilePluggedInSelectorSearchable
    on KeepScreenOnWhilePluggedInSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
      _safeToString(l.keepScreenOnWhilePluggedIn),
      _safeToString(l.keepScreenOnWhilePluggedInSubtitle),
    ];
    return searchableTexts
        .where((text) => text.isNotEmpty)
        .join(' ')
        .toLowerCase();
  }

  String _safeToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
