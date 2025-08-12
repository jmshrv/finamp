// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'periodic_playback_session_update_frequency_editor.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension PeriodicPlaybackSessionUpdateFrequencyEditorSearchable
    on PeriodicPlaybackSessionUpdateFrequencyEditor {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
      _safeToString(l.periodicPlaybackSessionUpdateFrequency),
      _safeToString(l.periodicPlaybackSessionUpdateFrequencySubtitle),
      _safeToString(l.moreInfo),
      _safeToString(l.periodicPlaybackSessionUpdateFrequencyDetails),
      _safeToString(l.close),
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
