// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'show_artist_chip_image_toggle.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension ShowArtistChipImageToggleSearchable on ShowArtistChipImageToggle {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.showArtistChipImage is String
          ? l.showArtistChipImage
          : l.showArtistChipImage.toString(),
      l.showArtistChipImageSubtitle is String
          ? l.showArtistChipImageSubtitle
          : l.showArtistChipImageSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
