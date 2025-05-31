import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finamp/services/censored_log.dart';
import 'package:finamp/services/log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path_helper;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get_it/get_it.dart';

class FinampLogsHelper {
  final List<LogRecord> logs = [];
  IOSink? _logFileWriter;

  Future<void> openLog() async {
    WidgetsFlutterBinding.ensureInitialized();
    final basePath = (Platform.isAndroid || Platform.isIOS)
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();
    final logFile = File(path_helper.join(basePath.path, "finamp-logs.txt"));
    if (logFile.existsSync() && logFile.lengthSync() >= 1024 * 1024 * 10) {
      logFile
          .renameSync(path_helper.join(basePath.path, "finamp-logs-old.txt"));
    }
    _logFileWriter = logFile.openWrite(mode: FileMode.writeOnlyAppend);
  }

  void addLog(LogRecord log) {
    logs.add(log);
    if (_logFileWriter != null) {
      // This fails if we log an event before setting up userHelper
      var message = log.censoredMessage;
      if (log.stackTrace == null) {
        // Truncate long messages from chopper, but leave long stack traces
        message = message.substring(0, min(1024 * 5, message.length));
      }
      _logFileWriter!.writeln(message);
    }

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

  Future<String> getFullLogs() async {
    final fullLogsBuffer = StringBuffer();

    // Get the Log instance and add its metadata at the top
    final logMeta = GetIt.instance.isRegistered<Log>() ? GetIt.instance<Log>() : null;
    if (logMeta != null) {
      // Use the on-demand censored metadata, which fetches server info/version as needed
      final censoredMeta = await logMeta.toCensoredJsonOnDemand();
      // Prepend this metadata to the logs
      fullLogsBuffer.writeln(jsonEncode(censoredMeta));
    }

    if (_logFileWriter != null) {
      final basePath = (Platform.isAndroid || Platform.isIOS)
          ? await getApplicationDocumentsDirectory()
          : await getApplicationSupportDirectory();
      var oldLogs =
          File(path_helper.join(basePath.path, "finamp-logs-old.txt"));
      var newLogs = File(path_helper.join(basePath.path, "finamp-logs.txt"));
      if (oldLogs.existsSync()) {
        fullLogsBuffer.write(await oldLogs.readAsString());
      }
      if (newLogs.existsSync()) {
        fullLogsBuffer.write(await newLogs.readAsString());
      }
    } else {
      fullLogsBuffer.write(getSanitisedLogs());
    }
    return fullLogsBuffer.toString();
  }

  Future<void> copyLogs() async =>
      await FlutterClipboard.copy(getSanitisedLogs());

  /// Write logs to a file and share the file
  Future<void> shareLogs() async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(path_helper.join(tempDir.path, "finamp-logs.txt"));
    tempFile.createSync();

    tempFile.writeAsStringSync(await getFullLogs());

    final xFile = XFile(tempFile.path, mimeType: "text/plain");
    await Share.shareXFiles([xFile]);

    await tempFile.delete();
  }

  /// Write logs to a file and save to user-picked directory
  Future<void> exportLogs() async {
    await FilePicker.platform.saveFile(
        fileName: "finamp-logs.txt",
        // initialDirectory is ignored on mobile
        initialDirectory: (await getApplicationDocumentsDirectory()).path,
        bytes: utf8.encode(await getFullLogs()));
  }
}
