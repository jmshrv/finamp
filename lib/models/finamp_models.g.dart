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
      bufferDurationSeconds: fields[18] == null ? 600 : fields[18] as int,
      tabSortBy: fields[20] == null
          ? {}
          : (fields[20] as Map).cast<TabContentType, SortBy>(),
      tabSortOrder: fields[21] == null
          ? {}
          : (fields[21] as Map).cast<TabContentType, SortOrder>(),
      loopMode: fields[26] == null
          ? FinampLoopMode.all
          : fields[26] as FinampLoopMode,
      tabOrder: fields[22] == null
          ? [
              TabContentType.albums,
              TabContentType.artists,
              TabContentType.playlists,
              TabContentType.genres,
              TabContentType.songs
            ]
          : (fields[22] as List).cast<TabContentType>(),
      autoloadLastQueueOnStartup:
          fields[27] == null ? true : fields[27] as bool,
      hasCompletedBlurhashImageMigration:
          fields[23] == null ? false : fields[23] as bool,
      hasCompletedBlurhashImageMigrationIdFix:
          fields[24] == null ? false : fields[24] as bool,
    )
      ..disableGesture = fields[19] == null ? false : fields[19] as bool
      ..showFastScroller = fields[25] == null ? true : fields[25] as bool;
  }

  @override
  void write(BinaryWriter writer, FinampSettings obj) {
    writer
      ..writeByte(28)
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
      ..write(obj.tabSortBy)
      ..writeByte(21)
      ..write(obj.tabSortOrder)
      ..writeByte(22)
      ..write(obj.tabOrder)
      ..writeByte(23)
      ..write(obj.hasCompletedBlurhashImageMigration)
      ..writeByte(24)
      ..write(obj.hasCompletedBlurhashImageMigrationIdFix)
      ..writeByte(25)
      ..write(obj.showFastScroller)
      ..writeByte(26)
      ..write(obj.loopMode)
      ..writeByte(27)
      ..write(obj.autoloadLastQueueOnStartup);
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
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedSong obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.downloadLocationId);
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

class OfflineListenAdapter extends TypeAdapter<OfflineListen> {
  @override
  final int typeId = 43;

