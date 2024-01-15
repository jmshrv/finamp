import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'services/finamp_logs_helper.dart';

void setupLogging() {
  GetIt.instance.registerSingleton(FinampLogsHelper());
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    final finampLogsHelper = GetIt.instance<FinampLogsHelper>();

    // We don't want to print log messages from the Flutter logger since Flutter prints logs by itself
    if (kDebugMode && event.loggerName != "Flutter") {
      // ignore: avoid_print
      print(
          "[${event.loggerName}/${event.level.name}] ${event.time}: ${event.message}");
    }
    if (kDebugMode &&
        event.loggerName != "Flutter" &&
        event.stackTrace != null) {
      // ignore: avoid_print
      debugPrintStack(stackTrace: event.stackTrace);
    }
    finampLogsHelper.addLog(event);
  });
}
