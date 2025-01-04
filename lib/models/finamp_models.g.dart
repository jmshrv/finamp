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
      isOffline: fields[0] == null ? false : fields[0] as bool,
      shouldTranscode: fields[1] == null ? false : fields[1] as bool,
      transcodeBitrate: fields[2] == null ? 320000 : fields[2] as int,
      downloadLocations: (fields[3] as List).cast<DownloadLocation>(),
      androidStopForegroundOnPause:
          fields[4] == null ? true : fields[4] as bool,
      showTabs: (fields[5] as Map).cast<TabContentType, bool>(),
      onlyShowFavourites: fields[6] == null ? false : fields[6] as bool,
      sortBy: fields[7] as SortBy,
      sortOrder: fields[8] as SortOrder,
      songShuffleItemCount: fields[9] == null ? 250 : fields[9] as int,
      volumeNormalizationActive: fields[29] == null ? true : fields[29] as bool,
      volumeNormalizationIOSBaseGain:
          fields[30] == null ? -2.0 : fields[30] as double,
      volumeNormalizationMode: fields[33] == null
          ? VolumeNormalizationMode.hybrid
          : fields[33] as VolumeNormalizationMode,
      contentViewType: fields[10] == null
          ? ContentViewType.list
          : fields[10] as ContentViewType,
      playbackSpeedVisibility: fields[57] == null
          ? PlaybackSpeedVisibility.automatic
          : fields[57] as PlaybackSpeedVisibility,
      contentGridViewCrossAxisCountPortrait:
          fields[11] == null ? 2 : fields[11] as int,
      contentGridViewCrossAxisCountLandscape:
          fields[12] == null ? 3 : fields[12] as int,
      showTextOnGridView: fields[13] == null ? true : fields[13] as bool,
      sleepTimerSeconds: fields[14] == null ? 1800 : fields[14] as int,
      downloadLocationsMap: fields[15] == null
          ? {}
          : (fields[15] as Map).cast<String, DownloadLocation>(),
      useCoverAsBackground: fields[16] == null ? true : fields[16] as bool,
      playerScreenCoverMinimumPadding:
          fields[48] == null ? 1.5 : fields[48] as double,
      showArtistsTopSongs: fields[54] == null ? true : fields[54] as bool,
      bufferDurationSeconds: fields[18] == null ? 600 : fields[18] as int,
      tabSortBy: fields[20] == null
          ? {}
          : (fields[20] as Map).cast<TabContentType, SortBy>(),
      tabSortOrder: fields[21] == null
          ? {}
          : (fields[21] as Map).cast<TabContentType, SortOrder>(),
      loopMode: fields[27] == null
          ? FinampLoopMode.none
          : fields[27] as FinampLoopMode,
      playbackSpeed: fields[56] == null ? 1.0 : fields[56] as double,
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
          fields[28] == null ? true : fields[28] as bool,
      hasCompletedBlurhashImageMigration:
          fields[23] == null ? true : fields[23] as bool,
      hasCompletedBlurhashImageMigrationIdFix:
          fields[24] == null ? true : fields[24] as bool,
      hasCompletedDownloadsServiceMigration:
          fields[34] == null ? true : fields[34] as bool,
      requireWifiForDownloads: fields[35] == null ? false : fields[35] as bool,
      onlyShowFullyDownloaded: fields[36] == null ? false : fields[36] as bool,
      showDownloadsWithUnknownLibrary:
          fields[37] == null ? true : fields[37] as bool,
      maxConcurrentDownloads: fields[38] == null ? 10 : fields[38] as int,
      downloadWorkers: fields[39] == null ? 5 : fields[39] as int,
      resyncOnStartup: fields[40] == null ? true : fields[40] as bool,
      preferQuickSyncs: fields[41] == null ? true : fields[41] as bool,
      hasCompletedIsarUserMigration:
          fields[42] == null ? true : fields[42] as bool,
      downloadTranscodeBitrate: fields[45] as int?,
      shouldTranscodeDownloads: fields[44] == null
          ? TranscodeDownloadsSetting.ask
          : fields[44] as TranscodeDownloadsSetting,
      shouldRedownloadTranscodes:
          fields[46] == null ? false : fields[46] as bool,
      swipeInsertQueueNext: fields[26] == null ? true : fields[26] as bool,
      useFixedSizeGridTiles: fields[59] == null ? false : fields[59] as bool,
      fixedGridTileSize: fields[60] == null ? 150 : fields[60] as int,
      allowSplitScreen: fields[61] == null ? true : fields[61] as bool,
      splitScreenPlayerWidth: fields[62] == null ? 400.0 : fields[62] as double,
      enableVibration: fields[47] == null ? true : fields[47] as bool,
      prioritizeCoverFactor: fields[49] == null ? 8.0 : fields[49] as double,
      suppressPlayerPadding: fields[50] == null ? false : fields[50] as bool,
      hidePlayerBottomActions: fields[51] == null ? false : fields[51] as bool,
      reportQueueToServer: fields[52] == null ? false : fields[52] as bool,
      periodicPlaybackSessionUpdateFrequencySeconds:
          fields[53] == null ? 150 : fields[53] as int,
      showArtistChipImage: fields[55] == null ? true : fields[55] as bool,
      trackOfflineFavorites: fields[63] == null ? true : fields[63] as bool,
      showProgressOnNowPlayingBar:
          fields[64] == null ? true : fields[64] as bool,
      startInstantMixForIndividualTracks:
          fields[65] == null ? true : fields[65] as bool,
      showLyricsTimestamps: fields[66] == null ? true : fields[66] as bool,
      lyricsAlignment: fields[67] == null
          ? LyricsAlignment.start
          : fields[67] as LyricsAlignment,
      lyricsFontSize: fields[70] == null
          ? LyricsFontSize.medium
          : fields[70] as LyricsFontSize,
      showLyricsScreenAlbumPrelude:
          fields[71] == null ? true : fields[71] as bool,
      showStopButtonOnMediaNotification:
          fields[68] == null ? false : fields[68] as bool,
      showSeekControlsOnMediaNotification:
          fields[69] == null ? true : fields[69] as bool,
      keepScreenOnOption: fields[72] == null
          ? KeepScreenOnOption.whileLyrics
          : fields[72] as KeepScreenOnOption,
      keepScreenOnWhilePluggedIn:
          fields[73] == null ? true : fields[73] as bool,
      featureChipsConfiguration: fields[76] == null
          ? DefaultSettings.featureChipsConfiguration
          : fields[76] as FinampFeatureChipsConfiguration,
      showCoversOnAlbumScreen: fields[77] == null ? false : fields[77] as bool,
      hasDownloadedPlaylistInfo:
          fields[74] == null ? false : fields[74] as bool,
      transcodingSegmentContainer: fields[75] == null
          ? FinampSegmentContainer.fragmentedMp4
          : fields[75] as FinampSegmentContainer,
    )
      ..disableGesture = fields[19] == null ? false : fields[19] as bool
      ..showFastScroller = fields[25] == null ? true : fields[25] as bool
      ..defaultDownloadLocation = fields[58] as String?;
  }

  @override
  void write(BinaryWriter writer, FinampSettings obj) {
    writer
      ..writeByte(74)
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
      ..write(obj.onlyShowFavourites)
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
      ..write(obj.useCoverAsBackground)
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
      ..write(obj.swipeInsertQueueNext)
      ..writeByte(27)
      ..write(obj.loopMode)
      ..writeByte(28)
      ..write(obj.autoloadLastQueueOnStartup)
      ..writeByte(29)
      ..write(obj.volumeNormalizationActive)
      ..writeByte(30)
      ..write(obj.volumeNormalizationIOSBaseGain)
      ..writeByte(33)
      ..write(obj.volumeNormalizationMode)
      ..writeByte(34)
      ..write(obj.hasCompletedDownloadsServiceMigration)
      ..writeByte(35)
      ..write(obj.requireWifiForDownloads)
      ..writeByte(36)
      ..write(obj.onlyShowFullyDownloaded)
      ..writeByte(37)
      ..write(obj.showDownloadsWithUnknownLibrary)
      ..writeByte(38)
      ..write(obj.maxConcurrentDownloads)
      ..writeByte(39)
      ..write(obj.downloadWorkers)
      ..writeByte(40)
      ..write(obj.resyncOnStartup)
      ..writeByte(41)
      ..write(obj.preferQuickSyncs)
      ..writeByte(42)
      ..write(obj.hasCompletedIsarUserMigration)
      ..writeByte(44)
      ..write(obj.shouldTranscodeDownloads)
      ..writeByte(45)
      ..write(obj.downloadTranscodeBitrate)
      ..writeByte(46)
      ..write(obj.shouldRedownloadTranscodes)
      ..writeByte(47)
      ..write(obj.enableVibration)
      ..writeByte(48)
      ..write(obj.playerScreenCoverMinimumPadding)
      ..writeByte(49)
      ..write(obj.prioritizeCoverFactor)
      ..writeByte(50)
      ..write(obj.suppressPlayerPadding)
      ..writeByte(51)
      ..write(obj.hidePlayerBottomActions)
      ..writeByte(52)
      ..write(obj.reportQueueToServer)
      ..writeByte(53)
      ..write(obj.periodicPlaybackSessionUpdateFrequencySeconds)
      ..writeByte(54)
      ..write(obj.showArtistsTopSongs)
      ..writeByte(55)
      ..write(obj.showArtistChipImage)
      ..writeByte(56)
      ..write(obj.playbackSpeed)
      ..writeByte(57)
      ..write(obj.playbackSpeedVisibility)
      ..writeByte(58)
      ..write(obj.defaultDownloadLocation)
      ..writeByte(59)
      ..write(obj.useFixedSizeGridTiles)
      ..writeByte(60)
      ..write(obj.fixedGridTileSize)
      ..writeByte(61)
      ..write(obj.allowSplitScreen)
      ..writeByte(62)
      ..write(obj.splitScreenPlayerWidth)
      ..writeByte(63)
      ..write(obj.trackOfflineFavorites)
      ..writeByte(64)
      ..write(obj.showProgressOnNowPlayingBar)
      ..writeByte(65)
      ..write(obj.startInstantMixForIndividualTracks)
      ..writeByte(66)
      ..write(obj.showLyricsTimestamps)
      ..writeByte(67)
      ..write(obj.lyricsAlignment)
      ..writeByte(68)
      ..write(obj.showStopButtonOnMediaNotification)
      ..writeByte(69)
      ..write(obj.showSeekControlsOnMediaNotification)
      ..writeByte(70)
      ..write(obj.lyricsFontSize)
      ..writeByte(71)
      ..write(obj.showLyricsScreenAlbumPrelude)
      ..writeByte(72)
      ..write(obj.keepScreenOnOption)
      ..writeByte(73)
      ..write(obj.keepScreenOnWhilePluggedIn)
      ..writeByte(74)
      ..write(obj.hasDownloadedPlaylistInfo)
      ..writeByte(75)
      ..write(obj.transcodingSegmentContainer)
      ..writeByte(76)
      ..write(obj.featureChipsConfiguration)
      ..writeByte(77)
      ..write(obj.showCoversOnAlbumScreen);
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
      relativePath: fields[1] as String?,
      id: fields[4] == null ? '0' : fields[4] as String,
      legacyUseHumanReadableNames: fields[2] as bool?,
      legacyDeletable: fields[3] as bool?,
      baseDirectory: fields[5] == null
          ? DownloadLocationType.migrated
          : fields[5] as DownloadLocationType,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadLocation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.relativePath)
      ..writeByte(2)
      ..write(obj.legacyUseHumanReadableNames)
      ..writeByte(3)
      ..write(obj.legacyDeletable)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.baseDirectory);
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
      deviceInfo: fields[7] as DeviceInfo?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineListen obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.trackMbid)
      ..writeByte(7)
      ..write(obj.deviceInfo);
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
      contextNormalizationGain: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, QueueItemSource obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.item)
      ..writeByte(4)
      ..write(obj.contextNormalizationGain);
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
    )..id = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, FinampQueueOrder obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.items)
      ..writeByte(1)
      ..write(obj.originalSource)
      ..writeByte(2)
      ..write(obj.linearOrder)
      ..writeByte(3)
      ..write(obj.shuffledOrder)
      ..writeByte(4)
      ..write(obj.id);
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
      id: fields[6] as String,
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
      ..writeByte(7)
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
      ..write(obj.saveState)
      ..writeByte(6)
      ..write(obj.id);
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

