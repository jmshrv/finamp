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
    return [
      l.reportQueueToServer is String
          ? l.reportQueueToServer
          : l.reportQueueToServer.toString(),
      l.reportQueueToServerSubtitle is String
          ? l.reportQueueToServerSubtitle
          : l.reportQueueToServerSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
