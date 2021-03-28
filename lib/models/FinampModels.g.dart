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
