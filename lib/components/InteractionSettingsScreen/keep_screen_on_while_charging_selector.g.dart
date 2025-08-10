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
    return [
      l.keepScreenOnWhilePluggedIn is String
          ? l.keepScreenOnWhilePluggedIn
          : l.keepScreenOnWhilePluggedIn.toString(),
      l.keepScreenOnWhilePluggedInSubtitle is String
          ? l.keepScreenOnWhilePluggedInSubtitle
          : l.keepScreenOnWhilePluggedInSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
