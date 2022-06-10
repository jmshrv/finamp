import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:finamp/services/FinampSettingsHelper.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/JellyfinApiData.dart';
import '../models/FinampModels.dart';
import 'FinampUserHelper.dart';

class FinampLogsHelper {
  final List<FinampLogRecord> logs = [];

  void addLog(FinampLogRecord log) {
    logs.add(log);

    // We don't want to keep logs forever due to memory constraints.
    if (logs.length > 1000) {
      logs.removeAt(0);
    }
  }

  /// Sanitises all logs and returns a massive string
  String getSanitisedLogs() {
    final logsStringBuffer = StringBuffer();

    for (final log in logs) {
      logsStringBuffer.writeln(sanitiseLog(log));
    }

    return logsStringBuffer.toString();
  }

  /// Sanitise the given log record (censor base url and tokens)
  String sanitiseLog(FinampLogRecord log) {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();

    final logString =
        "[${log.loggerName}/${log.level.name}] ${log.time}: ${log.message}\n\n${log.stackTrace.toString()}";

    for (final user in finampUserHelper.finampUsers) {
      logString.replaceAll(user.baseUrl, "BASEURL");
      logString.replaceAll(
          user.accessToken, "${user.accessToken.substring(0, 4)}...");
    }

    return logString;
  }

  Future<void> copyLogs() async =>
      await FlutterClipboard.copy(getSanitisedLogs());

  /// Write logs to a file and share the file
  Future<void> shareLogs() async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
        '${tempDir.path}/finamp-logs-${DateTime.now().toIso8601String()}.txt');

    await tempFile.writeAsString(getSanitisedLogs());

    await Share.shareFiles([tempFile.path], mimeTypes: ["text/plain"]);

    await tempFile.delete();
  }
}
