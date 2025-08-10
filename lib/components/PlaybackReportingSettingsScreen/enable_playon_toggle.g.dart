// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'enable_playon_toggle.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension EnablePlayonToggleSearchable on EnablePlayonToggle {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.enablePlayonTitle is String
          ? l.enablePlayonTitle
          : l.enablePlayonTitle.toString(),
      l.enablePlayonSubtitle is String
          ? l.enablePlayonSubtitle
          : l.enablePlayonSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
