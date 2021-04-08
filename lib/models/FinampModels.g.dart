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
    );
  }

  @override
  void write(BinaryWriter writer, FinampSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isOffline);
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

class FinampLogRecordAdapter extends TypeAdapter<FinampLogRecord> {
  @override
  final int typeId = 29;

  @override
  FinampLogRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampLogRecord(
      level: fields[0] as FinampLevel,
      message: fields[1] as String,
      loggerName: fields[2] as String,
      time: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FinampLogRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.loggerName)
      ..writeByte(3)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampLogRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampLevelAdapter extends TypeAdapter<FinampLevel> {
  @override
  final int typeId = 30;

  @override
  FinampLevel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampLevel(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FinampLevel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
