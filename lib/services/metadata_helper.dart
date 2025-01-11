import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';

final getIt = GetIt.instance;

class DeviceInfo {
  late String osVersion;
  late String deviceModel;
  late String deviceType;

  DeviceInfo();

  Future<void> init() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      osVersion = androidInfo.version.release;
      deviceModel = androidInfo.model;
      deviceType =
          "Phone"; // You can add more logic to determine the device type
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      osVersion = iosInfo.systemVersion;
      deviceModel = iosInfo.name;
      deviceType =
          "Phone"; // You can add more logic to determine the device type
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "osVersion": osVersion,
      "deviceModel": deviceModel,
      "deviceType": deviceType,
    };
  }
}

class AppInfo {
  late String version;
  late String originallyInstalledVersion;
  late DateTime installationDate;
  late List<Map<String, String>> updateHistory;

  AppInfo();

  Future<void> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    originallyInstalledVersion =
        "1.0.0"; // This should be fetched from persistent storage
    installationDate =
        DateTime.now(); // This should be fetched from persistent storage
    updateHistory = []; // This should be fetched from persistent storage
  }

  void addUpdateEvent(String newVersion) {
    updateHistory.add({
      "timestamp": DateTime.now().toIso8601String(),
      "version": newVersion,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "originallyInstalledVersion": originallyInstalledVersion,
      "installationDate": installationDate.toIso8601String(),
      "updateHistory": updateHistory,
    };
  }
}

enum AddressType { LocalIp, LocalDomain, FullDomain }

class ServerInfo {
  late String serverVersion;
  late String protocol;
  late AddressType addressType;

  ServerInfo();

  Future<void> init() async {
    // Fetch server information dynamically
    serverVersion = "1.2.3"; // This should be fetched from the server
    protocol = "HTTPS"; // This should be fetched from the server
    addressType = AddressType
        .FullDomain; // This should be determined based on the server address
  }

  Map<String, dynamic> toJson() {
    return {
      "serverVersion": serverVersion,
      "protocol": protocol,
      "addressType": addressType.toString(),
    };
  }
}

enum MetaDataType { AppInfo, ServerInfo, DeviceInfo, All }

class MetaData {
  late AppInfo appInfo;
  late ServerInfo serverInfo;
  late DeviceInfo deviceInfo;

  MetaData() {
    appInfo = getIt<AppInfo>();
    serverInfo = getIt<ServerInfo>();
    deviceInfo = getIt<DeviceInfo>();
  }

  Future<void> init() async {
    await appInfo.init();
    await serverInfo.init();
    await deviceInfo.init();
  }

  Map<String, dynamic> toJson(MetaDataType type) {
    switch (type) {
      case MetaDataType.AppInfo:
        return appInfo.toJson();
      case MetaDataType.ServerInfo:
        return serverInfo.toJson();
      case MetaDataType.DeviceInfo:
        return deviceInfo.toJson();
      case MetaDataType.All:
        return {
          "appInfo": appInfo.toJson(),
          "serverInfo": serverInfo.toJson(),
          "deviceInfo": deviceInfo.toJson(),
        };
    }
  }
}

void setupLocator() {
  getIt.registerLazySingleton(() => DeviceInfo());
  getIt.registerLazySingleton(() => AppInfo());
  getIt.registerLazySingleton(() => ServerInfo());
}