  @override
  OfflineListen read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineListen(
      timestamp: fields[0] as int,
      userId: fields[1] as String,
      itemId: fields[2] as String,
      name: fields[3] as String,
      artist: fields[4] as String?,
      album: fields[5] as String?,
      trackMbid: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineListen obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.itemId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.artist)
      ..writeByte(5)
      ..write(obj.album)
      ..writeByte(6)
      ..write(obj.trackMbid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineListenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueueItemSourceAdapter extends TypeAdapter<QueueItemSource> {
  @override
  final int typeId = 54;

  @override
  QueueItemSource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QueueItemSource(
      type: fields[0] as QueueItemSourceType,
      name: fields[1] as QueueItemSourceName,
      id: fields[2] as String,
      item: fields[3] as BaseItemDto?,
    );
  }

  @override
  void write(BinaryWriter writer, QueueItemSource obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.item);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueItemSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueueItemSourceNameAdapter extends TypeAdapter<QueueItemSourceName> {
  @override
  final int typeId = 56;

  @override
  QueueItemSourceName read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QueueItemSourceName(
      type: fields[0] as QueueItemSourceNameType,
      pretranslatedName: fields[1] as String?,
      localizationParameter: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QueueItemSourceName obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.pretranslatedName)
      ..writeByte(2)
      ..write(obj.localizationParameter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueItemSourceNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampQueueItemAdapter extends TypeAdapter<FinampQueueItem> {
  @override
  final int typeId = 57;

  @override
  FinampQueueItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampQueueItem(
      item: fields[1] as MediaItem,
      source: fields[2] as QueueItemSource,
      type: fields[3] as QueueItemQueueType,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, FinampQueueItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.item)
      ..writeByte(2)
      ..write(obj.source)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampQueueItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampQueueOrderAdapter extends TypeAdapter<FinampQueueOrder> {
  @override
  final int typeId = 58;

  @override
  FinampQueueOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampQueueOrder(
      items: (fields[0] as List).cast<FinampQueueItem>(),
      originalSource: fields[1] as QueueItemSource,
      linearOrder: (fields[2] as List).cast<int>(),
      shuffledOrder: (fields[3] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, FinampQueueOrder obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.items)
      ..writeByte(1)
      ..write(obj.originalSource)
      ..writeByte(2)
      ..write(obj.linearOrder)
      ..writeByte(3)
      ..write(obj.shuffledOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampQueueOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampQueueInfoAdapter extends TypeAdapter<FinampQueueInfo> {
  @override
  final int typeId = 59;

  @override
  FinampQueueInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampQueueInfo(
      previousTracks: (fields[0] as List).cast<FinampQueueItem>(),
      currentTrack: fields[1] as FinampQueueItem?,
      nextUp: (fields[2] as List).cast<FinampQueueItem>(),
      queue: (fields[3] as List).cast<FinampQueueItem>(),
      source: fields[4] as QueueItemSource,
      saveState: fields[5] as SavedQueueState,
    );
  }

  @override
  void write(BinaryWriter writer, FinampQueueInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.previousTracks)
      ..writeByte(1)
      ..write(obj.currentTrack)
      ..writeByte(2)
      ..write(obj.nextUp)
      ..writeByte(3)
      ..write(obj.queue)
      ..writeByte(4)
      ..write(obj.source)
      ..writeByte(5)
      ..write(obj.saveState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampQueueInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampHistoryItemAdapter extends TypeAdapter<FinampHistoryItem> {
  @override
  final int typeId = 60;

  @override
  FinampHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampHistoryItem(
      item: fields[0] as FinampQueueItem,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FinampHistoryItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampStorableQueueInfoAdapter
    extends TypeAdapter<FinampStorableQueueInfo> {
  @override
  final int typeId = 61;

  @override
  FinampStorableQueueInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampStorableQueueInfo(
      previousTracks: (fields[0] as List).cast<String>(),
      currentTrack: fields[1] as String?,
      currentTrackSeek: fields[2] as int?,
      nextUp: (fields[3] as List).cast<String>(),
      queue: (fields[4] as List).cast<String>(),
      creation: fields[5] as int,
      source: fields[6] as QueueItemSource?,
    );
  }

  @override
  void write(BinaryWriter writer, FinampStorableQueueInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.previousTracks)
      ..writeByte(1)
      ..write(obj.currentTrack)
      ..writeByte(2)
      ..write(obj.currentTrackSeek)
      ..writeByte(3)
      ..write(obj.nextUp)
      ..writeByte(4)
      ..write(obj.queue)
      ..writeByte(5)
      ..write(obj.creation)
      ..writeByte(6)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampStorableQueueInfoAdapter &&
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

class FinampPlaybackOrderAdapter extends TypeAdapter<FinampPlaybackOrder> {
  @override
  final int typeId = 50;

  @override
  FinampPlaybackOrder read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FinampPlaybackOrder.shuffled;
      case 1:
        return FinampPlaybackOrder.linear;
      default:
        return FinampPlaybackOrder.shuffled;
    }
  }

  @override
  void write(BinaryWriter writer, FinampPlaybackOrder obj) {
    switch (obj) {
      case FinampPlaybackOrder.shuffled:
        writer.writeByte(0);
        break;
      case FinampPlaybackOrder.linear:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampPlaybackOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampLoopModeAdapter extends TypeAdapter<FinampLoopMode> {
  @override
  final int typeId = 51;

  @override
  FinampLoopMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FinampLoopMode.none;
      case 1:
        return FinampLoopMode.one;
      case 2:
        return FinampLoopMode.all;
      default:
        return FinampLoopMode.none;
    }
  }

  @override
  void write(BinaryWriter writer, FinampLoopMode obj) {
    switch (obj) {
      case FinampLoopMode.none:
        writer.writeByte(0);
        break;
      case FinampLoopMode.one:
        writer.writeByte(1);
        break;
      case FinampLoopMode.all:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampLoopModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueueItemSourceTypeAdapter extends TypeAdapter<QueueItemSourceType> {
  @override
  final int typeId = 52;

  @override
  QueueItemSourceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QueueItemSourceType.album;
      case 1:
        return QueueItemSourceType.playlist;
      case 2:
        return QueueItemSourceType.songMix;
      case 3:
        return QueueItemSourceType.artistMix;
      case 4:
        return QueueItemSourceType.albumMix;
      case 5:
        return QueueItemSourceType.favorites;
      case 6:
        return QueueItemSourceType.allSongs;
      case 7:
        return QueueItemSourceType.filteredList;
      case 8:
        return QueueItemSourceType.genre;
      case 9:
        return QueueItemSourceType.artist;
      case 10:
        return QueueItemSourceType.nextUp;
      case 11:
        return QueueItemSourceType.nextUpAlbum;
      case 12:
        return QueueItemSourceType.nextUpPlaylist;
      case 13:
        return QueueItemSourceType.nextUpArtist;
      case 14:
        return QueueItemSourceType.formerNextUp;
      case 15:
        return QueueItemSourceType.downloads;
      case 16:
        return QueueItemSourceType.unknown;
      default:
        return QueueItemSourceType.album;
    }
  }

  @override
  void write(BinaryWriter writer, QueueItemSourceType obj) {
    switch (obj) {
      case QueueItemSourceType.album:
        writer.writeByte(0);
        break;
      case QueueItemSourceType.playlist:
        writer.writeByte(1);
        break;
      case QueueItemSourceType.songMix:
        writer.writeByte(2);
        break;
      case QueueItemSourceType.artistMix:
        writer.writeByte(3);
        break;
      case QueueItemSourceType.albumMix:
        writer.writeByte(4);
        break;
      case QueueItemSourceType.favorites:
        writer.writeByte(5);
        break;
      case QueueItemSourceType.allSongs:
        writer.writeByte(6);
        break;
      case QueueItemSourceType.filteredList:
        writer.writeByte(7);
        break;
      case QueueItemSourceType.genre:
        writer.writeByte(8);
        break;
      case QueueItemSourceType.artist:
        writer.writeByte(9);
        break;
      case QueueItemSourceType.nextUp:
        writer.writeByte(10);
        break;
      case QueueItemSourceType.nextUpAlbum:
        writer.writeByte(11);
        break;
      case QueueItemSourceType.nextUpPlaylist:
        writer.writeByte(12);
        break;
      case QueueItemSourceType.nextUpArtist:
        writer.writeByte(13);
        break;
      case QueueItemSourceType.formerNextUp:
        writer.writeByte(14);
        break;
      case QueueItemSourceType.downloads:
        writer.writeByte(15);
        break;
      case QueueItemSourceType.unknown:
        writer.writeByte(16);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueItemSourceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueueItemQueueTypeAdapter extends TypeAdapter<QueueItemQueueType> {
  @override
  final int typeId = 53;

  @override
  QueueItemQueueType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QueueItemQueueType.previousTracks;
      case 1:
        return QueueItemQueueType.currentTrack;
      case 2:
        return QueueItemQueueType.nextUp;
      case 3:
        return QueueItemQueueType.queue;
      default:
        return QueueItemQueueType.previousTracks;
    }
  }

  @override
  void write(BinaryWriter writer, QueueItemQueueType obj) {
    switch (obj) {
      case QueueItemQueueType.previousTracks:
        writer.writeByte(0);
        break;
      case QueueItemQueueType.currentTrack:
        writer.writeByte(1);
        break;
      case QueueItemQueueType.nextUp:
        writer.writeByte(2);
        break;
      case QueueItemQueueType.queue:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueItemQueueTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueueItemSourceNameTypeAdapter
    extends TypeAdapter<QueueItemSourceNameType> {
  @override
  final int typeId = 55;

  @override
  QueueItemSourceNameType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QueueItemSourceNameType.preTranslated;
      case 1:
        return QueueItemSourceNameType.yourLikes;
      case 2:
        return QueueItemSourceNameType.shuffleAll;
      case 3:
        return QueueItemSourceNameType.mix;
      case 4:
        return QueueItemSourceNameType.instantMix;
      case 5:
        return QueueItemSourceNameType.nextUp;
      case 6:
        return QueueItemSourceNameType.tracksFormerNextUp;
      case 7:
        return QueueItemSourceNameType.savedQueue;
      default:
        return QueueItemSourceNameType.preTranslated;
    }
  }

  @override
  void write(BinaryWriter writer, QueueItemSourceNameType obj) {
    switch (obj) {
      case QueueItemSourceNameType.preTranslated:
        writer.writeByte(0);
        break;
      case QueueItemSourceNameType.yourLikes:
        writer.writeByte(1);
        break;
      case QueueItemSourceNameType.shuffleAll:
        writer.writeByte(2);
        break;
      case QueueItemSourceNameType.mix:
        writer.writeByte(3);
        break;
      case QueueItemSourceNameType.instantMix:
        writer.writeByte(4);
        break;
      case QueueItemSourceNameType.nextUp:
        writer.writeByte(5);
        break;
      case QueueItemSourceNameType.tracksFormerNextUp:
        writer.writeByte(6);
        break;
      case QueueItemSourceNameType.savedQueue:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueItemSourceNameTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SavedQueueStateAdapter extends TypeAdapter<SavedQueueState> {
  @override
  final int typeId = 62;

  @override
  SavedQueueState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SavedQueueState.preInit;
      case 1:
        return SavedQueueState.init;
      case 2:
        return SavedQueueState.loading;
      case 3:
        return SavedQueueState.saving;
      case 4:
        return SavedQueueState.failed;
      case 5:
        return SavedQueueState.pendingSave;
      default:
        return SavedQueueState.preInit;
    }
  }

  @override
  void write(BinaryWriter writer, SavedQueueState obj) {
    switch (obj) {
      case SavedQueueState.preInit:
        writer.writeByte(0);
        break;
      case SavedQueueState.init:
        writer.writeByte(1);
        break;
      case SavedQueueState.loading:
        writer.writeByte(2);
        break;
      case SavedQueueState.saving:
        writer.writeByte(3);
        break;
      case SavedQueueState.failed:
        writer.writeByte(4);
        break;
      case SavedQueueState.pendingSave:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedQueueStateAdapter &&
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
    };
