// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'use_cover_as_background_toggle.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension UseCoverAsBackgroundToggleSearchable on UseCoverAsBackgroundToggle {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.useCoverAsBackground is String
          ? l.useCoverAsBackground
          : l.useCoverAsBackground.toString(),
      l.useCoverAsBackgroundSubtitle is String
          ? l.useCoverAsBackgroundSubtitle
          : l.useCoverAsBackgroundSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
