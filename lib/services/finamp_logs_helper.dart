import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:get_it/get_it.dart';
import 'package:clipboard/clipboard.dart';
import 'package:finamp/services/censored_log.dart';
import 'package:finamp/services/metadata_helper.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path_helper;
import 'package:hive/hive.dart';

class FinampLogsHelper {
  final List<LogRecord> logs = [];
  late final Box logBox;

  // FinampLogsHelper() {
  //   _initializeLogBox();
  // }

  Future<void> _initializeLogBox() async {
    logBox = await Hive.openBox('logs');
  }

  Future<void> openLog() async {
    await _initializeLogBox();
  }

  void addLog(LogRecord log) {
    logs.add(log);
    
    if (log.stackTrace == null) {
        // Truncate long messages from chopper, but leave long stack traces
        message = message.substring(0, min(1024 * 5, message.length));
      }
      _logFileWriter!.writeln(message);
    }

    // We don't want to keep logs forever due to memory constraints.
    if (logs.length > 1000) {
      logs.removeAt(0);
    }

    // Write log to Hive box
    logBox.add(log.censoredMessage);
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
    final downloadsDir = await getDownloadsDirectory();

    if (downloadsDir == null) {
      return;
    }

    final zipFile =
        File(path_helper.join(downloadsDir.path, "finamp-logs.zip"));

    final logsFile =
        File(path_helper.join(downloadsDir.path, "finamp-logs.txt"));
    final metadataFile =
        File(path_helper.join(downloadsDir.path, "metadata.json"));

    // Create a zip encoder
    final encoder = ZipFileEncoder();
    encoder.create(zipFile.path);

    // Initialize metadata
    final metadata = GetIt.instance<MetaData>();
    await metadata.init(); // Init metadata

    // write finamp logs to a file and add it to the zip
    await writeAndSaveToZip(
        fileContent: getSanitisedLogs(), file: logsFile, encoder: encoder);

    // Write metadata to a file and add it to the zip
    await writeAndSaveToZip(
        fileContent: metadata.toJson().toString(),
        file: metadataFile,
        encoder: encoder);

    // Close the zip encoder
    await encoder.close();

    if (Platform.isAndroid || Platform.isIOS) {
      // Share the zip file
      final xFile = XFile(zipFile.path, mimeType: "application/zip");
      await Share.shareXFiles([xFile]);
    }

    // Clean up temporary files
    await logsFile.delete();
    await metadataFile.delete();
    //await zipFile.delete();
  }

  Future<void> writeAndSaveToZip(
      {required String fileContent,
      required File file,
      required ZipFileEncoder encoder}) async {
    await file.writeAsString(fileContent);
    await encoder.addFile(file);
  }
}
