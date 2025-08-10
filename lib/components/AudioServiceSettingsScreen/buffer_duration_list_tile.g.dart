// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'buffer_duration_list_tile.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension BufferDurationListTileSearchable on BufferDurationListTile {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.bufferDuration,
      l.bufferDurationSubtitle,
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
