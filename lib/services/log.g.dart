// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      deviceName: json['deviceName'] as String,
      deviceModel: json['deviceModel'] as String,
      osVersion: json['osVersion'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'deviceName': instance.deviceName,
      'deviceModel': instance.deviceModel,
      'osVersion': instance.osVersion,
      'platform': instance.platform,
    };

AppInfo _$AppInfoFromJson(Map<String, dynamic> json) => AppInfo(
      appName: json['appName'] as String,
      packageName: json['packageName'] as String,
      version: json['version'] as String,
      buildNumber: json['buildNumber'] as String,
      versionHistory: (json['versionHistory'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AppInfoToJson(AppInfo instance) => <String, dynamic>{
      'appName': instance.appName,
      'packageName': instance.packageName,
      'version': instance.version,
      'buildNumber': instance.buildNumber,
      'versionHistory': instance.versionHistory,
    };

ServerInfo _$ServerInfoFromJson(Map<String, dynamic> json) => ServerInfo(
      serverAddress: json['serverAddress'] as String,
      serverPort: (json['serverPort'] as num).toInt(),
      serverProtocol: json['serverProtocol'] as String,
    );

Map<String, dynamic> _$ServerInfoToJson(ServerInfo instance) =>
    <String, dynamic>{
      'serverAddress': instance.serverAddress,
      'serverPort': instance.serverPort,
      'serverProtocol': instance.serverProtocol,
    };
