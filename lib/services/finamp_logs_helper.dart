import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path_helper;

import 'finamp_user_helper.dart';

class FinampLogsHelper {
  final List<LogRecord> logs = [];

  void addLog(LogRecord log) {
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
  String sanitiseLog(LogRecord log) {
    if (log.message.contains('{"Username')) {
      return "LOGIN BODY";
    }

    final finampUserHelper = GetIt.instance<FinampUserHelper>();

    var logString =
        "[${log.loggerName}/${log.level.name}] ${log.time}: ${log.message}\n\n${log.stackTrace.toString()}";

    for (final user in finampUserHelper.finampUsers) {
      logString =
          logString.replaceAll(CaseInsensitivePattern(user.baseUrl), "BASEURL");
      logString = logString.replaceAll(
          CaseInsensitivePattern(user.accessToken), "TOKEN");
    }

    return logString;
  }

  Future<void> copyLogs() async =>
      await FlutterClipboard.copy(getSanitisedLogs());

  /// Write logs to a file and share the file
  Future<void> shareLogs() async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(path_helper.join(tempDir.path, "finamp-logs.txt"));

    await tempFile.writeAsString(getSanitisedLogs());

    await Share.shareFilesWithResult([tempFile.path],
        mimeTypes: ["text/plain"]);

    await tempFile.delete();
  }
}

/// A pattern for case-insensitive matching. Used when sanitising logs as
/// Chopper logs the base URL in lowercase.
class CaseInsensitivePattern implements Pattern {
  late String matcher;

  CaseInsensitivePattern(String matcher) {
    this.matcher = matcher.toLowerCase();
  }

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    return matcher.allMatches(string.toLowerCase(), start);
  }

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    return matcher.matchAsPrefix(string.toLowerCase(), start);
  }
}