class MediaItemIdAdapter extends TypeAdapter<MediaItemId> {
  @override
  final int typeId = 69;

  @override
  MediaItemId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaItemId(
      contentType: fields[0] as TabContentType,
      parentType: fields[1] as MediaItemParentType,
      itemId: fields[2] as String?,
      parentId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MediaItemId obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.contentType)
      ..writeByte(1)
      ..write(obj.parentType)
      ..writeByte(2)
      ..write(obj.itemId)
      ..writeByte(3)
      ..write(obj.parentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItemIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampFeatureChipsConfigurationAdapter
    extends TypeAdapter<FinampFeatureChipsConfiguration> {
  @override
  final int typeId = 75;

  @override
  FinampFeatureChipsConfiguration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampFeatureChipsConfiguration(
      enabled: fields[0] as bool,
      features: (fields[1] as List).cast<FinampFeatureChipType>(),
    );
  }

  @override
  void write(BinaryWriter writer, FinampFeatureChipsConfiguration obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.enabled)
      ..writeByte(1)
      ..write(obj.features);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampFeatureChipsConfigurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceInfoAdapter extends TypeAdapter<DeviceInfo> {
  @override
  final int typeId = 76;

  @override
  DeviceInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceInfo(
      name: fields[0] as String,
      id: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceInfoAdapter &&
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
        return QueueItemSourceType.queue;
      case 17:
        return QueueItemSourceType.unknown;
      case 18:
        return QueueItemSourceType.genreMix;
      case 19:
        return QueueItemSourceType.song;
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
      case QueueItemSourceType.queue:
        writer.writeByte(16);
        break;
      case QueueItemSourceType.unknown:
        writer.writeByte(17);
        break;
      case QueueItemSourceType.genreMix:
        writer.writeByte(18);
        break;
      case QueueItemSourceType.song:
        writer.writeByte(19);
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
      case 8:
        return QueueItemSourceNameType.queue;
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
      case QueueItemSourceNameType.queue:
        writer.writeByte(8);
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

class VolumeNormalizationModeAdapter
    extends TypeAdapter<VolumeNormalizationMode> {
  @override
  final int typeId = 63;

  @override
  VolumeNormalizationMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VolumeNormalizationMode.hybrid;
      case 1:
        return VolumeNormalizationMode.trackBased;
      case 2:
        return VolumeNormalizationMode.albumOnly;
      default:
        return VolumeNormalizationMode.hybrid;
    }
  }

  @override
  void write(BinaryWriter writer, VolumeNormalizationMode obj) {
    switch (obj) {
      case VolumeNormalizationMode.hybrid:
        writer.writeByte(0);
        break;
      case VolumeNormalizationMode.trackBased:
        writer.writeByte(1);
        break;
      case VolumeNormalizationMode.albumOnly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolumeNormalizationModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadLocationTypeAdapter extends TypeAdapter<DownloadLocationType> {
  @override
  final int typeId = 64;

  @override
  DownloadLocationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DownloadLocationType.internalDocuments;
      case 1:
        return DownloadLocationType.internalSupport;
      case 2:
        return DownloadLocationType.external;
      case 3:
        return DownloadLocationType.custom;
      case 4:
        return DownloadLocationType.none;
      case 5:
        return DownloadLocationType.migrated;
      case 6:
        return DownloadLocationType.cache;
      default:
        return DownloadLocationType.internalDocuments;
    }
  }

  @override
  void write(BinaryWriter writer, DownloadLocationType obj) {
    switch (obj) {
      case DownloadLocationType.internalDocuments:
        writer.writeByte(0);
        break;
      case DownloadLocationType.internalSupport:
        writer.writeByte(1);
        break;
      case DownloadLocationType.external:
        writer.writeByte(2);
        break;
      case DownloadLocationType.custom:
        writer.writeByte(3);
        break;
      case DownloadLocationType.none:
        writer.writeByte(4);
        break;
      case DownloadLocationType.migrated:
        writer.writeByte(5);
        break;
      case DownloadLocationType.cache:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadLocationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampTranscodingCodecAdapter
    extends TypeAdapter<FinampTranscodingCodec> {
  @override
  final int typeId = 65;

  @override
  FinampTranscodingCodec read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FinampTranscodingCodec.aac;
      case 1:
        return FinampTranscodingCodec.mp3;
      case 2:
        return FinampTranscodingCodec.opus;
      case 3:
        return FinampTranscodingCodec.original;
      default:
        return FinampTranscodingCodec.aac;
    }
  }

  @override
  void write(BinaryWriter writer, FinampTranscodingCodec obj) {
    switch (obj) {
      case FinampTranscodingCodec.aac:
        writer.writeByte(0);
        break;
      case FinampTranscodingCodec.mp3:
        writer.writeByte(1);
        break;
      case FinampTranscodingCodec.opus:
        writer.writeByte(2);
        break;
      case FinampTranscodingCodec.original:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampTranscodingCodecAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranscodeDownloadsSettingAdapter
    extends TypeAdapter<TranscodeDownloadsSetting> {
  @override
  final int typeId = 66;

  @override
  TranscodeDownloadsSetting read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TranscodeDownloadsSetting.always;
      case 1:
        return TranscodeDownloadsSetting.never;
      case 2:
        return TranscodeDownloadsSetting.ask;
      default:
        return TranscodeDownloadsSetting.always;
    }
  }

  @override
  void write(BinaryWriter writer, TranscodeDownloadsSetting obj) {
    switch (obj) {
      case TranscodeDownloadsSetting.always:
        writer.writeByte(0);
        break;
      case TranscodeDownloadsSetting.never:
        writer.writeByte(1);
        break;
      case TranscodeDownloadsSetting.ask:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranscodeDownloadsSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaybackSpeedVisibilityAdapter
    extends TypeAdapter<PlaybackSpeedVisibility> {
  @override
  final int typeId = 67;

  @override
  PlaybackSpeedVisibility read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlaybackSpeedVisibility.automatic;
      case 1:
        return PlaybackSpeedVisibility.visible;
      case 2:
        return PlaybackSpeedVisibility.hidden;
      default:
        return PlaybackSpeedVisibility.automatic;
    }
  }

  @override
  void write(BinaryWriter writer, PlaybackSpeedVisibility obj) {
    switch (obj) {
      case PlaybackSpeedVisibility.automatic:
        writer.writeByte(0);
        break;
      case PlaybackSpeedVisibility.visible:
        writer.writeByte(1);
        break;
      case PlaybackSpeedVisibility.hidden:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaybackSpeedVisibilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaItemParentTypeAdapter extends TypeAdapter<MediaItemParentType> {
  @override
  final int typeId = 68;

  @override
  MediaItemParentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MediaItemParentType.collection;
      case 1:
        return MediaItemParentType.rootCollection;
      case 2:
        return MediaItemParentType.instantMix;
      default:
        return MediaItemParentType.collection;
    }
  }

  @override
  void write(BinaryWriter writer, MediaItemParentType obj) {
    switch (obj) {
      case MediaItemParentType.collection:
        writer.writeByte(0);
        break;
      case MediaItemParentType.rootCollection:
        writer.writeByte(1);
        break;
      case MediaItemParentType.instantMix:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItemParentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LyricsAlignmentAdapter extends TypeAdapter<LyricsAlignment> {
  @override
  final int typeId = 70;

  @override
  LyricsAlignment read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LyricsAlignment.start;
      case 1:
        return LyricsAlignment.center;
      case 2:
        return LyricsAlignment.end;
      default:
        return LyricsAlignment.start;
    }
  }

  @override
  void write(BinaryWriter writer, LyricsAlignment obj) {
    switch (obj) {
      case LyricsAlignment.start:
        writer.writeByte(0);
        break;
      case LyricsAlignment.center:
        writer.writeByte(1);
        break;
      case LyricsAlignment.end:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricsAlignmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LyricsFontSizeAdapter extends TypeAdapter<LyricsFontSize> {
  @override
  final int typeId = 71;

  @override
  LyricsFontSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LyricsFontSize.small;
      case 1:
        return LyricsFontSize.medium;
      case 2:
        return LyricsFontSize.large;
      default:
        return LyricsFontSize.small;
    }
  }

  @override
  void write(BinaryWriter writer, LyricsFontSize obj) {
    switch (obj) {
      case LyricsFontSize.small:
        writer.writeByte(0);
        break;
      case LyricsFontSize.medium:
        writer.writeByte(1);
        break;
      case LyricsFontSize.large:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricsFontSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KeepScreenOnOptionAdapter extends TypeAdapter<KeepScreenOnOption> {
  @override
  final int typeId = 72;

  @override
  KeepScreenOnOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return KeepScreenOnOption.disabled;
      case 1:
        return KeepScreenOnOption.alwaysOn;
      case 2:
        return KeepScreenOnOption.whilePlaying;
      case 3:
        return KeepScreenOnOption.whileLyrics;
      default:
        return KeepScreenOnOption.disabled;
    }
  }

  @override
  void write(BinaryWriter writer, KeepScreenOnOption obj) {
    switch (obj) {
      case KeepScreenOnOption.disabled:
        writer.writeByte(0);
        break;
      case KeepScreenOnOption.alwaysOn:
        writer.writeByte(1);
        break;
      case KeepScreenOnOption.whilePlaying:
        writer.writeByte(2);
        break;
      case KeepScreenOnOption.whileLyrics:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeepScreenOnOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampSegmentContainerAdapter
    extends TypeAdapter<FinampSegmentContainer> {
  @override
  final int typeId = 73;

  @override
  FinampSegmentContainer read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FinampSegmentContainer.mpegTS;
      case 1:
        return FinampSegmentContainer.fragmentedMp4;
      default:
        return FinampSegmentContainer.mpegTS;
    }
  }

  @override
  void write(BinaryWriter writer, FinampSegmentContainer obj) {
    switch (obj) {
      case FinampSegmentContainer.mpegTS:
        writer.writeByte(0);
        break;
      case FinampSegmentContainer.fragmentedMp4:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampSegmentContainerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampFeatureChipTypeAdapter extends TypeAdapter<FinampFeatureChipType> {
  @override
  final int typeId = 74;

  @override
  FinampFeatureChipType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FinampFeatureChipType.playCount;
      case 1:
        return FinampFeatureChipType.additionalPeople;
      case 2:
        return FinampFeatureChipType.playbackMode;
      case 3:
        return FinampFeatureChipType.codec;
      case 4:
        return FinampFeatureChipType.bitRate;
      case 5:
        return FinampFeatureChipType.bitDepth;
      case 6:
        return FinampFeatureChipType.size;
      case 7:
        return FinampFeatureChipType.normalizationGain;
      case 8:
        return FinampFeatureChipType.sampleRate;
      default:
        return FinampFeatureChipType.playCount;
    }
  }

  @override
  void write(BinaryWriter writer, FinampFeatureChipType obj) {
    switch (obj) {
      case FinampFeatureChipType.playCount:
        writer.writeByte(0);
        break;
      case FinampFeatureChipType.additionalPeople:
        writer.writeByte(1);
        break;
      case FinampFeatureChipType.playbackMode:
        writer.writeByte(2);
        break;
      case FinampFeatureChipType.codec:
        writer.writeByte(3);
        break;
      case FinampFeatureChipType.bitRate:
        writer.writeByte(4);
        break;
      case FinampFeatureChipType.bitDepth:
        writer.writeByte(5);
        break;
      case FinampFeatureChipType.size:
        writer.writeByte(6);
        break;
      case FinampFeatureChipType.normalizationGain:
        writer.writeByte(7);
        break;
      case FinampFeatureChipType.sampleRate:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampFeatureChipTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFinampUserCollection on Isar {
  IsarCollection<FinampUser> get finampUsers => this.collection();
}

const FinampUserSchema = CollectionSchema(
  name: r'FinampUser',
  id: -4140083613547586279,
  properties: {
    r'accessToken': PropertySchema(
      id: 0,
      name: r'accessToken',
      type: IsarType.string,
    ),
    r'baseUrl': PropertySchema(
      id: 1,
      name: r'baseUrl',
      type: IsarType.string,
    ),
    r'currentViewId': PropertySchema(
      id: 2,
      name: r'currentViewId',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'isarViews': PropertySchema(
      id: 4,
      name: r'isarViews',
      type: IsarType.string,
    ),
    r'serverId': PropertySchema(
      id: 5,
      name: r'serverId',
      type: IsarType.string,
    )
  },
  estimateSize: _finampUserEstimateSize,
  serialize: _finampUserSerialize,
  deserialize: _finampUserDeserialize,
  deserializeProp: _finampUserDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _finampUserGetId,
  getLinks: _finampUserGetLinks,
  attach: _finampUserAttach,
  version: '3.1.0+1',
);

int _finampUserEstimateSize(
  FinampUser object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accessToken.length * 3;
  bytesCount += 3 + object.baseUrl.length * 3;
  {
    final value = object.currentViewId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.isarViews.length * 3;
  bytesCount += 3 + object.serverId.length * 3;
  return bytesCount;
}

void _finampUserSerialize(
  FinampUser object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accessToken);
  writer.writeString(offsets[1], object.baseUrl);
  writer.writeString(offsets[2], object.currentViewId);
  writer.writeString(offsets[3], object.id);
  writer.writeString(offsets[4], object.isarViews);
  writer.writeString(offsets[5], object.serverId);
}

FinampUser _finampUserDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FinampUser(
    accessToken: reader.readString(offsets[0]),
    baseUrl: reader.readString(offsets[1]),
    currentViewId: reader.readStringOrNull(offsets[2]),
    id: reader.readString(offsets[3]),
    serverId: reader.readString(offsets[5]),
  );
  object.isarViews = reader.readString(offsets[4]);
  return object;
}

P _finampUserDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _finampUserGetId(FinampUser object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _finampUserGetLinks(FinampUser object) {
  return [];
}

void _finampUserAttach(IsarCollection<dynamic> col, Id id, FinampUser object) {}

extension FinampUserQueryWhereSort
    on QueryBuilder<FinampUser, FinampUser, QWhere> {
  QueryBuilder<FinampUser, FinampUser, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FinampUserQueryWhere
    on QueryBuilder<FinampUser, FinampUser, QWhereClause> {
  QueryBuilder<FinampUser, FinampUser, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FinampUserQueryFilter
    on QueryBuilder<FinampUser, FinampUser, QFilterCondition> {
  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accessToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accessToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessToken',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      accessTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accessToken',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> baseUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      baseUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> baseUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> baseUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> baseUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> baseUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> baseUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> baseUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'baseUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> baseUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      baseUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'baseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentViewId',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentViewId',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentViewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentViewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentViewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentViewId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentViewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentViewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentViewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentViewId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentViewId',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      currentViewIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentViewId',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarViewsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarViews',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      isarViewsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarViews',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarViewsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarViews',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarViewsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarViews',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      isarViewsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isarViews',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarViewsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isarViews',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarViewsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isarViews',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> isarViewsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isarViews',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      isarViewsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarViews',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      isarViewsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isarViews',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> serverIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      serverIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> serverIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> serverIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      serverIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> serverIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> serverIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition> serverIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }
}

extension FinampUserQueryObject
    on QueryBuilder<FinampUser, FinampUser, QFilterCondition> {}

extension FinampUserQueryLinks
    on QueryBuilder<FinampUser, FinampUser, QFilterCondition> {}

extension FinampUserQuerySortBy
    on QueryBuilder<FinampUser, FinampUser, QSortBy> {
  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByAccessToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessToken', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByAccessTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessToken', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByBaseUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByBaseUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByCurrentViewId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentViewId', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByCurrentViewIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentViewId', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByIsarViews() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarViews', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByIsarViewsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarViews', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension FinampUserQuerySortThenBy
    on QueryBuilder<FinampUser, FinampUser, QSortThenBy> {
  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByAccessToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessToken', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByAccessTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessToken', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByBaseUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByBaseUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByCurrentViewId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentViewId', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByCurrentViewIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentViewId', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByIsarViews() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarViews', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByIsarViewsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarViews', Sort.desc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QAfterSortBy> thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension FinampUserQueryWhereDistinct
    on QueryBuilder<FinampUser, FinampUser, QDistinct> {
  QueryBuilder<FinampUser, FinampUser, QDistinct> distinctByAccessToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QDistinct> distinctByBaseUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QDistinct> distinctByCurrentViewId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentViewId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QDistinct> distinctByIsarViews(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isarViews', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinampUser, FinampUser, QDistinct> distinctByServerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }
}

extension FinampUserQueryProperty
    on QueryBuilder<FinampUser, FinampUser, QQueryProperty> {
  QueryBuilder<FinampUser, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<FinampUser, String, QQueryOperations> accessTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessToken');
    });
  }

  QueryBuilder<FinampUser, String, QQueryOperations> baseUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseUrl');
    });
  }

  QueryBuilder<FinampUser, String?, QQueryOperations> currentViewIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentViewId');
    });
  }

  QueryBuilder<FinampUser, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FinampUser, String, QQueryOperations> isarViewsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarViews');
    });
  }

  QueryBuilder<FinampUser, String, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadItemCollection on Isar {
  IsarCollection<DownloadItem> get downloadItems => this.collection();
}

const DownloadItemSchema = CollectionSchema(
  name: r'DownloadItem',
  id: 3470061580579511306,
  properties: {
    r'baseIndexNumber': PropertySchema(
      id: 0,
      name: r'baseIndexNumber',
      type: IsarType.long,
    ),
    r'baseItemType': PropertySchema(
      id: 1,
      name: r'baseItemType',
      type: IsarType.byte,
      enumMap: _DownloadItembaseItemTypeEnumValueMap,
    ),
    r'fileTranscodingProfile': PropertySchema(
      id: 2,
      name: r'fileTranscodingProfile',
      type: IsarType.object,
      target: r'DownloadProfile',
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'jsonItem': PropertySchema(
      id: 4,
      name: r'jsonItem',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'orderedChildren': PropertySchema(
      id: 6,
      name: r'orderedChildren',
      type: IsarType.longList,
    ),
    r'parentIndexNumber': PropertySchema(
      id: 7,
      name: r'parentIndexNumber',
      type: IsarType.long,
    ),
    r'path': PropertySchema(
      id: 8,
      name: r'path',
      type: IsarType.string,
    ),
    r'state': PropertySchema(
      id: 9,
      name: r'state',
      type: IsarType.byte,
      enumMap: _DownloadItemstateEnumValueMap,
    ),
    r'syncTranscodingProfile': PropertySchema(
      id: 10,
      name: r'syncTranscodingProfile',
      type: IsarType.object,
      target: r'DownloadProfile',
    ),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.byte,
      enumMap: _DownloadItemtypeEnumValueMap,
    ),
    r'userTranscodingProfile': PropertySchema(
      id: 12,
      name: r'userTranscodingProfile',
      type: IsarType.object,
      target: r'DownloadProfile',
    ),
    r'viewId': PropertySchema(
      id: 13,
      name: r'viewId',
      type: IsarType.string,
    )
  },
  estimateSize: _downloadItemEstimateSize,
  serialize: _downloadItemSerialize,
  deserialize: _downloadItemDeserialize,
  deserializeProp: _downloadItemDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'state': IndexSchema(
      id: 7917036384617311412,
      name: r'state',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'state',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'type': IndexSchema(
      id: 5117122708147080838,
      name: r'type',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'type',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'requires': LinkSchema(
      id: 2869659933205985607,
      name: r'requires',
      target: r'DownloadItem',
      single: false,
    ),
    r'requiredBy': LinkSchema(
      id: 8162545016065706399,
      name: r'requiredBy',
      target: r'DownloadItem',
      single: false,
      linkName: r'requires',
    ),
    r'info': LinkSchema(
      id: 577543621393535253,
      name: r'info',
      target: r'DownloadItem',
      single: false,
    ),
    r'infoFor': LinkSchema(
      id: -2484078441196254859,
      name: r'infoFor',
      target: r'DownloadItem',
      single: false,
      linkName: r'info',
    )
  },
  embeddedSchemas: {r'DownloadProfile': DownloadProfileSchema},
  getId: _downloadItemGetId,
  getLinks: _downloadItemGetLinks,
  attach: _downloadItemAttach,
  version: '3.1.0+1',
);

int _downloadItemEstimateSize(
  DownloadItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.fileTranscodingProfile;
    if (value != null) {
      bytesCount += 3 +
          DownloadProfileSchema.estimateSize(
              value, allOffsets[DownloadProfile]!, allOffsets);
    }
  }
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.jsonItem;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.orderedChildren;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.path;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.syncTranscodingProfile;
    if (value != null) {
      bytesCount += 3 +
          DownloadProfileSchema.estimateSize(
              value, allOffsets[DownloadProfile]!, allOffsets);
    }
  }
  {
    final value = object.userTranscodingProfile;
    if (value != null) {
      bytesCount += 3 +
          DownloadProfileSchema.estimateSize(
              value, allOffsets[DownloadProfile]!, allOffsets);
    }
  }
  {
    final value = object.viewId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _downloadItemSerialize(
  DownloadItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.baseIndexNumber);
  writer.writeByte(offsets[1], object.baseItemType.index);
  writer.writeObject<DownloadProfile>(
    offsets[2],
    allOffsets,
    DownloadProfileSchema.serialize,
    object.fileTranscodingProfile,
  );
  writer.writeString(offsets[3], object.id);
  writer.writeString(offsets[4], object.jsonItem);
  writer.writeString(offsets[5], object.name);
  writer.writeLongList(offsets[6], object.orderedChildren);
  writer.writeLong(offsets[7], object.parentIndexNumber);
  writer.writeString(offsets[8], object.path);
  writer.writeByte(offsets[9], object.state.index);
  writer.writeObject<DownloadProfile>(
    offsets[10],
    allOffsets,
    DownloadProfileSchema.serialize,
    object.syncTranscodingProfile,
  );
  writer.writeByte(offsets[11], object.type.index);
  writer.writeObject<DownloadProfile>(
    offsets[12],
    allOffsets,
    DownloadProfileSchema.serialize,
    object.userTranscodingProfile,
  );
  writer.writeString(offsets[13], object.viewId);
}

DownloadItem _downloadItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadItem(
    baseIndexNumber: reader.readLongOrNull(offsets[0]),
    baseItemType: _DownloadItembaseItemTypeValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        BaseItemDtoType.noItem,
    fileTranscodingProfile: reader.readObjectOrNull<DownloadProfile>(
      offsets[2],
      DownloadProfileSchema.deserialize,
      allOffsets,
    ),
    id: reader.readString(offsets[3]),
    isarId: id,
    jsonItem: reader.readStringOrNull(offsets[4]),
    name: reader.readString(offsets[5]),
    orderedChildren: reader.readLongList(offsets[6]),
    parentIndexNumber: reader.readLongOrNull(offsets[7]),
    path: reader.readStringOrNull(offsets[8]),
    state: _DownloadItemstateValueEnumMap[reader.readByteOrNull(offsets[9])] ??
        DownloadItemState.notDownloaded,
    syncTranscodingProfile: reader.readObjectOrNull<DownloadProfile>(
      offsets[10],
      DownloadProfileSchema.deserialize,
      allOffsets,
    ),
    type: _DownloadItemtypeValueEnumMap[reader.readByteOrNull(offsets[11])] ??
        DownloadItemType.collection,
    userTranscodingProfile: reader.readObjectOrNull<DownloadProfile>(
      offsets[12],
      DownloadProfileSchema.deserialize,
      allOffsets,
    ),
    viewId: reader.readStringOrNull(offsets[13]),
  );
  return object;
}

P _downloadItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (_DownloadItembaseItemTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          BaseItemDtoType.noItem) as P;
    case 2:
      return (reader.readObjectOrNull<DownloadProfile>(
        offset,
        DownloadProfileSchema.deserialize,
        allOffsets,
      )) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongList(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (_DownloadItemstateValueEnumMap[reader.readByteOrNull(offset)] ??
          DownloadItemState.notDownloaded) as P;
    case 10:
      return (reader.readObjectOrNull<DownloadProfile>(
        offset,
        DownloadProfileSchema.deserialize,
        allOffsets,
      )) as P;
    case 11:
      return (_DownloadItemtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          DownloadItemType.collection) as P;
    case 12:
      return (reader.readObjectOrNull<DownloadProfile>(
        offset,
        DownloadProfileSchema.deserialize,
        allOffsets,
      )) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DownloadItembaseItemTypeEnumValueMap = {
  'noItem': 0,
  'album': 1,
  'artist': 2,
  'playlist': 3,
  'genre': 4,
  'song': 5,
  'library': 6,
  'folder': 7,
  'musicVideo': 8,
  'audioBook': 9,
  'tvEpisode': 10,
  'video': 11,
  'movie': 12,
  'trailer': 13,
  'unknown': 14,
};
const _DownloadItembaseItemTypeValueEnumMap = {
  0: BaseItemDtoType.noItem,
  1: BaseItemDtoType.album,
  2: BaseItemDtoType.artist,
  3: BaseItemDtoType.playlist,
  4: BaseItemDtoType.genre,
  5: BaseItemDtoType.song,
  6: BaseItemDtoType.library,
  7: BaseItemDtoType.folder,
  8: BaseItemDtoType.musicVideo,
  9: BaseItemDtoType.audioBook,
  10: BaseItemDtoType.tvEpisode,
  11: BaseItemDtoType.video,
  12: BaseItemDtoType.movie,
  13: BaseItemDtoType.trailer,
  14: BaseItemDtoType.unknown,
};
const _DownloadItemstateEnumValueMap = {
  'notDownloaded': 0,
  'downloading': 1,
  'failed': 2,
  'complete': 3,
  'enqueued': 4,
  'syncFailed': 5,
  'needsRedownload': 6,
  'needsRedownloadComplete': 7,
};
const _DownloadItemstateValueEnumMap = {
  0: DownloadItemState.notDownloaded,
  1: DownloadItemState.downloading,
  2: DownloadItemState.failed,
  3: DownloadItemState.complete,
  4: DownloadItemState.enqueued,
  5: DownloadItemState.syncFailed,
  6: DownloadItemState.needsRedownload,
  7: DownloadItemState.needsRedownloadComplete,
};
const _DownloadItemtypeEnumValueMap = {
  'collection': 0,
  'song': 1,
  'image': 2,
  'anchor': 3,
  'finampCollection': 4,
};
const _DownloadItemtypeValueEnumMap = {
  0: DownloadItemType.collection,
  1: DownloadItemType.song,
  2: DownloadItemType.image,
  3: DownloadItemType.anchor,
  4: DownloadItemType.finampCollection,
};

Id _downloadItemGetId(DownloadItem object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _downloadItemGetLinks(DownloadItem object) {
  return [object.requires, object.requiredBy, object.info, object.infoFor];
}

void _downloadItemAttach(
    IsarCollection<dynamic> col, Id id, DownloadItem object) {
  object.requires
      .attach(col, col.isar.collection<DownloadItem>(), r'requires', id);
  object.requiredBy
      .attach(col, col.isar.collection<DownloadItem>(), r'requiredBy', id);
  object.info.attach(col, col.isar.collection<DownloadItem>(), r'info', id);
  object.infoFor
      .attach(col, col.isar.collection<DownloadItem>(), r'infoFor', id);
}

extension DownloadItemQueryWhereSort
    on QueryBuilder<DownloadItem, DownloadItem, QWhere> {
  QueryBuilder<DownloadItem, DownloadItem, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhere> anyState() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'state'),
      );
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhere> anyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'type'),
      );
    });
  }
}

extension DownloadItemQueryWhere
    on QueryBuilder<DownloadItem, DownloadItem, QWhereClause> {
  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> stateEqualTo(
      DownloadItemState state) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'state',
        value: [state],
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> stateNotEqualTo(
      DownloadItemState state) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [],
              upper: [state],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [state],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [state],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [],
              upper: [state],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> stateGreaterThan(
    DownloadItemState state, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'state',
        lower: [state],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> stateLessThan(
    DownloadItemState state, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'state',
        lower: [],
        upper: [state],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> stateBetween(
    DownloadItemState lowerState,
    DownloadItemState upperState, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'state',
        lower: [lowerState],
        includeLower: includeLower,
        upper: [upperState],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> typeEqualTo(
      DownloadItemType type) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'type',
        value: [type],
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> typeNotEqualTo(
      DownloadItemType type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [],
              upper: [type],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [type],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [type],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [],
              upper: [type],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> typeGreaterThan(
    DownloadItemType type, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [type],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> typeLessThan(
    DownloadItemType type, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [],
        upper: [type],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterWhereClause> typeBetween(
    DownloadItemType lowerType,
    DownloadItemType upperType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [lowerType],
        includeLower: includeLower,
        upper: [upperType],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DownloadItemQueryFilter
    on QueryBuilder<DownloadItem, DownloadItem, QFilterCondition> {
  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseIndexNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'baseIndexNumber',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseIndexNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'baseIndexNumber',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseIndexNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseIndexNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseIndexNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseIndexNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseIndexNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseIndexNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseIndexNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseIndexNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseItemTypeEqualTo(BaseItemDtoType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseItemType',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseItemTypeGreaterThan(
    BaseItemDtoType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseItemType',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseItemTypeLessThan(
    BaseItemDtoType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseItemType',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      baseItemTypeBetween(
    BaseItemDtoType lower,
    BaseItemDtoType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseItemType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      fileTranscodingProfileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fileTranscodingProfile',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      fileTranscodingProfileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fileTranscodingProfile',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jsonItem',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jsonItem',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jsonItem',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jsonItem',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonItem',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      jsonItemIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jsonItem',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orderedChildren',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orderedChildren',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderedChildren',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderedChildren',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderedChildren',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderedChildren',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'orderedChildren',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'orderedChildren',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'orderedChildren',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'orderedChildren',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'orderedChildren',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      orderedChildrenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'orderedChildren',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      parentIndexNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentIndexNumber',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      parentIndexNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentIndexNumber',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      parentIndexNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentIndexNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      parentIndexNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentIndexNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      parentIndexNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentIndexNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      parentIndexNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentIndexNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> pathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      pathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> pathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      pathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> pathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> pathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> pathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> pathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> stateEqualTo(
      DownloadItemState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      stateGreaterThan(
    DownloadItemState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> stateLessThan(
    DownloadItemState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> stateBetween(
    DownloadItemState lower,
    DownloadItemState upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      syncTranscodingProfileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'syncTranscodingProfile',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      syncTranscodingProfileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'syncTranscodingProfile',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> typeEqualTo(
      DownloadItemType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      typeGreaterThan(
    DownloadItemType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> typeLessThan(
    DownloadItemType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> typeBetween(
    DownloadItemType lower,
    DownloadItemType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      userTranscodingProfileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userTranscodingProfile',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      userTranscodingProfileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userTranscodingProfile',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      viewIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'viewId',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      viewIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'viewId',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> viewIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'viewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      viewIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'viewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      viewIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'viewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> viewIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'viewId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      viewIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'viewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      viewIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'viewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      viewIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'viewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> viewIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'viewId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      viewIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'viewId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      viewIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'viewId',
        value: '',
      ));
    });
  }
}

extension DownloadItemQueryObject
    on QueryBuilder<DownloadItem, DownloadItem, QFilterCondition> {
  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      fileTranscodingProfile(FilterQuery<DownloadProfile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'fileTranscodingProfile');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      syncTranscodingProfile(FilterQuery<DownloadProfile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'syncTranscodingProfile');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      userTranscodingProfile(FilterQuery<DownloadProfile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'userTranscodingProfile');
    });
  }
}

extension DownloadItemQueryLinks
    on QueryBuilder<DownloadItem, DownloadItem, QFilterCondition> {
  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> requires(
      FilterQuery<DownloadItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'requires');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', length, true, length, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', 0, true, 0, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', 0, false, 999999, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', 0, true, length, include);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', length, include, 999999, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'requires', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> requiredBy(
      FilterQuery<DownloadItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'requiredBy');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiredByLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', length, true, length, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiredByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', 0, true, 0, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiredByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', 0, false, 999999, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiredByLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', 0, true, length, include);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiredByLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', length, include, 999999, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      requiredByLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'requiredBy', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> info(
      FilterQuery<DownloadItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'info');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'info', length, true, length, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'info', 0, true, 0, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'info', 0, false, 999999, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'info', 0, true, length, include);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'info', length, include, 999999, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'info', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> infoFor(
      FilterQuery<DownloadItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'infoFor');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoForLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infoFor', length, true, length, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoForIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infoFor', 0, true, 0, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoForIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infoFor', 0, false, 999999, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoForLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infoFor', 0, true, length, include);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoForLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infoFor', length, include, 999999, true);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition>
      infoForLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'infoFor', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DownloadItemQuerySortBy
    on QueryBuilder<DownloadItem, DownloadItem, QSortBy> {
  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      sortByBaseIndexNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseIndexNumber', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      sortByBaseIndexNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseIndexNumber', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByBaseItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseItemType', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      sortByBaseItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseItemType', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByJsonItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByJsonItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      sortByParentIndexNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentIndexNumber', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      sortByParentIndexNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentIndexNumber', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByViewId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viewId', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> sortByViewIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viewId', Sort.desc);
    });
  }
}

extension DownloadItemQuerySortThenBy
    on QueryBuilder<DownloadItem, DownloadItem, QSortThenBy> {
  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      thenByBaseIndexNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseIndexNumber', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      thenByBaseIndexNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseIndexNumber', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByBaseItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseItemType', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      thenByBaseItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseItemType', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByJsonItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByJsonItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      thenByParentIndexNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentIndexNumber', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy>
      thenByParentIndexNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentIndexNumber', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByViewId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viewId', Sort.asc);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QAfterSortBy> thenByViewIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viewId', Sort.desc);
    });
  }
}

