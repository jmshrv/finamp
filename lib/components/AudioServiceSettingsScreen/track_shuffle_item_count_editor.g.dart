// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'track_shuffle_item_count_editor.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension TrackShuffleItemCountEditorSearchable on TrackShuffleItemCountEditor {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
      _safeToString(l.shuffleAllTrackCount),
      _safeToString(l.shuffleAllTrackCountSubtitle),
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
