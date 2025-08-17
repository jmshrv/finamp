// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'report_queue_to_server_toggle.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension ReportQueueToServerToggleSearchable on ReportQueueToServerToggle {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
      _safeToString(l.reportQueueToServer),
      _safeToString(l.reportQueueToServerSubtitle),
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