extension DownloadItemQueryWhereDistinct
    on QueryBuilder<DownloadItem, DownloadItem, QDistinct> {
  QueryBuilder<DownloadItem, DownloadItem, QDistinct>
      distinctByBaseIndexNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseIndexNumber');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct> distinctByBaseItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseItemType');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct> distinctByJsonItem(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jsonItem', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct>
      distinctByOrderedChildren() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderedChildren');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct>
      distinctByParentIndexNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentIndexNumber');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct> distinctByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<DownloadItem, DownloadItem, QDistinct> distinctByViewId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'viewId', caseSensitive: caseSensitive);
    });
  }
}

extension DownloadItemQueryProperty
    on QueryBuilder<DownloadItem, DownloadItem, QQueryProperty> {
  QueryBuilder<DownloadItem, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<DownloadItem, int?, QQueryOperations> baseIndexNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseIndexNumber');
    });
  }

  QueryBuilder<DownloadItem, BaseItemDtoType, QQueryOperations>
      baseItemTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseItemType');
    });
  }

  QueryBuilder<DownloadItem, DownloadProfile?, QQueryOperations>
      fileTranscodingProfileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileTranscodingProfile');
    });
  }

  QueryBuilder<DownloadItem, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadItem, String?, QQueryOperations> jsonItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jsonItem');
    });
  }

  QueryBuilder<DownloadItem, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<DownloadItem, List<int>?, QQueryOperations>
      orderedChildrenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderedChildren');
    });
  }

  QueryBuilder<DownloadItem, int?, QQueryOperations>
      parentIndexNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentIndexNumber');
    });
  }

  QueryBuilder<DownloadItem, String?, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<DownloadItem, DownloadItemState, QQueryOperations>
      stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<DownloadItem, DownloadProfile?, QQueryOperations>
      syncTranscodingProfileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncTranscodingProfile');
    });
  }

  QueryBuilder<DownloadItem, DownloadItemType, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<DownloadItem, DownloadProfile?, QQueryOperations>
      userTranscodingProfileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userTranscodingProfile');
    });
  }

  QueryBuilder<DownloadItem, String?, QQueryOperations> viewIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'viewId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadedLyricsCollection on Isar {
  IsarCollection<DownloadedLyrics> get downloadedLyrics => this.collection();
}

