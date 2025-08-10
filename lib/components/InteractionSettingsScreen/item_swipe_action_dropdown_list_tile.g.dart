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
    final searchableTexts = <String>[
      _safeToString(l.swipeLeftToRightAction),
      _safeToString(l.swipeLeftToRightActionSubtitle),
      _safeToString(l.swipeRightToLeftAction),
      _safeToString(l.swipeRightToLeftActionSubtitle),
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
