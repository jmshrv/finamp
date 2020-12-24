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
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedSong obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.song)
      ..writeByte(1)
      ..write(obj.mediaSourceInfo)
      ..writeByte(2)
      ..write(obj.downloadId);
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

class DownloadedAlbumAdapter extends TypeAdapter<DownloadedAlbum> {
  @override
  final int typeId = 4;

  @override
  DownloadedAlbum read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedAlbum(
      album: fields[0] as BaseItemDto,
      children: (fields[1] as List)?.cast<BaseItemDto>(),
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedAlbum obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.album)
      ..writeByte(1)
      ..write(obj.children);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedAlbumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
