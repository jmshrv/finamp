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
    return [
      l.shuffleAllTrackCount is String
          ? l.shuffleAllTrackCount
          : l.shuffleAllTrackCount.toString(),
      l.shuffleAllTrackCountSubtitle is String
          ? l.shuffleAllTrackCountSubtitle
          : l.shuffleAllTrackCountSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
