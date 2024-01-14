import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:finamp/services/censored_log.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path_helper;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FinampLogsHelper {
  final List<LogRecord> logs = [];

  void addLog(LogRecord log) {
    logs.add(log);

    // We don't want to keep logs forever due to memory constraints.
    if (logs.length > (kDebugMode ? 10000 : 1000)) {
      logs.removeAt(0);
    }
  }

  /// Sanitises all logs and returns a massive string
  String getSanitisedLogs() {
    final logsStringBuffer = StringBuffer();

    for (final log in logs) {
      logsStringBuffer.writeln(log.censoredMessage);
    }

    return logsStringBuffer.toString();
  }

  Future<void> copyLogs() async =>
      await FlutterClipboard.copy(getSanitisedLogs());

  /// Write logs to a file and share the file
  Future<void> shareLogs() async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(path_helper.join(tempDir.path, "finamp-logs.txt"));

    await tempFile.writeAsString(getSanitisedLogs());

    final xFile = XFile(tempFile.path, mimeType: "text/plain");

    await Share.shareXFiles([xFile]);

    await tempFile.delete();
  }
}
