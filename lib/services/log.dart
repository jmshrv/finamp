import "package:device_info_plus/device_info_plus.dart";
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'dart:io' show Platform;

import 'finamp_user_helper.dart';
import 'jellyfin_api.dart';

// Collects device information from the platform
class DeviceInfo {
  String deviceName;
  String deviceModel;
  String osVersion;

  DeviceInfo({
    required this.deviceName,
    required this.deviceModel,
    required this.osVersion,
  });

  // Factory method to create DeviceInfo from the current platform
  static Future<DeviceInfo> fromPlatform() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      // Android-specific device info
      final info = await deviceInfoPlugin.androidInfo;
      return DeviceInfo(
        deviceName: info.brand,
        deviceModel: info.model,
        osVersion: info.version.release,
      );
    } else if (Platform.isIOS) {
      // iOS-specific device info
      final info = await deviceInfoPlugin.iosInfo;
      return DeviceInfo(
        deviceName: info.name,
        deviceModel: info.model,
        osVersion: info.systemVersion,
      );
    } else if (Platform.isMacOS) {
      // macOS-specific device info
      final info = await deviceInfoPlugin.macOsInfo;
      return DeviceInfo(
        deviceName: info.computerName,
        deviceModel: info.model,
        osVersion: "${info.majorVersion}.${info.minorVersion}.${info.patchVersion}",
      );
    } else if (Platform.isLinux) {
      // Linux-specific device info
      final info = await deviceInfoPlugin.linuxInfo;
      return DeviceInfo(
        deviceName: info.name,
        deviceModel: info.id,
        osVersion: info.version ?? 'Unknown',
      );
    } else if (Platform.isWindows) {
      // Windows-specific device info
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

  // Serializes device info to a map
  Map<String, String> toJson() {
    return {
      'deviceName': deviceName,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
    };
  }
}

// Collects app information from the platform
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

  // Factory method to create AppInfo from the current platform
  static Future<AppInfo> fromPlatform() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return AppInfo(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }

  // Serializes app info to a map
  Map<String, String> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };
  }
}

// Collects server information from the current user/session
class ServerInfo {
  String serverAddress;
  int serverPort;
  String serverProtocol;

  ServerInfo({
    required this.serverAddress,
    required this.serverPort,
    required this.serverProtocol,
  });

  // Factory method to create ServerInfo from the current user's server config
  static Future<ServerInfo> fromServer() async {
    final userHelper = GetIt.instance<FinampUserHelper>();
    final user = userHelper.currentUser;
    if (user == null) {
      // Fallback if no user is logged in
      return ServerInfo(
        serverAddress: 'REDACTED',
        serverPort: 443,
        serverProtocol: 'https',
      );
    }
    final uri = Uri.parse(user.baseURL);
    return ServerInfo(
      serverAddress: uri.host,
      serverPort: uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80),
      serverProtocol: uri.scheme,
    );
  }

  // Fetches the server version from the Jellyfin API (on demand)
  static Future<String?> fetchServerVersion() async {
    try {
      final api = GetIt.instance<JellyfinApi>();
      final response = await api.getPublicServerInfo();
      // The response body should contain the version info, adjust as needed:
      final version = response.body?['Version'] ?? response.body?['version'];
      return version?.toString();
    } catch (e) {
      return null;
    }
  }

  // Serializes server info to a map, optionally including the server version
  Map<String, dynamic> toJson({String? serverVersion}) {
    return {
      'serverAddress': serverAddress,
      'serverPort': serverPort,
      'serverProtocol': serverProtocol,
      if (serverVersion != null) 'serverVersion': serverVersion,
    };
  }
}

// Central log metadata class, collects device and app info at startup
class Log {
  final DeviceInfo deviceInfo;
  final AppInfo appInfo;
  
  Log({
    required this.deviceInfo,
    required this.appInfo,
  });

  // Factory method to create Log with device and app info only
  static Future<Log> create() async {
    final deviceInfo = await DeviceInfo.fromPlatform();
    final appInfo = await AppInfo.fromPlatform();
    return Log(
      deviceInfo: deviceInfo,
      appInfo: appInfo,
    );
  }

  // Serializes log info, fetching server info on demand
  Future<Map<String, dynamic>> toJson() async{
    // Fetch server info on demand, this can be slow so we do it here
    final serverInfo = await ServerInfo.fromServer();

    return {
      'deviceInfo': deviceInfo.toJson(),
      'appInfo': appInfo.toJson(),
      'serverInfo': serverInfo.toJson(), // Removed serverInfo field
    };
  }
}

// Extension to always censor the server address in exported logs
extension ServerInfoCensor on ServerInfo {
  Map<String, dynamic> toCensoredJson({String? serverVersion}) => {
    'serverAddress': 'REDACTED',
    'serverPort': serverPort,
    'serverProtocol': serverProtocol,
    if (serverVersion != null) 'serverVersion': serverVersion,
  };
}

// Extension to fetch and export censored log metadata on demand
extension LogCensor on Log {
  Future<Map<String, dynamic>> toCensoredJsonOnDemand() async {
    final serverInfo = await ServerInfo.fromServer();
    final version = await ServerInfo.fetchServerVersion();
    
    return {
      'deviceInfo': deviceInfo.toJson(),
      'appInfo': appInfo.toJson(),
      'serverInfo': serverInfo.toCensoredJson(serverVersion: version),
    };
  }
}