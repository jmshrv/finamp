import 'package:clipboard/clipboard.dart';

import '../models/FinampModels.dart';

class FinampLogsHelper {
  final List<FinampLogRecord> logs = [];

  void addLog(FinampLogRecord log) {
    logs.add(log);

    // We don't want to keep logs forever due to memory constraints.
    if (logs.length > 1000) {
      logs.removeAt(0);
    }
  }

  Future<void> copyLogs() async {
    String logsString = "";

    for (final log in logs) {
      logsString +=
          "[${log.loggerName}/${log.level.name}] ${log.time}: ${log.message}\n\n${log.stackTrace.toString()}\n";
    }

    await FlutterClipboard.copy(logsString);
  }
}
