import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

import 'JellyfinModels.dart';

part 'FinampModels.g.dart';

@HiveType(typeId: 8)
class FinampUser {
  FinampUser({
    this.baseUrl,
    this.userDetails,
    this.view,
  });

  @HiveField(0)
  String baseUrl;
  @HiveField(1)
  AuthenticationResult userDetails;
  @HiveField(2)
  BaseItemDto view;
}

@HiveType(typeId: 28)
class FinampSettings {
  FinampSettings({
    this.isOffline = false,
    this.shouldTranscode = false,
    this.transcodeBitrate = 32000,
  });

  @HiveField(0)
  bool isOffline;
  @HiveField(1)
  bool shouldTranscode;
  @HiveField(2)
  int transcodeBitrate;
}

/// This is a copy of LogRecord from the logging package with support for json serialising.
/// Once audio_service 0.18.0 releases, this won't be needed anymore.
/// Serialisation is only needed so that we can pass these objects through isolates.
@JsonSerializable(explicitToJson: true)
class FinampLogRecord {
  FinampLogRecord({
    this.level,
    this.message,
    this.loggerName,
    this.time,
  });

  final FinampLevel level;
  final String message;

  /// Logger where this record is stored.
  final String loggerName;

  /// Time when this record was created.
  final DateTime time;

  static FinampLogRecord fromLogRecord(LogRecord logRecord) => FinampLogRecord(
        level: FinampLevel(logRecord.level.name, logRecord.level.value),
        loggerName: logRecord.loggerName,
        message: logRecord.message,
        time: logRecord.time,
      );

  factory FinampLogRecord.fromJson(Map<String, dynamic> json) =>
      _$FinampLogRecordFromJson(json);
  Map<String, dynamic> toJson() => _$FinampLogRecordToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FinampLevel implements Comparable<FinampLevel> {
  final String name;

  /// Unique value for this level. Used to order levels, so filtering can
  /// exclude messages whose level is under certain value.
  final int value;

  const FinampLevel(this.name, this.value);

  /// Special key to turn on logging for all levels ([value] = 0).
  static const FinampLevel ALL = FinampLevel('ALL', 0);

  /// Special key to turn off all logging ([value] = 2000).
  static const FinampLevel OFF = FinampLevel('OFF', 2000);

  /// Key for highly detailed tracing ([value] = 300).
  static const FinampLevel FINEST = FinampLevel('FINEST', 300);

  /// Key for fairly detailed tracing ([value] = 400).
  static const FinampLevel FINER = FinampLevel('FINER', 400);

  /// Key for tracing information ([value] = 500).
  static const FinampLevel FINE = FinampLevel('FINE', 500);

  /// Key for static configuration messages ([value] = 700).
  static const FinampLevel CONFIG = FinampLevel('CONFIG', 700);

  /// Key for informational messages ([value] = 800).
  static const FinampLevel INFO = FinampLevel('INFO', 800);

  /// Key for potential problems ([value] = 900).
  static const FinampLevel WARNING = FinampLevel('WARNING', 900);

  /// Key for serious failures ([value] = 1000).
  static const FinampLevel SEVERE = FinampLevel('SEVERE', 1000);

  /// Key for extra debugging loudness ([value] = 1200).
  static const FinampLevel SHOUT = FinampLevel('SHOUT', 1200);

  static const List<FinampLevel> LEVELS = [
    ALL,
    FINEST,
    FINER,
    FINE,
    CONFIG,
    INFO,
    WARNING,
    SEVERE,
    SHOUT,
    OFF
  ];

  @override
  bool operator ==(Object other) =>
      other is FinampLevel && value == other.value;

  bool operator <(FinampLevel other) => value < other.value;

  bool operator <=(FinampLevel other) => value <= other.value;

  bool operator >(FinampLevel other) => value > other.value;

  bool operator >=(FinampLevel other) => value >= other.value;

  @override
  int compareTo(FinampLevel other) => value - other.value;

  @override
  int get hashCode => value;

  @override
  String toString() => name;

  factory FinampLevel.fromJson(Map<String, dynamic> json) =>
      _$FinampLevelFromJson(json);
  Map<String, dynamic> toJson() => _$FinampLevelToJson(this);
}
