// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FinampModels.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinampUserAdapter extends TypeAdapter<FinampUser> {
  @override
  final int typeId = 8;

  @override
  FinampUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampUser(
      baseUrl: fields[0] as String,
      userDetails: fields[1] as AuthenticationResult,
      view: fields[2] as BaseItemDto,
    );
  }

  @override
  void write(BinaryWriter writer, FinampUser obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.baseUrl)
      ..writeByte(1)
      ..write(obj.userDetails)
      ..writeByte(2)
      ..write(obj.view);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampSettingsAdapter extends TypeAdapter<FinampSettings> {
  @override
  final int typeId = 28;

  @override
  FinampSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampSettings(
      isOffline: fields[0] as bool,
      shouldTranscode: fields[1] as bool,
      transcodeBitrate: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FinampSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isOffline)
      ..writeByte(1)
      ..write(obj.shouldTranscode)
      ..writeByte(2)
      ..write(obj.transcodeBitrate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinampLogRecord _$FinampLogRecordFromJson(Map<String, dynamic> json) {
  return FinampLogRecord(
    level: json['level'] == null
        ? null
        : FinampLevel.fromJson(json['level'] as Map<String, dynamic>),
    message: json['message'] as String,
    loggerName: json['loggerName'] as String,
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
  );
}

Map<String, dynamic> _$FinampLogRecordToJson(FinampLogRecord instance) =>
    <String, dynamic>{
      'level': instance.level?.toJson(),
      'message': instance.message,
      'loggerName': instance.loggerName,
      'time': instance.time?.toIso8601String(),
    };

FinampLevel _$FinampLevelFromJson(Map<String, dynamic> json) {
  return FinampLevel(
    json['name'] as String,
    json['value'] as int,
  );
}

Map<String, dynamic> _$FinampLevelToJson(FinampLevel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
