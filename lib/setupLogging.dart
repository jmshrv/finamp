import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

import 'models/FinampModels.dart';

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    if (kDebugMode) {
      print(
          "[${event.loggerName}/${event.level.name}] ${event.time}: ${event.message}");
    }
    Hive.box<FinampLogRecord>("FinampLogs")
        .add(FinampLogRecord.fromLogRecord(event));
  });
}
