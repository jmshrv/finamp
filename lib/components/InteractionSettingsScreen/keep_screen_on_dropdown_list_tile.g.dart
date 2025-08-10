// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'keep_screen_on_dropdown_list_tile.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension KeepScreenOnDropdownListTileSearchable
    on KeepScreenOnDropdownListTile {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.keepScreenOn,
      l.keepScreenOnSubtitle,
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
