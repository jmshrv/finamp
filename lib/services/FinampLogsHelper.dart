import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:clipboard/clipboard.dart';

import '../models/FinampModels.dart';

class FinampLogsHelper {
  static ValueListenable<Box<FinampLogRecord>> get finampLogsListener =>
      Hive.box<FinampLogRecord>("FinampLogs").listenable();

  static Box<FinampLogRecord> get finampLogs => Hive.box("FinampLogs");

  static Future<void> copyLogs() async {
    String logs = "";

    for (final log in finampLogs.values) {
      logs +=
          "[${log.loggerName}/${log.level.name}] ${log.time}: ${log.message}\n";
    }

    await FlutterClipboard.copy(logs);
  }
}