const DownloadedLyricsSchema = CollectionSchema(
  name: r'DownloadedLyrics',
  id: 7780135185558523971,
  properties: {
    r'jsonItem': PropertySchema(
      id: 0,
      name: r'jsonItem',
      type: IsarType.string,
    )
  },
  estimateSize: _downloadedLyricsEstimateSize,
  serialize: _downloadedLyricsSerialize,
  deserialize: _downloadedLyricsDeserialize,
  deserializeProp: _downloadedLyricsDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _downloadedLyricsGetId,
  getLinks: _downloadedLyricsGetLinks,
  attach: _downloadedLyricsAttach,
  version: '3.1.0+1',
);

int _downloadedLyricsEstimateSize(
  DownloadedLyrics object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.jsonItem;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _downloadedLyricsSerialize(
  DownloadedLyrics object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.jsonItem);
}

DownloadedLyrics _downloadedLyricsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadedLyrics(
    isarId: id,
    jsonItem: reader.readStringOrNull(offsets[0]),
  );
  return object;
}

P _downloadedLyricsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _downloadedLyricsGetId(DownloadedLyrics object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _downloadedLyricsGetLinks(DownloadedLyrics object) {
  return [];
}

void _downloadedLyricsAttach(
    IsarCollection<dynamic> col, Id id, DownloadedLyrics object) {}

extension DownloadedLyricsQueryWhereSort
    on QueryBuilder<DownloadedLyrics, DownloadedLyrics, QWhere> {
  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadedLyricsQueryWhere
    on QueryBuilder<DownloadedLyrics, DownloadedLyrics, QWhereClause> {
  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DownloadedLyricsQueryFilter
    on QueryBuilder<DownloadedLyrics, DownloadedLyrics, QFilterCondition> {
  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jsonItem',
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jsonItem',
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jsonItem',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jsonItem',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonItem',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterFilterCondition>
      jsonItemIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jsonItem',
        value: '',
      ));
    });
  }
}

