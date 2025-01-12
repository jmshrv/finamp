import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:package_info_plus/package_info_plus.dart';
//import 'package:device_info_plus/device_info_plus.dart';

import 'services/finamp_logs_helper.dart';
import 'services/metadata_helper.dart';

Future<void> setupLogging() async {
  await Hive.initFlutter();
  await Hive.openBox('logs');
  GetIt.instance.registerSingleton(FinampLogsHelper());
  await GetIt.instance<FinampLogsHelper>()
      .openLog(); // Initializes or opens the log system
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
  final startupLogger = Logger("Startup");
  startupLogger.info("App starting, logging initialized.");

  final metadata = MetaData();
  await metadata.init();

  final packageInfo = metadata.appInfo;
  final deviceInfoString = metadata.deviceInfo;

  startupLogger.info(
      "This is ${packageInfo.version} version ${packageInfo.version}+${packageInfo.originallyInstalledVersion} (Signature '${packageInfo.installationDate}'), installed via ${packageInfo.updateHistory}.");
  startupLogger.info(
      "Running on ${deviceInfoString.deviceModel} with OS version ${deviceInfoString.osVersion}.");
}
