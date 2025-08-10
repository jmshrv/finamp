// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'download_location_list_tile.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension DownloadLocationListTileSearchable on DownloadLocationListTile {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.defaultDownloadLocationButton is String
          ? l.defaultDownloadLocationButton
          : l.defaultDownloadLocationButton.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
