// This file collects structured metadata about the device, app, and server
// for logging, analytics, and diagnostics.

import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hive_ce/hive.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api.dart';

part 'log.g.dart';

/// -------------------- DEVICE INFO --------------------

/// Contains information about the current device (model, OS, platform).
@JsonSerializable()
class DeviceInfo {
  final String deviceName;
  final String deviceModel;
  final String osVersion;
  final String platform;

  DeviceInfo({
    required this.deviceName,
    required this.deviceModel,
    required this.osVersion,
    required this.platform,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => _$DeviceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);

  /// Detects device info based on the current platform.
  static Future<DeviceInfo> fromPlatform() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfoPlugin.androidInfo;
      return DeviceInfo(
        deviceName: info.brand,
        deviceModel: info.model,
        osVersion: info.version.release,
        platform: 'Android',
      );
    } else if (Platform.isIOS) {
      final info = await deviceInfoPlugin.iosInfo;
      return DeviceInfo(
        deviceName: info.name,
        deviceModel: info.model,
        osVersion: info.systemVersion,
        platform: 'iOS',
      );
    } else if (Platform.isMacOS) {
      final info = await deviceInfoPlugin.macOsInfo;
      return DeviceInfo(
        deviceName: info.computerName,
        deviceModel: info.model,
        osVersion: "${info.majorVersion}.${info.minorVersion}.${info.patchVersion}",
        platform: 'macOS',
      );
    } else if (Platform.isLinux) {
      final info = await deviceInfoPlugin.linuxInfo;
      return DeviceInfo(
        deviceName: info.name,
        deviceModel: info.id,
        osVersion: info.version ?? 'Unknown',
        platform: 'Linux',
      );
    } else if (Platform.isWindows) {
      final info = await deviceInfoPlugin.windowsInfo;
      return DeviceInfo(
        deviceName: info.computerName,
        deviceModel: info.deviceId,
        osVersion: info.displayVersion,
        platform: 'Windows',
      );
    }

    throw UnsupportedError("Unsupported platform");
  }
}

/// -------------------- APP INFO --------------------

/// Contains information about the app itself (name, version, history).
@JsonSerializable()
class AppInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final List<String> versionHistory;

  AppInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    required this.versionHistory,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) => _$AppInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AppInfoToJson(this);

  /// Detects app metadata using package_info_plus and updates stored version history.
  static Future<AppInfo> fromPlatform() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final box = Hive.box<dynamic>('app_info');
    final currentVersion = packageInfo.version;

    final previousVersion = box.get('previous_version') as String?;
    final history = List<String>.from(
      box.get('version_history', defaultValue: <String>[]) as List<dynamic>,
    );

    if (previousVersion != null && previousVersion != currentVersion) {
      final timestamp = DateTime.now().toIso8601String();
      history.add('$timestamp - v$currentVersion');
      await box.put('previous_version', currentVersion);
      await box.put('version_history', history);
    } else if (previousVersion == null) {
      await box.put('previous_version', currentVersion);
      await box.put('version_history', history);
    }

    return AppInfo(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      versionHistory: history,
    );
  }
}

/// -------------------- SERVER INFO --------------------

/// Contains information about the Jellyfin server in use.
@JsonSerializable()
class ServerInfo {
  final String serverAddress;
  final int serverPort;
  final String serverProtocol;

  ServerInfo({
    required this.serverAddress,
    required this.serverPort,
    required this.serverProtocol,
  });

  factory ServerInfo.fromJson(Map<String, dynamic> json) => _$ServerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ServerInfoToJson(this);

  /// Extracts server info from the current user's base URL.
  static Future<ServerInfo?> fromServer() async {
    final userHelper = GetIt.instance<FinampUserHelper>();
    final user = userHelper.currentUser;
    if (user == null) return null;

    final uri = Uri.parse(user.baseURL);
    return ServerInfo(
      serverAddress: uri.host,
      serverPort: uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80),
      serverProtocol: uri.scheme,
    );
  }

  /// Queries the server API for the current version.
  static Future<String?> fetchServerVersion() async {
    try {
      final api = GetIt.instance<JellyfinApi>();
      final response = await api.getPublicServerInfo();
      final version = response.body?['Version'] ?? response.body?['version'];
      return version?.toString();
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toCensoredJson() {
      return {
        'serverAddress': 'REDACTED',
        'serverPort': serverPort,
        'serverProtocol': serverProtocol,
        'serverVersion': fetchServerVersion(),
      };
  }
}

/// -------------------- LOG WRAPPER --------------------

/// Encapsulates device and app info for logging.
class Log {
  final DeviceInfo deviceInfo;
  final AppInfo appInfo;
  final ServerInfo? serverInfo;
  Log({
    required this.deviceInfo,
    required this.appInfo,
    required this.serverInfo
  });

  /// Constructs a full log instance from platform metadata.
  static Future<Log> create() async {
    final deviceInfo = await DeviceInfo.fromPlatform();
    final appInfo = await AppInfo.fromPlatform();
    final serverInfo = await ServerInfo.fromServer();
    return Log(deviceInfo: deviceInfo, appInfo: appInfo, serverInfo: serverInfo);
  }

  /// Serializes log to JSON
  Future<Map<String, dynamic>> toJson() async {
    final serverInfo = await ServerInfo.fromServer();
    return {
      'deviceInfo': deviceInfo.toJson(),
      'appInfo': appInfo.toJson(),
      'serverInfo': serverInfo?.toJson(),
    };
  }
}

/// Censored version of Metadata, hiding Server address.
extension LogCensor on Log {
  Future<Map<String, dynamic>> toJsonCensored() async {
    final serverInfo = await ServerInfo.fromServer();

    return {
      'deviceInfo': deviceInfo.toJson(),
      'appInfo': appInfo.toJson(),
      'serverInfo': serverInfo?.toCensoredJson(),
    };
  }

  /// Logs metadata at startup.
  Future<void> logMetadata() async {
    final metadata = await toJsonCensored();
    final logger = Logger('Startup');

    logger.info('App Metadata on startup:\n$metadata');
  }

}
