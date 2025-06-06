import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/services/censored_log.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:hive_ce/hive.dart';

import 'services/finamp_logs_helper.dart';
import 'services/log.dart';

Future<void> setupLogging() async {
  await Hive.openBox<dynamic>('app_info');

  GetIt.instance.registerSingleton(FinampLogsHelper());
  await GetIt.instance<FinampLogsHelper>().openLog();

  // Create and store the Log instance for later use
  final log = await Log.create();
  GetIt.instance.registerSingleton<Log>(log);

  await log.logMetadata(); // Log metadata on startup

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    final finampLogsHelper = GetIt.instance<FinampLogsHelper>();

    // We don't want to print log messages from the Flutter logger since Flutter prints logs by itself
    if (kDebugMode && event.loggerName != "Flutter") {
      debugPrint("[${event.loggerName}/${event.level.name}] ${event.time}: ${event.message}");
    }
    if (kDebugMode && event.loggerName != "Flutter" && event.getStack != null) {
      debugPrintStack(stackTrace: event.getStack);
    }
    // Make sure asserts are extra visible when debugging
    if (kDebugMode && event.object is AssertionError) {
      GlobalSnackbar.message((_) => event.object.toString());
    }
    finampLogsHelper.addLog(event);
  });
}
