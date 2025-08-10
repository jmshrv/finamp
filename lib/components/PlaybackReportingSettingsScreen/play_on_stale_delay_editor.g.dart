// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'play_on_stale_delay_editor.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension PlayOnStaleDelayEditorSearchable on PlayOnStaleDelayEditor {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.playOnStaleDelay is String
          ? l.playOnStaleDelay
          : l.playOnStaleDelay.toString(),
      l.playOnStaleDelaySubtitle is String
          ? l.playOnStaleDelaySubtitle
          : l.playOnStaleDelaySubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