extension DownloadedLyricsQueryObject
    on QueryBuilder<DownloadedLyrics, DownloadedLyrics, QFilterCondition> {}

extension DownloadedLyricsQueryLinks
    on QueryBuilder<DownloadedLyrics, DownloadedLyrics, QFilterCondition> {}

extension DownloadedLyricsQuerySortBy
    on QueryBuilder<DownloadedLyrics, DownloadedLyrics, QSortBy> {
  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterSortBy>
      sortByJsonItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.asc);
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterSortBy>
      sortByJsonItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.desc);
    });
  }
}

extension DownloadedLyricsQuerySortThenBy
    on QueryBuilder<DownloadedLyrics, DownloadedLyrics, QSortThenBy> {
  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterSortBy>
      thenByJsonItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.asc);
    });
  }

  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QAfterSortBy>
      thenByJsonItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.desc);
    });
  }
}

extension DownloadedLyricsQueryWhereDistinct
    on QueryBuilder<DownloadedLyrics, DownloadedLyrics, QDistinct> {
  QueryBuilder<DownloadedLyrics, DownloadedLyrics, QDistinct>
      distinctByJsonItem({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jsonItem', caseSensitive: caseSensitive);
    });
  }
}

extension DownloadedLyricsQueryProperty
    on QueryBuilder<DownloadedLyrics, DownloadedLyrics, QQueryProperty> {
  QueryBuilder<DownloadedLyrics, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<DownloadedLyrics, String?, QQueryOperations> jsonItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jsonItem');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DownloadProfileSchema = Schema(
  name: r'DownloadProfile',
  id: -2481428030095603358,
  properties: {
    r'codec': PropertySchema(
      id: 0,
      name: r'codec',
      type: IsarType.byte,
      enumMap: _DownloadProfilecodecEnumValueMap,
    ),
    r'downloadLocationId': PropertySchema(
      id: 1,
      name: r'downloadLocationId',
      type: IsarType.string,
    ),
    r'stereoBitrate': PropertySchema(
      id: 2,
      name: r'stereoBitrate',
      type: IsarType.long,
    )
  },
  estimateSize: _downloadProfileEstimateSize,
  serialize: _downloadProfileSerialize,
  deserialize: _downloadProfileDeserialize,
  deserializeProp: _downloadProfileDeserializeProp,
);

