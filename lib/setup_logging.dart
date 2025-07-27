import 'dart:convert';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/services/censored_log.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'services/finamp_logs_helper.dart';
import 'services/log.dart';

Future<void> setupLogging() async {
  GetIt.instance.registerSingleton(FinampLogsHelper());
  final finampLogsHelper = GetIt.instance<FinampLogsHelper>();
  await finampLogsHelper.openLog();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {

    // We don't want to print log messages from the Flutter logger since Flutter prints logs by itself
    if (kDebugMode && event.loggerName != "Flutter") {
      debugPrint("[${event.loggerName}/${event.level.name}] ${event.time}: ${event.message}");
    }
    if (kDebugMode && event.loggerName != "Flutter" && event.stackTrace != null) {
      debugPrintStack(stackTrace: event.stackTrace);
    }
    // Make sure asserts are extra visible when debugging
    if (kDebugMode && event.object is AssertionError) {
      GlobalSnackbar.message((_) => event.object.toString());
    }
    finampLogsHelper.addLog(event);
  });

  final startupLogger = Logger("Startup");

  // Create and store the Log instance for later use
  final log = await Log.create();
  startupLogger.info(jsonEncode(await log.toJson())); // Log metadata on startup
}
