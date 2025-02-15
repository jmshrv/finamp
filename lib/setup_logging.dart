import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
  final startupLogger = Logger("Startup");
  startupLogger.info("App starting, logging initialized.");

  final packageInfo = await PackageInfo.fromPlatform();
  final deviceInfo = DeviceInfoPlugin();

  startupLogger.info(
      "This is ${packageInfo.appName} version ${packageInfo.version}+${packageInfo.buildNumber} (Signature '${packageInfo.buildSignature}'), installed via ${packageInfo.installerStore}.");

  String deviceInfoString;
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    deviceInfoString =
        "Android ${androidInfo.version.release} on ${androidInfo.model} (${androidInfo.product})";
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    deviceInfoString = "${iosInfo.systemVersion} on ${iosInfo.model}";
  } else if (Platform.isMacOS) {
    final macosInfo = await deviceInfo.macOsInfo;
    deviceInfoString =
        "macOS ${macosInfo.majorVersion}.${macosInfo.minorVersion}.${macosInfo.patchVersion} on ${macosInfo.model}";
  } else if (Platform.isLinux) {
    final linuxInfo = await deviceInfo.linuxInfo;
    deviceInfoString = "${linuxInfo.version} on ${linuxInfo.id}";
  } else if (Platform.isWindows) {
    final windowsInfo = await deviceInfo.windowsInfo;
    deviceInfoString =
        "Windows ${windowsInfo.displayVersion} on ${windowsInfo.deviceId}";
  } else {
    final webInfo = await deviceInfo.webBrowserInfo;
    deviceInfoString =
        "Web browser ${webInfo.userAgent} on ${webInfo.platform}";
  }
  startupLogger.info("Running on $deviceInfoString.");
}
