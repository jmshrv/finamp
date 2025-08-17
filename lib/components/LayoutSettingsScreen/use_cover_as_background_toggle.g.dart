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
    final searchableTexts = <String>[
      _safeToString(l.useCoverAsBackground),
      _safeToString(l.useCoverAsBackgroundSubtitle),
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
