// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'bitrate_selector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension BitrateSelectorSearchable on BitrateSelector {
  @override
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.bitrate,
      l.bitrateSubtitle,
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
