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
      l.swipeLeftToRightAction is String
          ? l.swipeLeftToRightAction
          : l.swipeLeftToRightAction.toString(),
      l.swipeLeftToRightActionSubtitle is String
          ? l.swipeLeftToRightActionSubtitle
          : l.swipeLeftToRightActionSubtitle.toString(),
      l.swipeRightToLeftAction is String
          ? l.swipeRightToLeftAction
          : l.swipeRightToLeftAction.toString(),
      l.swipeRightToLeftActionSubtitle is String
          ? l.swipeRightToLeftActionSubtitle
          : l.swipeRightToLeftActionSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
