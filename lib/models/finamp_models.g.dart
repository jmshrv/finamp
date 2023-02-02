// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finamp_models.dart';

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
      id: fields[0] as String,
      baseUrl: fields[1] as String,
      accessToken: fields[2] as String,
      serverId: fields[3] as String,
      currentViewId: fields[4] as String?,
      views: (fields[5] as Map).cast<String, BaseItemDto>(),
    );
  }

  @override
  void write(BinaryWriter writer, FinampUser obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.baseUrl)
      ..writeByte(2)
      ..write(obj.accessToken)
      ..writeByte(3)
      ..write(obj.serverId)
      ..writeByte(4)
      ..write(obj.currentViewId)
      ..writeByte(5)
      ..write(obj.views);
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
      downloadLocations: (fields[3] as List).cast<DownloadLocation>(),
      androidStopForegroundOnPause: fields[4] as bool,
      showTabs: (fields[5] as Map).cast<TabContentType, bool>(),
      isFavourite: fields[6] as bool,
      sortBy: fields[7] as SortBy,
      sortOrder: fields[8] as SortOrder,
      songShuffleItemCount: fields[9] == null ? 250 : fields[9] as int,
      contentViewType: fields[10] == null
          ? ContentViewType.list
          : fields[10] as ContentViewType,
      contentGridViewCrossAxisCountPortrait:
          fields[11] == null ? 2 : fields[11] as int,
      contentGridViewCrossAxisCountLandscape:
          fields[12] == null ? 3 : fields[12] as int,
      showTextOnGridView: fields[13] == null ? true : fields[13] as bool,
      sleepTimerSeconds: fields[14] == null ? 1800 : fields[14] as int,
      downloadLocationsMap: fields[15] == null
          ? {}
          : (fields[15] as Map).cast<String, DownloadLocation>(),
      showCoverAsPlayerBackground:
          fields[16] == null ? true : fields[16] as bool,
      hideSongArtistsIfSameAsAlbumArtists:
          fields[17] == null ? true : fields[17] as bool,
      bufferDurationSeconds: fields[18] == null ? 50 : fields[18] as int,
      transcodedDownloadBitrate:
          fields[20] == null ? 320000 : fields[20] as int,
    )..disableGesture = fields[19] == null ? false : fields[19] as bool;
  }

  @override
  void write(BinaryWriter writer, FinampSettings obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.isOffline)
      ..writeByte(1)
      ..write(obj.shouldTranscode)
      ..writeByte(2)
      ..write(obj.transcodeBitrate)
      ..writeByte(3)
      ..write(obj.downloadLocations)
      ..writeByte(4)
      ..write(obj.androidStopForegroundOnPause)
      ..writeByte(5)
      ..write(obj.showTabs)
      ..writeByte(6)
      ..write(obj.isFavourite)
      ..writeByte(7)
      ..write(obj.sortBy)
      ..writeByte(8)
      ..write(obj.sortOrder)
      ..writeByte(9)
      ..write(obj.songShuffleItemCount)
      ..writeByte(10)
      ..write(obj.contentViewType)
      ..writeByte(11)
      ..write(obj.contentGridViewCrossAxisCountPortrait)
      ..writeByte(12)
      ..write(obj.contentGridViewCrossAxisCountLandscape)
      ..writeByte(13)
      ..write(obj.showTextOnGridView)
      ..writeByte(14)
      ..write(obj.sleepTimerSeconds)
      ..writeByte(15)
      ..write(obj.downloadLocationsMap)
      ..writeByte(16)
      ..write(obj.showCoverAsPlayerBackground)
      ..writeByte(17)
      ..write(obj.hideSongArtistsIfSameAsAlbumArtists)
      ..writeByte(18)
      ..write(obj.bufferDurationSeconds)
      ..writeByte(19)
      ..write(obj.disableGesture)
      ..writeByte(20)
      ..write(obj.transcodedDownloadBitrate);
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

class DownloadLocationAdapter extends TypeAdapter<DownloadLocation> {
  @override
  final int typeId = 31;

  @override
  DownloadLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadLocation(
      name: fields[0] as String,
      path: fields[1] as String,
      useHumanReadableNames: fields[2] as bool,
      deletable: fields[3] as bool,
      id: fields[4] == null ? '0' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadLocation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.useHumanReadableNames)
      ..writeByte(3)
      ..write(obj.deletable)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      isPathRelative: fields[7] == null ? false : fields[7] as bool,
      downloadLocationId: fields[8] as String?,
      isTranscoded: fields[9] == null ? false : fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedSong obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.viewId)
      ..writeByte(7)
      ..write(obj.isPathRelative)
      ..writeByte(8)
      ..write(obj.downloadLocationId)
      ..writeByte(9)
      ..write(obj.isTranscoded);
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

class DownloadedImageAdapter extends TypeAdapter<DownloadedImage> {
  @override
  final int typeId = 40;

  @override
  DownloadedImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedImage(
      id: fields[0] as String,
      downloadId: fields[1] as String,
      path: fields[2] as String,
      requiredBy: (fields[3] as List).cast<String>(),
      downloadLocationId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedImage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.downloadId)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.requiredBy)
      ..writeByte(4)
      ..write(obj.downloadLocationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TabContentTypeAdapter extends TypeAdapter<TabContentType> {
  @override
  final int typeId = 36;

  @override
  TabContentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TabContentType.albums;
      case 1:
        return TabContentType.artists;
      case 2:
        return TabContentType.playlists;
      case 3:
        return TabContentType.genres;
      case 4:
        return TabContentType.songs;
      default:
        return TabContentType.albums;
    }
  }

  @override
  void write(BinaryWriter writer, TabContentType obj) {
    switch (obj) {
      case TabContentType.albums:
        writer.writeByte(0);
        break;
      case TabContentType.artists:
        writer.writeByte(1);
        break;
      case TabContentType.playlists:
        writer.writeByte(2);
        break;
      case TabContentType.genres:
        writer.writeByte(3);
        break;
      case TabContentType.songs:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabContentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentViewTypeAdapter extends TypeAdapter<ContentViewType> {
  @override
  final int typeId = 39;

  @override
  ContentViewType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ContentViewType.list;
      case 1:
        return ContentViewType.grid;
      default:
        return ContentViewType.list;
    }
  }

  @override
  void write(BinaryWriter writer, ContentViewType obj) {
    switch (obj) {
      case ContentViewType.list:
        writer.writeByte(0);
        break;
      case ContentViewType.grid:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentViewTypeAdapter &&
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
      isPathRelative: json['isPathRelative'] as bool? ?? true,
      downloadLocationId: json['downloadLocationId'] as String?,
      isTranscoded: json['isTranscoded'] as bool,
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
      'isPathRelative': instance.isPathRelative,
      'downloadLocationId': instance.downloadLocationId,
      'isTranscoded': instance.isTranscoded,
    };
