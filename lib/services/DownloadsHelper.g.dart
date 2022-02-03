// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DownloadsHelper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadedSongAdapter extends TypeAdapter<DownloadedSong> {
  @override
  final int typeId = 3;

  @override
  DownloadedSong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedSong(
      song: fields[0] as BaseItemDto,
      mediaSourceInfo: fields[1] as MediaSourceInfo,
      downloadId: fields[2] as String,
      requiredBy: (fields[3] as List).cast<String>(),
      path: fields[4] as String,
      useHumanReadableNames: fields[5] as bool,
      viewId: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedSong obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.song)
      ..writeByte(1)
      ..write(obj.mediaSourceInfo)
      ..writeByte(2)
      ..write(obj.downloadId)
      ..writeByte(3)
      ..write(obj.requiredBy)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(5)
      ..write(obj.useHumanReadableNames)
      ..writeByte(6)
      ..write(obj.viewId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedSongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadedParentAdapter extends TypeAdapter<DownloadedParent> {
  @override
  final int typeId = 4;

  @override
  DownloadedParent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedParent(
      item: fields[0] as BaseItemDto,
      downloadedChildren: (fields[1] as Map).cast<String, BaseItemDto>(),
      viewId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedParent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.downloadedChildren)
      ..writeByte(2)
      ..write(obj.viewId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedParentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadedSong _$DownloadedSongFromJson(Map json) => DownloadedSong(
      song:
          BaseItemDto.fromJson(Map<String, dynamic>.from(json['song'] as Map)),
      mediaSourceInfo: MediaSourceInfo.fromJson(
          Map<String, dynamic>.from(json['mediaSourceInfo'] as Map)),
      downloadId: json['downloadId'] as String,
      requiredBy: (json['requiredBy'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      path: json['path'] as String,
      useHumanReadableNames: json['useHumanReadableNames'] as bool,
      viewId: json['viewId'] as String,
    );

Map<String, dynamic> _$DownloadedSongToJson(DownloadedSong instance) =>
    <String, dynamic>{
      'song': instance.song.toJson(),
      'mediaSourceInfo': instance.mediaSourceInfo.toJson(),
      'downloadId': instance.downloadId,
      'requiredBy': instance.requiredBy,
      'path': instance.path,
      'useHumanReadableNames': instance.useHumanReadableNames,
      'viewId': instance.viewId,
    };
