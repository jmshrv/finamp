// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'item_swipe_action_dropdown_list_tile.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension ItemSwipeLeftToRightActionDropdownListTileSearchable
    on ItemSwipeLeftToRightActionDropdownListTile {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.swipeLeftToRightAction,
      l.swipeLeftToRightActionSubtitle,
      l.swipeRightToLeftAction,
      l.swipeRightToLeftActionSubtitle,
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
