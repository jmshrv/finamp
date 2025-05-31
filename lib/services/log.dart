import "package:device_info_plus/device_info_plus.dart";
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  String deviceName;
  String deviceModel;
  String osVersion;

  DeviceInfo({
    required this.deviceName,
    required this.deviceModel,
    required this.osVersion,
  });

  static Future<DeviceInfo> fromPlatform() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (await deviceInfoPlugin.deviceInfo is AndroidDeviceInfo) {
      final info = await deviceInfoPlugin.androidInfo;
      return DeviceInfo(
        deviceName: info.brand,
        deviceModel: info.model,
        osVersion: info.version.release,
      );
    } else if (await deviceInfoPlugin.deviceInfo is IosDeviceInfo) {
      final info = await deviceInfoPlugin.iosInfo;
      return DeviceInfo(
        deviceName: info.name,
        deviceModel: info.model,
        osVersion: info.systemVersion,
      );
    } else if (await deviceInfoPlugin.deviceInfo is MacOsDeviceInfo) {
      final info = await deviceInfoPlugin.macOsInfo;
      return DeviceInfo(
        deviceName: info.computerName,
        deviceModel: info.model,
        osVersion: "${info.majorVersion}.${info.minorVersion}.${info.patchVersion}",
      );
    } else if (await deviceInfoPlugin.deviceInfo is LinuxDeviceInfo) {
      final info = await deviceInfoPlugin.linuxInfo;
      return DeviceInfo(
        deviceName: info.name,
        deviceModel: info.id,
        osVersion: info.version ?? 'Unknown',
      );
    } else if (await deviceInfoPlugin.deviceInfo is WindowsDeviceInfo) {
      final info = await deviceInfoPlugin.windowsInfo;
      return DeviceInfo(
        deviceName: info.computerName,
        deviceModel: info.deviceId,
        osVersion: info.displayVersion,
      );
    }
    // Add other platforms as needed...
    throw UnsupportedError("Unsupported platform");
  }

  Map<String, String> toJson() {
    return {
      'deviceName': deviceName,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
    };
  }
}

class AppInfo {
  String appName;
  String packageName;
  String version;
  String buildNumber;

  AppInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  static Future<AppInfo> fromPlatform() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return AppInfo(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }

  Map<String, String> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };
  }
}

class ServerInfo {
  String serverAddress;
  int serverPort;
  String serverProtocol;

  ServerInfo({
    required this.serverAddress,
    required this.serverPort,
    required this.serverProtocol,
  });

  static Future<ServerInfo> fromConfig() async {
    // Replace with actual logic to retrieve server configuration
    return ServerInfo(
      serverAddress: 'example.com',
      serverPort: 443,
      serverProtocol: 'https',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serverAddress': serverAddress,
      'serverPort': serverPort,
      'serverProtocol': serverProtocol,
    };
  }
}

class Log {
  final DeviceInfo deviceInfo;
  final AppInfo appInfo;
  final ServerInfo serverInfo;

  Log({
    required this.deviceInfo,
    required this.appInfo,
    required this.serverInfo,
  });

  // Async factory to create and populate all fields
  static Future<Log> create() async {
    final deviceInfo = await DeviceInfo.fromPlatform();
    final appInfo = await AppInfo.fromPlatform();
    final serverInfo = await ServerInfo.fromConfig();
    return Log(
      deviceInfo: deviceInfo,
      appInfo: appInfo,
      serverInfo: serverInfo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceInfo': deviceInfo.toJson(),
      'appInfo': appInfo.toJson(),
      'serverInfo': serverInfo.toJson(),
    };
  }
}