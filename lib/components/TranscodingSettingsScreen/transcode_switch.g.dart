// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'transcode_switch.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension TranscodeSwitchSearchable on TranscodeSwitch {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.enableTranscoding,
      l.enableTranscodingSubtitle,
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
