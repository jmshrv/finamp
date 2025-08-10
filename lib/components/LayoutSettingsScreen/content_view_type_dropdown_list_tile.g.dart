// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'content_view_type_dropdown_list_tile.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension ContentViewTypeDropdownListTileSearchable
    on ContentViewTypeDropdownListTile {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.viewType is String ? l.viewType : l.viewType.toString(),
      l.viewTypeSubtitle is String
          ? l.viewTypeSubtitle
          : l.viewTypeSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
