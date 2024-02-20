import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'services/finamp_logs_helper.dart';

Future<void> setupLogging() async {
  GetIt.instance.registerSingleton(FinampLogsHelper());
  await GetIt.instance<FinampLogsHelper>().openLog();
  //Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    final finampLogsHelper = GetIt.instance<FinampLogsHelper>();

    // We don't want to print log messages from the Flutter logger since Flutter prints logs by itself
    if (kDebugMode && event.loggerName != "Flutter") {
      debugPrint(
          "[${event.loggerName}/${event.level.name}] ${event.time}: ${event.message}");
    }
    if (kDebugMode &&
        event.loggerName != "Flutter" &&
        event.stackTrace != null) {
      debugPrintStack(stackTrace: event.stackTrace);
    }
    finampLogsHelper.addLog(event);
  });
  Logger("Startup").info("App starting, logging initialized.");
}
