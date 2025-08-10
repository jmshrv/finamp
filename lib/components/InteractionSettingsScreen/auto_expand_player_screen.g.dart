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
    return [
      l.autoExpandPlayerScreenTitle is String
          ? l.autoExpandPlayerScreenTitle
          : l.autoExpandPlayerScreenTitle.toString(),
      l.autoExpandPlayerScreenSubtitle is String
          ? l.autoExpandPlayerScreenSubtitle
          : l.autoExpandPlayerScreenSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
