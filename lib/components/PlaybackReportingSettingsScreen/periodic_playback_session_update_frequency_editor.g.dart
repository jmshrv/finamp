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
    return [
      l.periodicPlaybackSessionUpdateFrequency is String
          ? l.periodicPlaybackSessionUpdateFrequency
          : l.periodicPlaybackSessionUpdateFrequency.toString(),
      l.periodicPlaybackSessionUpdateFrequencySubtitle is String
          ? l.periodicPlaybackSessionUpdateFrequencySubtitle
          : l.periodicPlaybackSessionUpdateFrequencySubtitle.toString(),
      l.moreInfo is String ? l.moreInfo : l.moreInfo.toString(),
      l.periodicPlaybackSessionUpdateFrequencyDetails is String
          ? l.periodicPlaybackSessionUpdateFrequencyDetails
          : l.periodicPlaybackSessionUpdateFrequencyDetails.toString(),
      l.close is String ? l.close : l.close.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
