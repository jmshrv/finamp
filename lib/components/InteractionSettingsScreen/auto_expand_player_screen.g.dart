// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'auto_expand_player_screen.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension AutoExpandPlayerScreenSelectorSearchable
    on AutoExpandPlayerScreenSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
      _safeToString(l.autoExpandPlayerScreenTitle),
      _safeToString(l.autoExpandPlayerScreenSubtitle),
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