int _downloadProfileEstimateSize(
  DownloadProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.downloadLocationId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _downloadProfileSerialize(
  DownloadProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.codec.index);
  writer.writeString(offsets[1], object.downloadLocationId);
  writer.writeLong(offsets[2], object.stereoBitrate);
}

DownloadProfile _downloadProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadProfile(
    downloadLocationId: reader.readStringOrNull(offsets[1]),
  );
  object.codec =
      _DownloadProfilecodecValueEnumMap[reader.readByteOrNull(offsets[0])] ??
          FinampTranscodingCodec.aac;
  object.stereoBitrate = reader.readLong(offsets[2]);
  return object;
}

P _downloadProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_DownloadProfilecodecValueEnumMap[
              reader.readByteOrNull(offset)] ??
          FinampTranscodingCodec.aac) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DownloadProfilecodecEnumValueMap = {
  'aac': 0,
  'mp3': 1,
  'opus': 2,
  'original': 3,
};
const _DownloadProfilecodecValueEnumMap = {
  0: FinampTranscodingCodec.aac,
  1: FinampTranscodingCodec.mp3,
  2: FinampTranscodingCodec.opus,
  3: FinampTranscodingCodec.original,
};

extension DownloadProfileQueryFilter
    on QueryBuilder<DownloadProfile, DownloadProfile, QFilterCondition> {
  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      codecEqualTo(FinampTranscodingCodec value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'codec',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      codecGreaterThan(
    FinampTranscodingCodec value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'codec',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      codecLessThan(
    FinampTranscodingCodec value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'codec',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      codecBetween(
    FinampTranscodingCodec lower,
    FinampTranscodingCodec upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'codec',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloadLocationId',
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloadLocationId',
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadLocationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'downloadLocationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadLocationId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      downloadLocationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'downloadLocationId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      stereoBitrateEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stereoBitrate',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      stereoBitrateGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stereoBitrate',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      stereoBitrateLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stereoBitrate',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadProfile, DownloadProfile, QAfterFilterCondition>
      stereoBitrateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stereoBitrate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DownloadProfileQueryObject
    on QueryBuilder<DownloadProfile, DownloadProfile, QFilterCondition> {}

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

DownloadStub _$DownloadStubFromJson(Map json) => DownloadStub._build(
      id: json['Id'] as String,
      type: $enumDecode(_$DownloadItemTypeEnumMap, json['Type']),
      jsonItem: json['JsonItem'] as String?,
      isarId: (json['IsarId'] as num).toInt(),
      name: json['Name'] as String,
      baseItemType: $enumDecode(_$BaseItemDtoTypeEnumMap, json['BaseItemType']),
    );

Map<String, dynamic> _$DownloadStubToJson(DownloadStub instance) =>
    <String, dynamic>{
      'IsarId': instance.isarId,
      'Id': instance.id,
      'Name': instance.name,
      'BaseItemType': _$BaseItemDtoTypeEnumMap[instance.baseItemType]!,
      'Type': _$DownloadItemTypeEnumMap[instance.type]!,
      'JsonItem': instance.jsonItem,
    };

const _$DownloadItemTypeEnumMap = {
  DownloadItemType.collection: 'collection',
  DownloadItemType.song: 'song',
  DownloadItemType.image: 'image',
  DownloadItemType.anchor: 'anchor',
  DownloadItemType.finampCollection: 'finampCollection',
};

const _$BaseItemDtoTypeEnumMap = {
  BaseItemDtoType.noItem: 'noItem',
  BaseItemDtoType.album: 'album',
  BaseItemDtoType.artist: 'artist',
  BaseItemDtoType.playlist: 'playlist',
  BaseItemDtoType.genre: 'genre',
  BaseItemDtoType.song: 'song',
  BaseItemDtoType.library: 'library',
  BaseItemDtoType.folder: 'folder',
  BaseItemDtoType.musicVideo: 'musicVideo',
  BaseItemDtoType.audioBook: 'audioBook',
  BaseItemDtoType.tvEpisode: 'tvEpisode',
  BaseItemDtoType.video: 'video',
  BaseItemDtoType.movie: 'movie',
  BaseItemDtoType.trailer: 'trailer',
  BaseItemDtoType.unknown: 'unknown',
};

FinampCollection _$FinampCollectionFromJson(Map json) => FinampCollection(
      type: $enumDecode(_$FinampCollectionTypeEnumMap, json['Type']),
      library: json['Library'] == null
          ? null
          : BaseItemDto.fromJson(
              Map<String, dynamic>.from(json['Library'] as Map)),
    );

Map<String, dynamic> _$FinampCollectionToJson(FinampCollection instance) {
  final val = <String, dynamic>{
    'Type': _$FinampCollectionTypeEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Library', instance.library?.toJson());
  return val;
}

const _$FinampCollectionTypeEnumMap = {
  FinampCollectionType.favorites: 'favorites',
  FinampCollectionType.allPlaylists: 'allPlaylists',
  FinampCollectionType.latest5Albums: 'latest5Albums',
  FinampCollectionType.libraryImages: 'libraryImages',
  FinampCollectionType.allPlaylistsMetadata: 'allPlaylistsMetadata',
};

MediaItemId _$MediaItemIdFromJson(Map<String, dynamic> json) => MediaItemId(
      contentType: $enumDecode(_$TabContentTypeEnumMap, json['contentType']),
      parentType: $enumDecode(_$MediaItemParentTypeEnumMap, json['parentType']),
      itemId: json['itemId'] as String?,
      parentId: json['parentId'] as String?,
    );

Map<String, dynamic> _$MediaItemIdToJson(MediaItemId instance) =>
    <String, dynamic>{
      'contentType': _$TabContentTypeEnumMap[instance.contentType]!,
      'parentType': _$MediaItemParentTypeEnumMap[instance.parentType]!,
      'itemId': instance.itemId,
      'parentId': instance.parentId,
    };

const _$TabContentTypeEnumMap = {
  TabContentType.albums: 'albums',
  TabContentType.artists: 'artists',
  TabContentType.playlists: 'playlists',
  TabContentType.genres: 'genres',
  TabContentType.songs: 'songs',
};

const _$MediaItemParentTypeEnumMap = {
  MediaItemParentType.collection: 'collection',
  MediaItemParentType.rootCollection: 'rootCollection',
  MediaItemParentType.instantMix: 'instantMix',
};

FinampFeatureChipsConfiguration _$FinampFeatureChipsConfigurationFromJson(
        Map<String, dynamic> json) =>
    FinampFeatureChipsConfiguration(
      enabled: json['enabled'] as bool,
      features: (json['features'] as List<dynamic>)
          .map((e) => $enumDecode(_$FinampFeatureChipTypeEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$FinampFeatureChipsConfigurationToJson(
        FinampFeatureChipsConfiguration instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'features': instance.features
          .map((e) => _$FinampFeatureChipTypeEnumMap[e]!)
          .toList(),
    };

const _$FinampFeatureChipTypeEnumMap = {
  FinampFeatureChipType.playCount: 'playCount',
  FinampFeatureChipType.additionalPeople: 'additionalPeople',
  FinampFeatureChipType.playbackMode: 'playbackMode',
  FinampFeatureChipType.codec: 'codec',
  FinampFeatureChipType.bitRate: 'bitRate',
  FinampFeatureChipType.bitDepth: 'bitDepth',
  FinampFeatureChipType.size: 'size',
  FinampFeatureChipType.normalizationGain: 'normalizationGain',
  FinampFeatureChipType.sampleRate: 'sampleRate',
};
