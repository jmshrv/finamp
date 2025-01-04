import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:collection/collection.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path_helper;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../services/finamp_settings_helper.dart';
import 'jellyfin_models.dart';

part 'finamp_models.g.dart';

@HiveType(typeId: 8)
@collection
class FinampUser {
  FinampUser({
    required this.id,
    required this.baseUrl,
    required this.accessToken,
    required this.serverId,
    this.currentViewId,
    this.views = const {},
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String baseUrl;
  @HiveField(2)
  String accessToken;
  @HiveField(3)
  String serverId;
  @HiveField(4)
  String? currentViewId;
  @ignore
  @HiveField(5)
  Map<String, BaseItemDto> views;

  // We only need 1 user, the current user
  final Id isarId = 0;
  String get isarViews => jsonEncode(views);
  set isarViews(String json) =>
      views = (jsonDecode(json) as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, BaseItemDto.fromJson(v)));

  @ignore
  BaseItemDto? get currentView => views[currentViewId];
}

class DefaultSettings {
  // These consts are so that we can easily keep the same default for
  // FinampSettings's constructor and Hive's defaultValue.
  static const isOffline = false;
  static const theme = ThemeMode.system;
  static const shouldTranscode = false;
  static const transcodeBitrate = 320000;
  static const androidStopForegroundOnPause = true;
  static const onlyShowFavourites = false;
  static const songShuffleItemCount = 250;
  static const volumeNormalizationActive = true;
  // 80% volume in dB. In my testing, most tracks were louder than the default target
  // of -18.0 LUFS, so the gain rarely needed to be increased. -2.0 gives us a bit of
  // headroom in case we need to boost a track (since volume can't go above 1.0),
  // without reducing the volume too much.
  // Ideally the maximum gain in each library should be fetched from the server, and this volume should be adjusted accordingly
  static const volumeNormalizationIOSBaseGain = -2.0;
  static const volumeNormalizationMode = VolumeNormalizationMode.hybrid;
  static const contentViewType = ContentViewType.list;
  static const playbackSpeedVisibility = PlaybackSpeedVisibility.automatic;
  static const contentGridViewCrossAxisCountPortrait = 2;
  static const contentGridViewCrossAxisCountLandscape = 3;
  static const showTextOnGridView = true;
  static const sleepTimerSeconds = 1800; // 30 Minutes
  static const useCoverAsBackground = true;
  static const playerScreenCoverMinimumPadding = 1.5;
  static const showArtistsTopSongs = true;
  static const disableGesture = false;
  static const showFastScroller = true;
  static const bufferDurationSeconds = 600;
  static const tabOrder = TabContentType.values;
  static const swipeInsertQueueNext = true;
  static const loopMode = FinampLoopMode.none;
  static const playbackSpeed = 1.0;
  static const autoLoadLastQueueOnStartup = true;
  static const shouldTranscodeDownloads = TranscodeDownloadsSetting.ask;
  static const shouldRedownloadTranscodes = false;
  static const resyncOnStartup = true;
  static const fixedGridTileSize = 150;
  static const useFixedSizeGridTiles = false;
  static const splitScreenPlayerWidth = 400.0;
  static const enableVibration = true;
  static const prioritizeCoverFactor = 8.0;
  static const suppressPlayerPadding = false;
  static const hidePlayerBottomActions = false;
  static const reportQueueToServer = false;
  static const periodicPlaybackSessionUpdateFrequencySeconds = 150;
  static const showArtistChipImage = true;
  static const trackOfflineFavorites = true;
  static const showProgressOnNowPlayingBar = true;
  static const startInstantMixForIndividualTracks = true;
  static const showLyricsTimestamps = true;
  static const lyricsAlignment = LyricsAlignment.start;
  static const lyricsFontSize = LyricsFontSize.medium;
  static const showLyricsScreenAlbumPrelude = true;
  static const showStopButtonOnMediaNotification = false;
  static const showSeekControlsOnMediaNotification = true;
  static const keepScreenOnOption = KeepScreenOnOption.whileLyrics;
  static const keepScreenOnWhilePluggedIn = true;
  static const hasDownloadedPlaylistInfo = false;
  static const transcodingSegmentContainer =
      FinampSegmentContainer.fragmentedMp4;
  static const featureChipsConfiguration =
      FinampFeatureChipsConfiguration(enabled: true, features: [
    FinampFeatureChipType.playCount,
    FinampFeatureChipType.additionalPeople,
    FinampFeatureChipType.playbackMode,
    FinampFeatureChipType.codec,
    FinampFeatureChipType.bitRate,
    FinampFeatureChipType.bitDepth,
    FinampFeatureChipType.sampleRate,
    FinampFeatureChipType.size,
    FinampFeatureChipType.normalizationGain,
  ]);
  static const showCoversOnAlbumScreen = false;
  static const allowSplitScreen = true;
  static const requireWifiForDownloads = false;
  static const onlyShowFullyDownloaded = false;
  static const preferQuickSyncs = true;
  static const showDownloadsWithUnknownLibrary = true;
  static const downloadWorkers = 5;
  static const maxConcurrentDownloads = 10;
}

@HiveType(typeId: 28)
class FinampSettings {
  FinampSettings(
      {this.isOffline = DefaultSettings.isOffline,
      this.shouldTranscode = DefaultSettings.shouldTranscode,
      this.transcodeBitrate = DefaultSettings.transcodeBitrate,
      // downloadLocations is required since the other values can be created with
      // default values. create() is used to return a FinampSettings with
      // downloadLocations.
      required this.downloadLocations,
      this.androidStopForegroundOnPause =
          DefaultSettings.androidStopForegroundOnPause,
      required this.showTabs,
      this.onlyShowFavourites = DefaultSettings.onlyShowFavourites,
      this.sortBy = SortBy.sortName,
      this.sortOrder = SortOrder.ascending,
      this.songShuffleItemCount = DefaultSettings.songShuffleItemCount,
      this.volumeNormalizationActive =
          DefaultSettings.volumeNormalizationActive,
      this.volumeNormalizationIOSBaseGain =
          DefaultSettings.volumeNormalizationIOSBaseGain,
      this.volumeNormalizationMode = DefaultSettings.volumeNormalizationMode,
      this.contentViewType = DefaultSettings.contentViewType,
      this.playbackSpeedVisibility = DefaultSettings.playbackSpeedVisibility,
      this.contentGridViewCrossAxisCountPortrait =
          DefaultSettings.contentGridViewCrossAxisCountPortrait,
      this.contentGridViewCrossAxisCountLandscape =
          DefaultSettings.contentGridViewCrossAxisCountLandscape,
      this.showTextOnGridView = DefaultSettings.showTextOnGridView,
      this.sleepTimerSeconds = DefaultSettings.sleepTimerSeconds,
      required this.downloadLocationsMap,
      this.useCoverAsBackground = DefaultSettings.useCoverAsBackground,
      this.playerScreenCoverMinimumPadding =
          DefaultSettings.playerScreenCoverMinimumPadding,
      this.showArtistsTopSongs = DefaultSettings.showArtistsTopSongs,
      this.bufferDurationSeconds = DefaultSettings.bufferDurationSeconds,
      required this.tabSortBy,
      required this.tabSortOrder,
      this.loopMode = DefaultSettings.loopMode,
      this.playbackSpeed = DefaultSettings.playbackSpeed,
      this.tabOrder = DefaultSettings.tabOrder,
      this.autoloadLastQueueOnStartup =
          DefaultSettings.autoLoadLastQueueOnStartup,
      this.hasCompletedBlurhashImageMigration =
          true, //!!! don't touch this default value, it's supposed to be hard coded to run the migration only once
      this.hasCompletedBlurhashImageMigrationIdFix =
          true, //!!! don't touch this default value, it's supposed to be hard coded to run the migration only once
      this.hasCompletedDownloadsServiceMigration =
          true, //!!! don't touch this default value, it's supposed to be hard coded to run the migration only once
      this.requireWifiForDownloads = DefaultSettings.requireWifiForDownloads,
      this.onlyShowFullyDownloaded = DefaultSettings.onlyShowFullyDownloaded,
      this.showDownloadsWithUnknownLibrary =
          DefaultSettings.showDownloadsWithUnknownLibrary,
      this.maxConcurrentDownloads = DefaultSettings.maxConcurrentDownloads,
      this.downloadWorkers = DefaultSettings.downloadWorkers,
      this.resyncOnStartup = DefaultSettings.resyncOnStartup,
      this.preferQuickSyncs = DefaultSettings.preferQuickSyncs,
      this.hasCompletedIsarUserMigration =
          true, //!!! don't touch this default value, it's supposed to be hard coded to run the migration only once
      this.downloadTranscodingCodec,
      this.downloadTranscodeBitrate,
      this.shouldTranscodeDownloads = DefaultSettings.shouldTranscodeDownloads,
      this.shouldRedownloadTranscodes =
          DefaultSettings.shouldRedownloadTranscodes,
      this.swipeInsertQueueNext = DefaultSettings.swipeInsertQueueNext,
      this.useFixedSizeGridTiles = DefaultSettings.useFixedSizeGridTiles,
      this.fixedGridTileSize = DefaultSettings.fixedGridTileSize,
      this.allowSplitScreen = DefaultSettings.allowSplitScreen,
      this.splitScreenPlayerWidth = DefaultSettings.splitScreenPlayerWidth,
      this.enableVibration = DefaultSettings.enableVibration,
      this.prioritizeCoverFactor = DefaultSettings.prioritizeCoverFactor,
      this.suppressPlayerPadding = DefaultSettings.suppressPlayerPadding,
      this.hidePlayerBottomActions = DefaultSettings.hidePlayerBottomActions,
      this.reportQueueToServer = DefaultSettings.reportQueueToServer,
      this.periodicPlaybackSessionUpdateFrequencySeconds =
          DefaultSettings.periodicPlaybackSessionUpdateFrequencySeconds,
      this.showArtistChipImage = DefaultSettings.showArtistChipImage,
      this.trackOfflineFavorites = DefaultSettings.trackOfflineFavorites,
      this.showProgressOnNowPlayingBar =
          DefaultSettings.showProgressOnNowPlayingBar,
      this.startInstantMixForIndividualTracks =
          DefaultSettings.startInstantMixForIndividualTracks,
      this.showLyricsTimestamps = DefaultSettings.showLyricsTimestamps,
      this.lyricsAlignment = DefaultSettings.lyricsAlignment,
      this.lyricsFontSize = DefaultSettings.lyricsFontSize,
      this.showLyricsScreenAlbumPrelude =
          DefaultSettings.showLyricsScreenAlbumPrelude,
      this.showStopButtonOnMediaNotification =
          DefaultSettings.showStopButtonOnMediaNotification,
      this.showSeekControlsOnMediaNotification =
          DefaultSettings.showSeekControlsOnMediaNotification,
      this.keepScreenOnOption = DefaultSettings.keepScreenOnOption,
      this.keepScreenOnWhilePluggedIn =
          DefaultSettings.keepScreenOnWhilePluggedIn,
      this.featureChipsConfiguration =
          DefaultSettings.featureChipsConfiguration,
      this.showCoversOnAlbumScreen = DefaultSettings.showCoversOnAlbumScreen,
      this.hasDownloadedPlaylistInfo =
          DefaultSettings.hasDownloadedPlaylistInfo,
      this.transcodingSegmentContainer =
          DefaultSettings.transcodingSegmentContainer});

  @HiveField(0, defaultValue: DefaultSettings.isOffline)
  bool isOffline;
  @HiveField(1, defaultValue: DefaultSettings.shouldTranscode)
  bool shouldTranscode;
  @HiveField(2, defaultValue: DefaultSettings.transcodeBitrate)
  int transcodeBitrate;

  @Deprecated("Use downloadedLocationsMap instead")
  @HiveField(3)
  List<DownloadLocation> downloadLocations;

  @HiveField(4,
      defaultValue: DefaultSettings.androidStopForegroundOnPause)
  bool androidStopForegroundOnPause;
  @HiveField(5)
  Map<TabContentType, bool> showTabs;

  /// Used to remember if the user has set their music screen to favourites
  /// mode.
  @HiveField(6, defaultValue: DefaultSettings.onlyShowFavourites)
  bool onlyShowFavourites;

  /// Current sort by setting.
  @Deprecated("Use per-tab sort by instead")
  @HiveField(7)
  SortBy sortBy;

  /// Current sort order setting.
  @Deprecated("Use per-tab sort order instead")
  @HiveField(8)
  SortOrder sortOrder;

  /// Amount of songs to get when shuffling songs.
  @HiveField(9, defaultValue: DefaultSettings.songShuffleItemCount)
  int songShuffleItemCount;

  /// The content view type used by the music screen.
  @HiveField(10, defaultValue: DefaultSettings.contentViewType)
  ContentViewType contentViewType;

  /// Amount of grid tiles to use per-row when portrait.
  @HiveField(11,
      defaultValue: DefaultSettings.contentGridViewCrossAxisCountPortrait)
  int contentGridViewCrossAxisCountPortrait;

  /// Amount of grid tiles to use per-row when landscape.
  @HiveField(12,
      defaultValue: DefaultSettings.contentGridViewCrossAxisCountLandscape)
  int contentGridViewCrossAxisCountLandscape;

  /// Whether or not to show the text (title, artist etc) on the grid music
  /// screen.
  @HiveField(13, defaultValue: DefaultSettings.showTextOnGridView)
  bool showTextOnGridView = DefaultSettings.showTextOnGridView;

  /// The number of seconds to wait in a sleep timer. This is so that the app
  /// can remember the last duration. I'd use a Duration type here but Hive
  /// doesn't come with an adapter for it by default.
  @HiveField(14, defaultValue: DefaultSettings.sleepTimerSeconds)
  int sleepTimerSeconds;

  @HiveField(15, defaultValue: {})
  Map<String, DownloadLocation> downloadLocationsMap;

  /// Whether or not to use blurred cover art as background on player screen.
  @HiveField(16, defaultValue: DefaultSettings.useCoverAsBackground)
  bool useCoverAsBackground = DefaultSettings.useCoverAsBackground;

  @HiveField(18, defaultValue: DefaultSettings.bufferDurationSeconds)
  int bufferDurationSeconds;

  @HiveField(19, defaultValue: DefaultSettings.disableGesture)
  bool disableGesture = DefaultSettings.disableGesture;

  @HiveField(20, defaultValue: {})
  Map<TabContentType, SortBy> tabSortBy;

  @HiveField(21, defaultValue: {})
  Map<TabContentType, SortOrder> tabSortOrder;

  @HiveField(22, defaultValue: DefaultSettings.tabOrder)
  List<TabContentType> tabOrder;

  @HiveField(23,
      defaultValue:
          true) //!!! don't touch this default value, it's supposed to be hard coded to run the migration only once
  bool hasCompletedBlurhashImageMigration;

  @HiveField(24,
      defaultValue:
          true) //!!! don't touch this default value, it's supposed to be hard coded to run the migration only once
  bool hasCompletedBlurhashImageMigrationIdFix;

  @HiveField(25, defaultValue: DefaultSettings.showFastScroller)
  bool showFastScroller = DefaultSettings.showFastScroller;

  @HiveField(26, defaultValue: DefaultSettings.swipeInsertQueueNext)
  bool swipeInsertQueueNext;

  @HiveField(27, defaultValue: DefaultSettings.loopMode)
  FinampLoopMode loopMode;

  @HiveField(28, defaultValue: DefaultSettings.autoLoadLastQueueOnStartup)
  bool autoloadLastQueueOnStartup;

  @HiveField(29, defaultValue: DefaultSettings.volumeNormalizationActive)
  bool volumeNormalizationActive;

  @HiveField(30, defaultValue: DefaultSettings.volumeNormalizationIOSBaseGain)
  double volumeNormalizationIOSBaseGain;

  @HiveField(33, defaultValue: DefaultSettings.volumeNormalizationMode)
  VolumeNormalizationMode volumeNormalizationMode;

  @HiveField(34,
      defaultValue:
          true) //!!! don't touch this default value, it's supposed to be hard coded to run the migration only once
  bool hasCompletedDownloadsServiceMigration;

  @HiveField(35, defaultValue: DefaultSettings.requireWifiForDownloads)
  bool requireWifiForDownloads;

  @HiveField(36, defaultValue: DefaultSettings.onlyShowFullyDownloaded)
  bool onlyShowFullyDownloaded;

  @HiveField(37, defaultValue: DefaultSettings.showDownloadsWithUnknownLibrary)
  bool showDownloadsWithUnknownLibrary;

  @HiveField(38, defaultValue: DefaultSettings.maxConcurrentDownloads)
  int maxConcurrentDownloads;

  @HiveField(39, defaultValue: DefaultSettings.downloadWorkers)
  int downloadWorkers;

  @HiveField(40, defaultValue: DefaultSettings.resyncOnStartup)
  bool resyncOnStartup;

  @HiveField(41, defaultValue: DefaultSettings.preferQuickSyncs)
  bool preferQuickSyncs;

  @HiveField(42, defaultValue: true)
  bool hasCompletedIsarUserMigration;
  FinampTranscodingCodec? downloadTranscodingCodec;

  @HiveField(44, defaultValue: DefaultSettings.shouldTranscodeDownloads)
  TranscodeDownloadsSetting shouldTranscodeDownloads;

  @HiveField(45)
  int? downloadTranscodeBitrate;

  @HiveField(46, defaultValue: DefaultSettings.shouldRedownloadTranscodes)
  bool shouldRedownloadTranscodes;

  @HiveField(47, defaultValue: DefaultSettings.enableVibration)
  bool enableVibration;

  @HiveField(48, defaultValue: DefaultSettings.playerScreenCoverMinimumPadding)
  double playerScreenCoverMinimumPadding =
      DefaultSettings.playerScreenCoverMinimumPadding;

  @HiveField(49, defaultValue: DefaultSettings.prioritizeCoverFactor)
  double prioritizeCoverFactor;

  @HiveField(50, defaultValue: DefaultSettings.suppressPlayerPadding)
  bool suppressPlayerPadding;

  @HiveField(51, defaultValue: DefaultSettings.hidePlayerBottomActions)
  bool hidePlayerBottomActions;

  @HiveField(52, defaultValue: DefaultSettings.reportQueueToServer)
  bool reportQueueToServer;

  @HiveField(53,
      defaultValue:
          DefaultSettings.periodicPlaybackSessionUpdateFrequencySeconds)
  @HiveField(53,
      defaultValue:
          DefaultSettings.periodicPlaybackSessionUpdateFrequencySeconds)
  int periodicPlaybackSessionUpdateFrequencySeconds;

  @HiveField(54, defaultValue: DefaultSettings.showArtistsTopSongs)
  bool showArtistsTopSongs = DefaultSettings.showArtistsTopSongs;

  @HiveField(55, defaultValue: DefaultSettings.showArtistChipImage)
  bool showArtistChipImage;

  @HiveField(56, defaultValue: DefaultSettings.playbackSpeed)
  double playbackSpeed;

  /// The content playback speed type defining how and whether to display the playback speed controls in the song menu
  @HiveField(57, defaultValue: DefaultSettings.playbackSpeedVisibility)
  PlaybackSpeedVisibility playbackSpeedVisibility;

  @HiveField(58, defaultValue: null)
  String? defaultDownloadLocation;

  @HiveField(59, defaultValue: DefaultSettings.useFixedSizeGridTiles)
  bool useFixedSizeGridTiles;

  @HiveField(60, defaultValue: DefaultSettings.fixedGridTileSize)
  int fixedGridTileSize;

  @HiveField(61, defaultValue: DefaultSettings.allowSplitScreen)
  bool allowSplitScreen;

  @HiveField(62, defaultValue: DefaultSettings.splitScreenPlayerWidth)
  double splitScreenPlayerWidth;

  @HiveField(63, defaultValue: DefaultSettings.trackOfflineFavorites)
  bool trackOfflineFavorites;

  @HiveField(64, defaultValue: DefaultSettings.showProgressOnNowPlayingBar)
  bool showProgressOnNowPlayingBar;

  @HiveField(65,
      defaultValue: DefaultSettings.startInstantMixForIndividualTracks)
  bool startInstantMixForIndividualTracks;

  @HiveField(66, defaultValue: DefaultSettings.showLyricsTimestamps)
  bool showLyricsTimestamps;

  @HiveField(67, defaultValue: DefaultSettings.lyricsAlignment)
  LyricsAlignment lyricsAlignment;

  @HiveField(68,
      defaultValue: DefaultSettings.showStopButtonOnMediaNotification)
  bool showStopButtonOnMediaNotification;

  @HiveField(69,
      defaultValue: DefaultSettings.showSeekControlsOnMediaNotification)
  bool showSeekControlsOnMediaNotification;

  @HiveField(70, defaultValue: DefaultSettings.lyricsFontSize)
  LyricsFontSize lyricsFontSize;

  @HiveField(71, defaultValue: DefaultSettings.showLyricsScreenAlbumPrelude)
  bool showLyricsScreenAlbumPrelude;

  @HiveField(72, defaultValue: DefaultSettings.keepScreenOnOption)
  KeepScreenOnOption keepScreenOnOption;

  @HiveField(73, defaultValue: DefaultSettings.keepScreenOnWhilePluggedIn)
  bool keepScreenOnWhilePluggedIn;

  @HiveField(74, defaultValue: DefaultSettings.hasDownloadedPlaylistInfo)
  bool hasDownloadedPlaylistInfo;

  @HiveField(75, defaultValue: DefaultSettings.transcodingSegmentContainer)
  FinampSegmentContainer transcodingSegmentContainer;

  @HiveField(76, defaultValue: DefaultSettings.featureChipsConfiguration)
  FinampFeatureChipsConfiguration featureChipsConfiguration;

  @HiveField(77, defaultValue: DefaultSettings.showCoversOnAlbumScreen)
  bool showCoversOnAlbumScreen;

  static Future<FinampSettings> create() async {
    final downloadLocation = await DownloadLocation.create(
      name: "Internal Storage",
      // default download location moved to support dir based on existing comment
      baseDirectory: (Platform.isIOS || Platform.isAndroid)
          ? DownloadLocationType.internalSupport
          : DownloadLocationType.cache,
    );
    return FinampSettings(
      downloadLocations: [],
      // Create a map of TabContentType from TabContentType's values.
      showTabs: Map.fromEntries(
        TabContentType.values.map(
          (e) => MapEntry(e, true),
        ),
      ),
      downloadLocationsMap: {downloadLocation.id: downloadLocation},
      tabSortBy: {},
      tabSortOrder: {},
      useFixedSizeGridTiles: !(Platform.isIOS || Platform.isAndroid),
    );
  }

  DownloadProfile get downloadTranscodingProfile => DownloadProfile(
      transcodeCodec: downloadTranscodingCodec,
      bitrate: downloadTranscodeBitrate);

  /// Returns the DownloadLocation that is the internal song dir. This can
  /// technically throw a StateError, but that should never happen™.
  DownloadLocation get internalSongDir =>
      downloadLocationsMap.values.firstWhere((element) =>
          element.baseDirectory ==
          ((Platform.isIOS || Platform.isAndroid)
              ? DownloadLocationType.internalSupport
              : DownloadLocationType.cache));

  Duration get bufferDuration => Duration(seconds: bufferDurationSeconds);

  set bufferDuration(Duration duration) =>
      bufferDurationSeconds = duration.inSeconds;

  SortBy getTabSortBy(TabContentType tabType) {
    return tabSortBy[tabType] ?? SortBy.sortName;
  }

  SortOrder getSortOrder(TabContentType tabType) {
    return tabSortOrder[tabType] ?? SortOrder.ascending;
  }
}

enum CustomPlaybackActions {
  shuffle,
  toggleFavorite;
}

/// Custom storage locations for storing music/images.
@HiveType(typeId: 31)
class DownloadLocation {
  DownloadLocation(
      {required this.name,
      required this.relativePath,
      required this.id,
      this.legacyUseHumanReadableNames,
      this.legacyDeletable,
      required this.baseDirectory}) {
    assert(baseDirectory.needsPath == (relativePath != null));
    assert(baseDirectory == DownloadLocationType.migrated ||
        (legacyUseHumanReadableNames == null && legacyDeletable == null));
    assert(baseDirectory != DownloadLocationType.migrated ||
        (legacyUseHumanReadableNames != null && legacyDeletable != null));
  }

  /// Human-readable name for the path (shown in settings)
  @HiveField(0)
  String name;

  /// The path. We store this as a string since it's easier to put into Hive.
  @HiveField(1)
  String? relativePath;

  /// If true, store songs using their actual names instead of Jellyfin item IDs.
  @Deprecated("This is here for migration.  Use useHumanReadableNames instead.")
  @HiveField(2)
  bool? legacyUseHumanReadableNames;

  bool get useHumanReadableNames => baseDirectory.useHumanReadableNames;

  /// If true, the user can delete this storage location. It's a bit of a hack,
  /// but the only undeletable location is the internal storage dir, so we can
  /// use this value to get the internal song dir.
  @HiveField(3)
  @Deprecated("This is here for migration.  Use baseDirectory instead.")
  bool? legacyDeletable;

  /// Unique ID for the DownloadLocation. If this DownloadLocation was created
  /// before 0.6, it will be "0", very temporarily until it is changed on
  /// startup.
  @HiveField(4, defaultValue: "0")
  String id;

  /// Base directory of DownloadLocation.  Used to calculate currentPath and
  /// to determine directory attributes.
  @HiveField(5, defaultValue: DownloadLocationType.migrated)
  DownloadLocationType baseDirectory;

  String? _currentPath;

  /// The current path to the location, updated during app startup
  String get currentPath => _currentPath!;

  /// Update currentPath to the latest value.  Run for every downloadLocation
  /// every time the app starts up.
  Future<void> updateCurrentPath() async {
    if (baseDirectory == DownloadLocationType.migrated) {
      if (!legacyDeletable!) {
        baseDirectory = DownloadLocationType.internalDocuments;
        relativePath = null;
        name = "Legacy Internal Storage";
      } else if (!legacyUseHumanReadableNames!) {
        baseDirectory = DownloadLocationType.external;
      } else {
        baseDirectory = DownloadLocationType.custom;
      }
      legacyDeletable = null;
      legacyUseHumanReadableNames = null;
    }
    switch (baseDirectory) {
      case DownloadLocationType.internalDocuments:
        _currentPath = (await getApplicationDocumentsDirectory()).path;
      case DownloadLocationType.internalSupport:
        _currentPath = (await getApplicationSupportDirectory()).path;
      case DownloadLocationType.external:
        _currentPath = relativePath!;
      case DownloadLocationType.custom:
        _currentPath = relativePath!;
      case DownloadLocationType.cache:
        _currentPath = (await getApplicationCacheDirectory()).path;
      case DownloadLocationType.none:
      case DownloadLocationType.migrated:
        throw StateError("Bad basedirectory");
    }
  }

  /// Initialises a new DownloadLocation. id will be a UUID.
  static Future<DownloadLocation> create({
    required String name,
    String? relativePath,
    required DownloadLocationType baseDirectory,
  }) async {
    var downloadLocation = DownloadLocation(
      name: name,
      relativePath: relativePath,
      baseDirectory: baseDirectory,
      id: const Uuid().v4(),
    );
    await downloadLocation.updateCurrentPath();
    return downloadLocation;
  }
}

/// Class used in AddDownloadLocationScreen. Basically just a DownloadLocation
/// with nullable values. Shouldn't be used for actually storing download
/// locations.
class NewDownloadLocation {
  NewDownloadLocation({
    this.name,
    this.path,
    required this.baseDirectory,
  });

  String? name;
  String? path;
  DownloadLocationType baseDirectory;
}

/// Supported tab types in MusicScreenTabView.
@HiveType(typeId: 36)
enum TabContentType {
  @HiveField(0)
  albums(BaseItemDtoType.album),
  @HiveField(1)
  artists(BaseItemDtoType.artist),
  @HiveField(2)
  playlists(BaseItemDtoType.playlist),
  @HiveField(3)
  genres(BaseItemDtoType.genre),
  @HiveField(4)
  songs(BaseItemDtoType.song);

  const TabContentType(this.itemType);

  final BaseItemDtoType itemType;

  /// Human-readable version of the [TabContentType]. For example, toString() on
  /// [TabContentType.songs], toString() would return "TabContentType.songs".
  /// With this function, the same input would return "Songs".
  @override
  @Deprecated("Use toLocalisedString when possible")
  String toString() => _humanReadableName(this);

  String toLocalisedString(BuildContext context) =>
      _humanReadableLocalisedName(this, context);

  String _humanReadableName(TabContentType tabContentType) {
    switch (tabContentType) {
      case TabContentType.songs:
        return "Songs";
      case TabContentType.albums:
        return "Albums";
      case TabContentType.artists:
        return "Artists";
      case TabContentType.genres:
        return "Genres";
      case TabContentType.playlists:
        return "Playlists";
    }
  }

  String _humanReadableLocalisedName(
      TabContentType tabContentType, BuildContext context) {
    switch (tabContentType) {
      case TabContentType.songs:
        return AppLocalizations.of(context)!.songs;
      case TabContentType.albums:
        return AppLocalizations.of(context)!.albums;
      case TabContentType.artists:
        return AppLocalizations.of(context)!.artists;
      case TabContentType.genres:
        return AppLocalizations.of(context)!.genres;
      case TabContentType.playlists:
        return AppLocalizations.of(context)!.playlists;
    }
  }

  static TabContentType fromItemType(String itemType) {
    switch (itemType) {
      case "Audio":
        return TabContentType.songs;
      case "MusicAlbum":
        return TabContentType.albums;
      case "MusicArtist":
        return TabContentType.artists;
      case "MusicGenre":
        return TabContentType.genres;
      case "Playlist":
        return TabContentType.playlists;
      default:
        throw const FormatException("Unsupported itemType");
    }
  }
}

@HiveType(typeId: 39)
enum ContentViewType {
  @HiveField(0)
  list,
  @HiveField(1)
  grid;

  /// Human-readable version of this enum. I've written longer descriptions on
  /// enums like [TabContentType], and I can't be bothered to copy and paste it
  /// again.
  @override
  @Deprecated("Use toLocalisedString when possible")
  String toString() => _humanReadableName(this);

  String toLocalisedString(BuildContext context) =>
      _humanReadableLocalisedName(this, context);

  String _humanReadableName(ContentViewType contentViewType) {
    switch (contentViewType) {
      case ContentViewType.list:
        return "List";
      case ContentViewType.grid:
        return "Grid";
    }
  }

  String _humanReadableLocalisedName(
      ContentViewType contentViewType, BuildContext context) {
    switch (contentViewType) {
      case ContentViewType.list:
        return AppLocalizations.of(context)!.list;
      case ContentViewType.grid:
        return AppLocalizations.of(context)!.grid;
    }
  }
}

@HiveType(typeId: 3)
@JsonSerializable(
  explicitToJson: true,
  anyMap: true,
)
@Deprecated("Hive download schemas are only present to enable migration.")
class DownloadedSong {
  DownloadedSong({
    required this.song,
    required this.mediaSourceInfo,
    required this.downloadId,
    required this.requiredBy,
    required this.path,
    required this.useHumanReadableNames,
    required this.viewId,
    this.isPathRelative = true,
    required this.downloadLocationId,
  });

  /// The Jellyfin item for the song
  @HiveField(0)
  BaseItemDto song;

  /// The media source info for the song (used to get file format)
  @HiveField(1)
  MediaSourceInfo mediaSourceInfo;

  /// The download ID of the song (for FlutterDownloader)
  @HiveField(2)
  String downloadId;

  /// The list of parent item IDs the item is downloaded for. If this is 0, the
  /// song should be deleted.
  @HiveField(3)
  List<String> requiredBy;

  /// The path of the song file. if [isPathRelative] is true, this will be a
  /// relative path from the song's DownloadLocation.
  @HiveField(4)
  String path;

  /// Whether or not the file is stored with a human readable name. We need this
  /// when deleting downloads, as we need to check for empty folders when
  /// deleting files with human readable names.
  @HiveField(5)
  bool useHumanReadableNames;

  /// The view that this download is in. Used for sorting in offline mode.
  @HiveField(6)
  String viewId;

  /// Whether or not [path] is relative.
  @HiveField(7, defaultValue: false)
  bool isPathRelative;

  /// The ID of the DownloadLocation that holds this file. Will be null if made
  /// before 0.6.
  @HiveField(8)
  String? downloadLocationId;

  factory DownloadedSong.fromJson(Map<String, dynamic> json) =>
      _$DownloadedSongFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadedSongToJson(this);
}

@HiveType(typeId: 4)
@Deprecated("Hive download schemas are only present to enable migration.")
class DownloadedParent {
  DownloadedParent({
    required this.item,
    required this.downloadedChildren,
    required this.viewId,
  });

  @HiveField(0)
  BaseItemDto item;
  @HiveField(1)
  Map<String, BaseItemDto> downloadedChildren;

  /// The view that this download is in. Used for sorting in offline mode.
  @HiveField(2)
  String viewId;
}

@HiveType(typeId: 40)
@Deprecated("Hive download schemas are only present to enable migration.")
class DownloadedImage {
  DownloadedImage({
    required this.id,
    required this.downloadId,
    required this.path,
    required this.requiredBy,
    required this.downloadLocationId,
  });

  /// The image ID
  @HiveField(0)
  String id;

  /// The download ID of the song (for FlutterDownloader)
  @HiveField(1)
  String downloadId;

  /// The relative path to the image file. To get the absolute path, use the
  /// file getter.
  @HiveField(2)
  String path;

  /// The list of item IDs that use this image. If this is empty, the image
  /// should be deleted.
  @HiveField(3)
  List<String> requiredBy;

  /// The ID of the DownloadLocation that holds this file.
  @HiveField(4)
  String downloadLocationId;

  /// Creates a new DownloadedImage. Does not actually handle downloading or
  /// anything. This is only really a thing since having to manually specify
  /// empty lists is a bit jank.
  static DownloadedImage create({
    required String id,
    required String downloadId,
    required String path,
    List<String>? requiredBy,
    required String downloadLocationId,
  }) =>
      DownloadedImage(
        id: id,
        downloadId: downloadId,
        path: path,
        requiredBy: requiredBy ?? [],
        downloadLocationId: downloadLocationId,
      );
}

/// A reference to a downloadable item with no state.  Can be freely created
/// from a BaseItemDto at any time.  DownloadStubs/DownloadItems are considered
/// equivalent if their types and ids match.
@JsonSerializable(
    fieldRename: FieldRename.pascal,
    explicitToJson: true,
    anyMap: true,
    constructor: "_build")
class DownloadStub {
  DownloadStub._build({
    required this.id,
    required this.type,
    required this.jsonItem,
    required this.isarId,
    required this.name,
    required this.baseItemType,
  }) {
    assert(
        _verifyEnums(), "$type $baseItemType ${baseItem?.toJson().toString()}");
  }

  bool _verifyEnums() {
    switch (type) {
      case DownloadItemType.collection:
        return baseItem != null &&
            BaseItemDtoType.fromItem(baseItem!) == baseItemType &&
            baseItemType.downloadType == DownloadItemType.collection &&
            baseItemType != BaseItemDtoType.noItem;
      case DownloadItemType.song:
        return baseItemType.downloadType == DownloadItemType.song &&
            baseItem != null &&
            BaseItemDtoType.fromItem(baseItem!) == baseItemType;
      case DownloadItemType.image:
        return baseItem != null;
      case DownloadItemType.finampCollection:
        return baseItem == null &&
            baseItemType == BaseItemDtoType.noItem &&
            finampCollection != null;
      case DownloadItemType.anchor:
        return baseItem == null &&
            baseItemType == BaseItemDtoType.noItem &&
            id == "Anchor";
    }
  }

  factory DownloadStub.fromItem({
    required DownloadItemType type,
    required BaseItemDto item,
  }) {
    assert(type.requiresItem);
    assert(type != DownloadItemType.image ||
        (item.blurHash != null || item.imageId != null));
    String id = (type == DownloadItemType.image)
        ? item.blurHash ?? item.imageId!
        : item.id;
    return DownloadStub._build(
        id: id,
        isarId: getHash(id, type),
        jsonItem: jsonEncode(item.toJson()),
        type: type,
        name: (type == DownloadItemType.image)
            ? "Image for ${item.name}"
            : item.name ?? id,
        baseItemType: BaseItemDtoType.fromItem(item));
  }

  factory DownloadStub.fromId(
      {required String id,
      required DownloadItemType type,
      required String? name}) {
    assert(!type.requiresItem);
    return DownloadStub._build(
        id: id,
        isarId: getHash(id, type),
        jsonItem: null,
        type: type,
        name: name ?? "Unlocalized $id",
        baseItemType: BaseItemDtoType.noItem);
  }

  factory DownloadStub.fromFinampCollection(FinampCollection collection) {
    String id = collection.id;
    // Fetch localized name from default global context.
    String? name;
    var context = GlobalSnackbar.materialAppScaffoldKey.currentContext;
    if (context != null) {
      name = collection.getName(context);
    }

    return DownloadStub._build(
        id: id,
        isarId: getHash(id, DownloadItemType.finampCollection),
        jsonItem: jsonEncode(collection.toJson()),
        type: DownloadItemType.finampCollection,
        name: name ?? "Unlocalized Finamp Collection $id",
        baseItemType: BaseItemDtoType.noItem);
  }

  /// The integer iD used as a database key by Isar
  final Id isarId;

  /// The id string of the underlying BaseItemDto
  final String id;

  /// The name of the underlying BaseItemDto
  final String name;

  @Enumerated(EnumType.ordinal)
  final BaseItemDtoType baseItemType;

  @Enumerated(EnumType.ordinal)
  @Index()
  final DownloadItemType type;

  /// The baseItemDto as a JSON string for storage in isar.
  /// Use baseItem to retrieve.
  final String? jsonItem;

  @ignore
  BaseItemDto? get baseItem =>
      _baseItemCached ??= ((jsonItem == null || !type.requiresItem)
          ? null
          : BaseItemDto.fromJson(jsonDecode(jsonItem!)));

  @ignore
  BaseItemDto? _baseItemCached;

  @ignore
  FinampCollection? get finampCollection =>
      _finampCollectionCached ??= (type != DownloadItemType.finampCollection
          ? null
          : jsonItem == null
              // Switch on ID to allow legacy collections to continue syncing
              ? switch (id) {
                  "Favorites" =>
                    FinampCollection(type: FinampCollectionType.favorites),
                  "All Playlists" =>
                    FinampCollection(type: FinampCollectionType.allPlaylists),
                  "5 Latest Albums" =>
                    FinampCollection(type: FinampCollectionType.latest5Albums),
                  _ =>
                    throw "Invalid FinampCollection DownloadItem: no attached collection"
                }
              : FinampCollection.fromJson(jsonDecode(jsonItem!)));

  @ignore
  FinampCollection? _finampCollectionCached;

  /// FNV-1a 64bit hash algorithm optimized for Dart Strings
  /// Provided by Isar documentation
  /// Do not use directly, use getHash
  static int _fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }

  /// Calculate a DownloadStub's isarId
  static int getHash(String id, DownloadItemType type) {
    return _fastHash(type.name + id);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadStub && other.isarId == isarId;
  }

  @override
  @ignore
  int get hashCode => isarId;

  /// For use by downloadsService during database inserts.  Do not call directly.
  DownloadItem asItem(DownloadProfile? transcodingProfile) {
    return DownloadItem(
      id: id,
      type: type,
      jsonItem: jsonItem,
      isarId: isarId,
      name: name,
      state: DownloadItemState.notDownloaded,
      baseItemType: baseItemType,
      baseIndexNumber: baseItem?.indexNumber,
      parentIndexNumber: baseItem?.parentIndexNumber,
      orderedChildren: null,
      path: null,
      viewId: null,
      userTranscodingProfile: null,
      syncTranscodingProfile: transcodingProfile,
      fileTranscodingProfile: null,
    );
  }

  factory DownloadStub.fromJson(Map<String, dynamic> json) =>
      _$DownloadStubFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadStubToJson(this);
}

/// Download metadata with state and file location information.  This should never
/// be built directly, and instead should be retrieved from Isar.
@collection
class DownloadItem extends DownloadStub {
  /// For use by Isar.  Do not call directly.
  DownloadItem(
      {required super.id,
      required super.type,
      required super.jsonItem,
      required super.isarId,
      required super.name,
      required super.baseItemType,
      required this.state,
      required this.baseIndexNumber,
      required this.parentIndexNumber,
      required this.orderedChildren,
      required this.path,
      required this.viewId,
      required this.userTranscodingProfile,
      required this.syncTranscodingProfile,
      required this.fileTranscodingProfile})
      : super._build() {
    assert(!(type == DownloadItemType.collection &&
            baseItemType == BaseItemDtoType.playlist) ||
        viewId == null);
  }

  final requires = IsarLinks<DownloadItem>();

  @Backlink(to: "requires")
  final requiredBy = IsarLinks<DownloadItem>();

  final info = IsarLinks<DownloadItem>();

  @Backlink(to: "info")
  final infoFor = IsarLinks<DownloadItem>();

  /// Do not update directly.  Use downloadsService _updateItemState.
  @Enumerated(EnumType.ordinal)
  @Index()
  DownloadItemState state;

  /// index numbers from backing BaseItemDto.  Used to order songs in albums.
  final int? baseIndexNumber;
  final int? parentIndexNumber;

  /// List of ordered isarIds of collection children.  This is used to order
  /// songs in playlists.
  List<int>? orderedChildren;

  /// The path to the downloads file, relative to the download location's currentPath.
  String? path;

  /// The id of the view/library containing this item.  Will be null for playlists
  /// and child elements with no non-playlist parents.
  String? viewId;

  DownloadProfile? userTranscodingProfile;
  DownloadProfile? syncTranscodingProfile;
  DownloadProfile? fileTranscodingProfile;

  @ignore
  DownloadLocation? get fileDownloadLocation => FinampSettingsHelper
      .finampSettings
      .downloadLocationsMap[fileTranscodingProfile?.downloadLocationId];

  @ignore
  DownloadLocation? get syncDownloadLocation => FinampSettingsHelper
      .finampSettings
      .downloadLocationsMap[syncTranscodingProfile?.downloadLocationId];

  @ignore
  File? get file {
    if (fileDownloadLocation == null || path == null) {
      return null;
    }

    return File(path_helper.join(fileDownloadLocation!.currentPath, path));
  }

  @override
  String toString() {
    return "$runtimeType ${type.name} '$name'";
  }

  /// Copy item with updated metadata.  Used inside _syncDownload, do not call elsewhere.
  DownloadItem? copyWith(
      {BaseItemDto? item,
      List<DownloadStub>? orderedChildItems,
      String? viewId,
      required bool forceCopy}) {
    String? json;
    if (type == DownloadItemType.image) {
      // Images do not have any attributes we might want to update
      return null;
    }
    if (item != null) {
      if (baseItemType != BaseItemDtoType.fromItem(item) || baseItem == null) {
        throw "Could not update $name - incompatible new item $item";
      }
      if (item.id != id) {
        throw "Could not update $name - incompatible new item $item";
      }
      // Not all BaseItemDto are requested with mediaSources, mediaStreams or childCount.  Do not
      // overwrite with null if the new item does not have them.
      item.mediaSources ??= baseItem?.mediaSources;
      item.mediaStreams ??= baseItem?.mediaStreams;
      item.sortName ??= baseItem?.sortName;
    }
    assert(item == null ||
        ((item.mediaSources == null || item.mediaSources!.isNotEmpty) &&
            (item.mediaStreams == null || item.mediaStreams!.isNotEmpty)));
    var orderedChildren = orderedChildItems?.map((e) => e.isarId).toList();
    if (!forceCopy) {
      if (viewId == null || viewId == this.viewId) {
        if (item == null || baseItem!.mostlyEqual(item)) {
          var equal = const DeepCollectionEquality().equals;
          if (equal(orderedChildren, this.orderedChildren)) {
            return null;
          }
        }
      }
    }
    if (item != null) {
      json = jsonEncode(item.toJson());
    }
    return DownloadItem(
      baseIndexNumber: item?.indexNumber ?? baseIndexNumber,
      baseItemType: baseItemType,
      id: id,
      isarId: isarId,
      jsonItem: json ?? jsonItem,
      name: item?.name ?? name,
      orderedChildren: orderedChildren ?? this.orderedChildren,
      parentIndexNumber: item?.parentIndexNumber ?? parentIndexNumber,
      path: path,
      state: state,
      type: type,
      viewId: viewId ?? this.viewId,
      userTranscodingProfile: userTranscodingProfile,
      syncTranscodingProfile: syncTranscodingProfile,
      fileTranscodingProfile: fileTranscodingProfile,
    );
  }
}

/// The primary type of a DownloadItem.
/// Enumerated by Isar, do not modify order or delete existing entries.
enum DownloadItemType {
  collection(true, false),
  song(true, true),
  image(true, true),
  anchor(false, false),
  finampCollection(false, false);

  const DownloadItemType(this.requiresItem, this.hasFiles);

  final bool requiresItem;
  final bool hasFiles;
}

/// The state of a DownloadItem's files and download task.
/// Obtain via downloadsService stateProvider.
/// Enumerated by Isar, do not modify order or delete existing entries.
enum DownloadItemState {
  notDownloaded,
  downloading,
  failed,
  complete,
  enqueued,
  syncFailed,
  needsRedownload,
  needsRedownloadComplete;

  bool get isFinal {
    switch (this) {
      case DownloadItemState.notDownloaded:
      case DownloadItemState.downloading:
      case DownloadItemState.enqueued:
        return false;
      case DownloadItemState.failed:
      case DownloadItemState.complete:
      case DownloadItemState.syncFailed:
      case DownloadItemState.needsRedownload:
      case DownloadItemState.needsRedownloadComplete:
        return true;
    }
  }

  bool get isComplete {
    switch (this) {
      case DownloadItemState.notDownloaded:
      case DownloadItemState.downloading:
      case DownloadItemState.enqueued:
      case DownloadItemState.syncFailed:
      case DownloadItemState.needsRedownload:
      case DownloadItemState.failed:
        return false;
      case DownloadItemState.complete:
      case DownloadItemState.needsRedownloadComplete:
        return true;
    }
  }

  static DownloadItemState fromTaskStatus(TaskStatus status) {
    assert(status != TaskStatus.paused);
    return switch (status) {
      // DownloadItemState.enqueued should only be reachable via _initiateDownload
      // or background_downloader listener to ensure item is ready to download
      TaskStatus.enqueued => DownloadItemState.downloading,
      TaskStatus.running => DownloadItemState.downloading,
      TaskStatus.complete => DownloadItemState.complete,
      TaskStatus.failed => DownloadItemState.failed,
      TaskStatus.canceled => DownloadItemState.notDownloaded,
      // Put paused items back in queue to be restarted
      TaskStatus.paused => DownloadItemState.enqueued,
      TaskStatus.notFound => DownloadItemState.failed,
      TaskStatus.waitingToRetry => DownloadItemState.downloading,
    };
  }
}

/// The status of a download, as used to determine download button state.
/// Obtain via downloadsService statusProvider.
enum DownloadItemStatus {
  notNeeded(false, false, false),
  incidental(false, false, true),
  incidentalOutdated(false, true, true),
  required(true, false, false),
  requiredOutdated(true, true, false);

  const DownloadItemStatus(this.isRequired, this.outdated, this.isIncidental);

  final bool isRequired;
  final bool outdated;
  final bool isIncidental;
}

/// The type of a BaseItemDto as determined from its type field.
/// Enumerated by Isar, do not modify order or delete existing entries
enum BaseItemDtoType {
  noItem(null, true, null, null),
  album("MusicAlbum", false, [song], DownloadItemType.collection),
  artist("MusicArtist", true, [album, song], DownloadItemType.collection),
  playlist("Playlist", true, [song], DownloadItemType.collection),
  genre("MusicGenre", true, [album, song], DownloadItemType.collection),
  song("Audio", false, [], DownloadItemType.song),
  library("CollectionFolder", true, [album, song], DownloadItemType.collection),
  folder("Folder", true, null, DownloadItemType.collection),
  musicVideo("MusicVideo", false, [], DownloadItemType.song),
  audioBook("AudioBook", false, [], DownloadItemType.song),
  tvEpisode("Episode", false, [], DownloadItemType.song),
  video("Video", false, [], DownloadItemType.song),
  movie("Movie", false, [], DownloadItemType.song),
  trailer("Trailer", false, [], DownloadItemType.song),
  unknown(null, true, null, DownloadItemType.collection);

  // All possible types in Jellyfin as of 10.9:
  //"AggregateFolder" "Audio" "AudioBook" "BasePluginFolder" "Book" "BoxSet"
  // "Channel" "ChannelFolderItem" "CollectionFolder" "Episode" "Folder" "Genre"
  // "ManualPlaylistsFolder" "Movie" "LiveTvChannel" "LiveTvProgram" "MusicAlbum"
  // "MusicArtist" "MusicGenre" "MusicVideo" "Person" "Photo" "PhotoAlbum" "Playlist"
  // "PlaylistsFolder" "Program" "Recording" "Season" "Series" "Studio" "Trailer" "TvChannel"
  // "TvProgram" "UserRootFolder" "UserView" "Video" "Year"

  const BaseItemDtoType(
      this.idString, this.expectChanges, this.childTypes, this.downloadType);

  final String? idString;
  final bool expectChanges;
  final List<BaseItemDtoType>? childTypes;
  final DownloadItemType? downloadType;

  bool get expectChangesInChildren =>
      childTypes?.any((x) => x.expectChanges) ?? true;

  // BaseItemDto types that we handle like songs have been handled by returning
  // the actual song type.  This may be a bad ides?
  static BaseItemDtoType fromItem(BaseItemDto item) {
    switch (item.type) {
      case "Audio":
      case "AudioBook":
      case "MusicVideo":
      case "Episode":
      case "Video":
      case "Movie":
      case "Trailer":
        return song;
      case "MusicAlbum":
        return album;
      case "MusicArtist":
        return artist;
      case "MusicGenre":
        return genre;
      case "Playlist":
        return playlist;
      case "CollectionFolder":
        return library;
      case "Folder":
        return folder;
      default:
        return unknown;
    }
  }
}

@HiveType(typeId: 43)
class OfflineListen {
  OfflineListen({
    required this.timestamp,
    required this.userId,
    required this.itemId,
    required this.name,
    this.artist,
    this.album,
    this.trackMbid,
    this.deviceInfo,
  });

  /// The stop timestamp of the listen, measured in seconds since the epoch.
  @HiveField(0)
  int timestamp;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String itemId;

  @HiveField(3)
  String name;

  @HiveField(4)
  String? artist;

  @HiveField(5)
  String? album;

  // The MusicBrainz ID of the track, if available.
  @HiveField(6)
  String? trackMbid;

  @HiveField(7)
  DeviceInfo? deviceInfo;
}

@HiveType(typeId: 50)
enum FinampPlaybackOrder {
  @HiveField(0)
  shuffled,
  @HiveField(1)
  linear;
}

@HiveType(typeId: 51)
enum FinampLoopMode {
  @HiveField(0)
  none,
  @HiveField(1)
  one,
  @HiveField(2)
  all;
}

@HiveType(typeId: 52)
enum QueueItemSourceType {
  @HiveField(0)
  album,
  @HiveField(1)
  playlist,
  @HiveField(2)
  songMix,
  @HiveField(3)
  artistMix,
  @HiveField(4)
  albumMix,
  @HiveField(5)
  favorites,
  @HiveField(6)
  allSongs,
  @HiveField(7)
  filteredList,
  @HiveField(8)
  genre,
  @HiveField(9)
  artist,
  @HiveField(10)
  nextUp,
  @HiveField(11)
  nextUpAlbum,
  @HiveField(12)
  nextUpPlaylist,
  @HiveField(13)
  nextUpArtist,
  @HiveField(14)
  formerNextUp,
  @HiveField(15)
  downloads,
  @HiveField(16)
  queue,
  @HiveField(17)
  unknown,
  @HiveField(18)
  genreMix,
  @HiveField(19)
  song;
}

@HiveType(typeId: 53)
enum QueueItemQueueType {
  @HiveField(0)
  previousTracks,
  @HiveField(1)
  currentTrack,
  @HiveField(2)
  nextUp,
  @HiveField(3)
  queue;
}

@HiveType(typeId: 54)
class QueueItemSource {
  QueueItemSource({
    required this.type,
    required this.name,
    required this.id,
    this.item,
    this.contextNormalizationGain,
  });

  @HiveField(0)
  QueueItemSourceType type;

  @HiveField(1)
  QueueItemSourceName name;

  @HiveField(2)
  String id;

  @HiveField(3)
  BaseItemDto? item;

  @HiveField(4)
  double? contextNormalizationGain;
}

@HiveType(typeId: 55)
enum QueueItemSourceNameType {
  @HiveField(0)
  preTranslated,
  @HiveField(1)
  yourLikes,
  @HiveField(2)
  shuffleAll,
  @HiveField(3)
  mix,
  @HiveField(4)
  instantMix,
  @HiveField(5)
  nextUp,
  @HiveField(6)
  tracksFormerNextUp,
  @HiveField(7)
  savedQueue,
  @HiveField(8)
  queue,
}

@HiveType(typeId: 56)
class QueueItemSourceName {
  const QueueItemSourceName({
    required this.type,
    this.pretranslatedName,
    this.localizationParameter, // used if only part of the name is translated
  });

  @HiveField(0)
  final QueueItemSourceNameType type;
  @HiveField(1)
  final String? pretranslatedName;
  @HiveField(2)
  final String? localizationParameter;

  getLocalized(BuildContext context) {
    switch (type) {
      case QueueItemSourceNameType.preTranslated:
        return pretranslatedName ?? "";
      case QueueItemSourceNameType.yourLikes:
        return AppLocalizations.of(context)!.yourLikes;
      case QueueItemSourceNameType.shuffleAll:
        return AppLocalizations.of(context)!.shuffleAllQueueSource;
      case QueueItemSourceNameType.mix:
        return AppLocalizations.of(context)!.mix(localizationParameter ?? "");
      case QueueItemSourceNameType.instantMix:
        return AppLocalizations.of(context)!.instantMix;
      case QueueItemSourceNameType.nextUp:
        return AppLocalizations.of(context)!.nextUp;
      case QueueItemSourceNameType.tracksFormerNextUp:
        return AppLocalizations.of(context)!.tracksFormerNextUp;
      case QueueItemSourceNameType.savedQueue:
        return AppLocalizations.of(context)!.savedQueue;
      case QueueItemSourceNameType.queue:
        return AppLocalizations.of(context)!.queue;
    }
  }
}

@HiveType(typeId: 57)
class FinampQueueItem {
  FinampQueueItem({
    required this.item,
    required this.source,
    this.type = QueueItemQueueType.queue,
  }) {
    id = const Uuid().v4();
  }

  @HiveField(0)
  late String id;

  @HiveField(1)
  MediaItem item;

  @HiveField(2)
  QueueItemSource source;

  @HiveField(3)
  QueueItemQueueType type;

  BaseItemDto? get baseItem {
    return (item.extras?["itemJson"] != null)
        ? BaseItemDto.fromJson(item.extras!["itemJson"] as Map<String, dynamic>)
        : null;
  }
}

@HiveType(typeId: 58)
class FinampQueueOrder {
  FinampQueueOrder({
    required this.items,
    required this.originalSource,
    required this.linearOrder,
    required this.shuffledOrder,
  }) {
    id = const Uuid().v4();
  }

  @HiveField(0)
  List<FinampQueueItem> items;

  @HiveField(1)
  QueueItemSource originalSource;

  /// The linear order of the items in the queue. Used when shuffle is disabled.
  /// The integers at index x contains the index of the item within [items] at queue position x.
  @HiveField(2)
  List<int> linearOrder;

  /// The shuffled order of the items in the queue. Used when shuffle is enabled.
  /// The integers at index x contains the index of the item within [items] at queue position x.
  @HiveField(3)
  List<int> shuffledOrder;

  @HiveField(4)
  late String id;
}

@HiveType(typeId: 59)
class FinampQueueInfo {
  FinampQueueInfo({
    required this.id,
    required this.previousTracks,
    required this.currentTrack,
    required this.nextUp,
    required this.queue,
    required this.source,
    required this.saveState,
  });

  @HiveField(0)
  List<FinampQueueItem> previousTracks;

  @HiveField(1)
  FinampQueueItem? currentTrack;

  @HiveField(2)
  List<FinampQueueItem> nextUp;

  @HiveField(3)
  List<FinampQueueItem> queue;

  @HiveField(4)
  QueueItemSource source;

  @HiveField(5)
  SavedQueueState saveState;

  @HiveField(6)
  String id;

  int get currentTrackIndex =>
      previousTracks.length + (currentTrack == null ? 0 : 1);
  int get remainingTrackCount => nextUp.length + queue.length;
  int get trackCount => currentTrackIndex + remainingTrackCount;

  /// Remaining duration of queue.  Does not consider position in current track.
  Duration get remainingDuration {
    var remaining = 0;
    for (var item in CombinedIterableView([nextUp, queue])) {
      remaining += item.item.duration?.inMicroseconds ?? 0;
    }
    return Duration(microseconds: remaining);
  }

  Duration get totalDuration {
    var total = 0;
    for (var item in CombinedIterableView([
      previousTracks,
      [currentTrack],
      nextUp,
      queue
    ])) {
      total += item?.item.duration?.inMicroseconds ?? 0;
    }
    return Duration(microseconds: total);
  }
}

@HiveType(typeId: 60)
class FinampHistoryItem {
  FinampHistoryItem({
    required this.item,
    required this.startTime,
    this.endTime,
  });

  @HiveField(0)
  FinampQueueItem item;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  DateTime? endTime;
}

@HiveType(typeId: 61)
class FinampStorableQueueInfo {
  FinampStorableQueueInfo({
    required this.previousTracks,
    required this.currentTrack,
    required this.currentTrackSeek,
    required this.nextUp,
    required this.queue,
    required this.creation,
    required this.source,
  });

  FinampStorableQueueInfo.fromQueueInfo(FinampQueueInfo info, int? seek)
      : previousTracks = info.previousTracks
            .map<String>((track) => track.item.extras?["itemJson"]["Id"])
            .toList(),
        currentTrack = info.currentTrack?.item.extras?["itemJson"]["Id"],
        currentTrackSeek = seek,
        nextUp = info.nextUp
            .map<String>((track) => track.item.extras?["itemJson"]["Id"])
            .toList(),
        queue = info.queue
            .map<String>((track) => track.item.extras?["itemJson"]["Id"])
            .toList(),
        creation = DateTime.now().millisecondsSinceEpoch,
        source = info.source;

  @HiveField(0)
  List<String> previousTracks;

  @HiveField(1)
  String? currentTrack;

  @HiveField(2)
  int? currentTrackSeek;

  @HiveField(3)
  List<String> nextUp;

  @HiveField(4)
  List<String> queue;

  @HiveField(5)
  // timestamp, milliseconds since epoch
  int creation;

  @HiveField(6)
  QueueItemSource? source;

  @override
  String toString() {
    return "previous:$previousTracks current:$currentTrack seek:$currentTrackSeek next:$nextUp queue:$queue";
  }

  int get songCount {
    return previousTracks.length +
        ((currentTrack == null) ? 0 : 1) +
        nextUp.length +
        queue.length;
  }
}

@HiveType(typeId: 62)
enum SavedQueueState {
  @HiveField(0)
  preInit,
  @HiveField(1)
  init,
  @HiveField(2)
  loading,
  @HiveField(3)
  saving,
  @HiveField(4)
  failed,
  @HiveField(5)
  pendingSave,
}

@HiveType(typeId: 63)

/// Describes which mode will be used for loudness normalization.
enum VolumeNormalizationMode {
  /// Use track normalization gain if playing unrelated tracks, use album normalization gain if playing albums
  @HiveField(0)
  hybrid,

  /// Use track normalization gain regardless of context
  @HiveField(1)
  trackBased,

  /// Only normalize if playing albums
  @HiveField(2)
  albumOnly,
}

@HiveType(typeId: 64)
enum DownloadLocationType {
  @HiveField(0)
  internalDocuments(false, false, BaseDirectory.applicationDocuments),
  @HiveField(1)
  internalSupport(false, false, BaseDirectory.applicationSupport),
  @HiveField(2)
  external(true, false, BaseDirectory.root),
  @HiveField(3)
  custom(true, true, BaseDirectory.root),
  @HiveField(4)
  none(false, false, BaseDirectory.root),
  @HiveField(5)
  migrated(true, false, BaseDirectory.root),
  @HiveField(6)
  cache(false, false, BaseDirectory.root);

  const DownloadLocationType(
      this.needsPath, this.useHumanReadableNames, this.baseDirectory);

  /// true if the download location path must be supplied in the constructer,
  /// false if it is calculated from the baseDirectory
  final bool needsPath;
  final bool useHumanReadableNames;
  final BaseDirectory baseDirectory;
}

@HiveType(typeId: 65)
enum FinampTranscodingCodec {
  @HiveField(0)
  aac("aac", true, 1.2),
  @HiveField(1)
  mp3("mp3", true, 1.0),
  @HiveField(2)
  opus("ogg", false, 2.0),
  @HiveField(3)
  // Container is null to fall back to real original container per song
  original(null, true, 99999999);

  const FinampTranscodingCodec(
      this.container, this.iosCompatible, this.quality);

  /// The container to use for the given codec
  final String? container;

  final bool iosCompatible;

  /// Allowed codecs with higher quality*bitrate are prioritized
  final double quality;
}

@embedded
class DownloadProfile {
  DownloadProfile({
    FinampTranscodingCodec? transcodeCodec,
    int? bitrate,
    this.downloadLocationId,
  }) {
    codec = transcodeCodec ??
        (Platform.isIOS || Platform.isMacOS
            ? FinampTranscodingCodec.aac
            : FinampTranscodingCodec.opus);
    stereoBitrate =
        bitrate ?? (Platform.isIOS || Platform.isMacOS ? 256000 : 128000);
  }

  /// The codec to use for the given transcoding job
  @Enumerated(EnumType.ordinal)
  late FinampTranscodingCodec codec;

  /// The bitrate of the file, in bits per second (i.e. 320000 for 320kbps).
  /// This bitrate is used for stereo, use [bitrateChannels] to get a
  /// channel-dependent bitrate.  Should be ignored if codec is original.
  late int stereoBitrate;

  String? downloadLocationId;

  /// [bitrate], but multiplied to handle multiple channels. The current
  /// implementation returns the unmodified bitrate if [channels] is 2 or below
  /// (stereo/mono), doubles it if under 6, and triples it otherwise. This
  /// *should* handle the 5.1/7.1 case, apologies if you're reading this after
  /// wondering why your cinema-grade ∞-channel song sounds terrible when
  /// transcoded.
  int bitrateChannels(int channels) {
    // If stereo/mono, return the base bitrate
    if (channels <= 2) {
      return stereoBitrate;
    }

    // If 5.1, return the bitrate doubled
    if (channels <= 6) {
      return stereoBitrate * 2;
    }

    // Otherwise, triple the bitrate
    return stereoBitrate * 3;
  }

  @ignore
  String get bitrateKbps => "${stereoBitrate ~/ 1000}kbps";

  @ignore
  double get quality => codec == FinampTranscodingCodec.original
      ? 9999999999999
      : codec.quality * stereoBitrate;

  @override
  bool operator ==(Object other) {
    return other is DownloadProfile &&
        (codec == FinampTranscodingCodec.original ||
            other.stereoBitrate == stereoBitrate) &&
        other.codec == codec &&
        other.downloadLocationId == downloadLocationId;
  }

  @override
  @ignore
  int get hashCode => Object.hash(
      codec == FinampTranscodingCodec.original ? 0 : stereoBitrate,
      codec,
      downloadLocationId);
}

@HiveType(typeId: 66)
enum TranscodeDownloadsSetting {
  @HiveField(0)
  always,
  @HiveField(1)
  never,
  @HiveField(2)
  ask;
}

/// TODO
@collection
class DownloadedLyrics {
  DownloadedLyrics({
    required this.jsonItem,
    required this.isarId,
  });

  factory DownloadedLyrics.fromItem({
    required LyricDto item,
    required int isarId,
  }) {
    return DownloadedLyrics(
      isarId: isarId,
      jsonItem: jsonEncode(item.toJson()),
    );
  }

  /// The integer ID used as a database key by Isar
  final Id isarId;

  /// The LyricDto as a JSON string for storage in isar.
  /// Use [lyricDto] to retrieve.
  final String? jsonItem;

  @ignore
  LyricDto? get lyricDto => _lyricDtoCached ??=
      ((jsonItem == null) ? null : LyricDto.fromJson(jsonDecode(jsonItem!)));
  @ignore
  LyricDto? _lyricDtoCached;
}

@HiveType(typeId: 67)
enum PlaybackSpeedVisibility {
  @HiveField(0)
  automatic,
  @HiveField(1)
  visible,
  @HiveField(2)
  hidden;

  /// Human-readable version of this enum. I've written longer descriptions on
  /// enums like [TabContentType], and I can't be bothered to copy and paste it
  /// again.
  @override
  @Deprecated("Use toLocalisedString when possible")
  String toString() => _humanReadableName(this);

  String toLocalisedString(BuildContext context) =>
      _humanReadableLocalisedName(this, context);

  String _humanReadableName(PlaybackSpeedVisibility playbackSpeedVisibility) {
    switch (playbackSpeedVisibility) {
      case PlaybackSpeedVisibility.automatic:
        return "Automatic";
      case PlaybackSpeedVisibility.visible:
        return "On";
      case PlaybackSpeedVisibility.hidden:
        return "Off";
    }
  }

  String _humanReadableLocalisedName(
      PlaybackSpeedVisibility playbackSpeedVisibility, BuildContext context) {
    switch (playbackSpeedVisibility) {
      case PlaybackSpeedVisibility.automatic:
        return AppLocalizations.of(context)!.automatic;
      case PlaybackSpeedVisibility.visible:
        return AppLocalizations.of(context)!.shown;
      case PlaybackSpeedVisibility.hidden:
        return AppLocalizations.of(context)!.hidden;
    }
  }
}

enum FinampCollectionType {
  favorites,
  allPlaylists,
  latest5Albums,
  libraryImages,
  allPlaylistsMetadata;
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
  includeIfNull: false,
)
class FinampCollection {
  FinampCollection({required this.type, this.library}) {
    assert(type == FinampCollectionType.libraryImages || library == null);
    assert(type != FinampCollectionType.libraryImages || library != null);
  }

  final FinampCollectionType type;
  final BaseItemDto? library;

  String get id => switch (type) {
        FinampCollectionType.favorites => "Favorites",
        FinampCollectionType.allPlaylists => "All Playlists",
        FinampCollectionType.latest5Albums => "5 Latest Albums",
        FinampCollectionType.libraryImages =>
          "Cache Library Images:${library!.id}",
        FinampCollectionType.allPlaylistsMetadata => "All Playlists Metadata",
      };

  String getName(BuildContext context) => switch (type) {
        FinampCollectionType.favorites =>
          AppLocalizations.of(context)!.finampCollectionNames("favorites"),
        FinampCollectionType.allPlaylists =>
          AppLocalizations.of(context)!.finampCollectionNames("allPlaylists"),
        FinampCollectionType.latest5Albums => AppLocalizations.of(context)!
            .finampCollectionNames("fiveLatestAlbums"),
        FinampCollectionType.libraryImages => AppLocalizations.of(context)!
            .cacheLibraryImagesName(library!.name ?? ""),
        FinampCollectionType.allPlaylistsMetadata =>
          AppLocalizations.of(context)!
              .finampCollectionNames("allPlaylistsMetadata"),
      };

  factory FinampCollection.fromJson(Map<String, dynamic> json) =>
      _$FinampCollectionFromJson(json);
  Map<String, dynamic> toJson() => _$FinampCollectionToJson(this);
}

@HiveType(typeId: 68)
enum MediaItemParentType {
  @HiveField(0)
  collection,
  @HiveField(1)
  rootCollection,
  @HiveField(2)
  instantMix,
}

@JsonSerializable()
@HiveType(typeId: 69)
class MediaItemId {
  MediaItemId({
    required this.contentType,
    required this.parentType,
    this.itemId,
    this.parentId,
  });

  @HiveField(0)
  TabContentType contentType;

  @HiveField(1)
  MediaItemParentType parentType;

  @HiveField(2)
  String? itemId;

  @HiveField(3)
  String? parentId;

  factory MediaItemId.fromJson(Map<String, dynamic> json) =>
      _$MediaItemIdFromJson(json);

  Map<String, dynamic> toJson() => _$MediaItemIdToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

@HiveType(typeId: 70)
enum LyricsAlignment {
  @HiveField(0)
  start,
  @HiveField(1)
  center,
  @HiveField(2)
  end;

  /// Human-readable version of the [LyricsAlignment]
  @override
  @Deprecated("Use toLocalisedString when possible")
  String toString() => _humanReadableName(this);

  String toLocalisedString(BuildContext context) =>
      _humanReadableLocalisedName(this, context);

  String _humanReadableName(LyricsAlignment lyricsAlignment) {
    switch (lyricsAlignment) {
      case LyricsAlignment.start:
        return "Start";
      case LyricsAlignment.center:
        return "Center";
      case LyricsAlignment.end:
        return "End";
    }
  }

  String _humanReadableLocalisedName(
      LyricsAlignment lyricsAlignment, BuildContext context) {
    switch (lyricsAlignment) {
      case LyricsAlignment.start:
        return AppLocalizations.of(context)!.alignmentOptionStart;
      case LyricsAlignment.center:
        return AppLocalizations.of(context)!.alignmentOptionCenter;
      case LyricsAlignment.end:
        return AppLocalizations.of(context)!.alignmentOptionEnd;
    }
  }
}

@HiveType(typeId: 71)
enum LyricsFontSize {
  @HiveField(0)
  small,
  @HiveField(1)
  medium,
  @HiveField(2)
  large;

  /// Human-readable version of the [LyricsFontSize]
  @override
  @Deprecated("Use toLocalisedString when possible")
  String toString() => _humanReadableName(this);

  String toLocalisedString(BuildContext context) =>
      _humanReadableLocalisedName(this, context);

  String _humanReadableName(LyricsFontSize lyricsFontSize) {
    switch (lyricsFontSize) {
      case LyricsFontSize.small:
        return "Small";
      case LyricsFontSize.medium:
        return "Medium";
      case LyricsFontSize.large:
        return "Large";
    }
  }

  String _humanReadableLocalisedName(
      LyricsFontSize lyricsFontSize, BuildContext context) {
    switch (lyricsFontSize) {
      case LyricsFontSize.small:
        return AppLocalizations.of(context)!.fontSizeOptionSmall;
      case LyricsFontSize.medium:
        return AppLocalizations.of(context)!.fontSizeOptionMedium;
      case LyricsFontSize.large:
        return AppLocalizations.of(context)!.fontSizeOptionLarge;
    }
  }
}

@HiveType(typeId: 72)
enum KeepScreenOnOption {
  @HiveField(0)
  disabled,
  @HiveField(1)
  alwaysOn,
  @HiveField(2)
  whilePlaying,
  @HiveField(3)
  whileLyrics;

  /// Human-readable version of this enum. I've written longer descriptions on
  /// enums like [TabContentType], and I can't be bothered to copy and paste it
  /// again.
  @override
  @Deprecated("Use toLocalisedString when possible")
  String toString() => _humanReadableName(this);

  String toLocalisedString(BuildContext context) =>
      _humanReadableLocalisedName(this, context);

  String _humanReadableName(KeepScreenOnOption keepScreenOnOption) {
    switch (keepScreenOnOption) {
      case KeepScreenOnOption.disabled:
        return "Disabled";
      case KeepScreenOnOption.alwaysOn:
        return "Always On";
      case KeepScreenOnOption.whilePlaying:
        return "While Playing Music";
      case KeepScreenOnOption.whileLyrics:
        return "While Showing Lyrics";
    }
  }

  String _humanReadableLocalisedName(
      KeepScreenOnOption keepScreenOnOption, BuildContext context) {
    switch (keepScreenOnOption) {
      case KeepScreenOnOption.disabled:
        return AppLocalizations.of(context)!.keepScreenOnDisabled;
      case KeepScreenOnOption.alwaysOn:
        return AppLocalizations.of(context)!.keepScreenOnAlwaysOn;
      case KeepScreenOnOption.whilePlaying:
        return AppLocalizations.of(context)!.keepScreenOnWhilePlaying;
      case KeepScreenOnOption.whileLyrics:
        return AppLocalizations.of(context)!.keepScreenOnWhileLyrics;
    }
  }
}

@HiveType(typeId: 73)
enum FinampSegmentContainer {
  @HiveField(0)
  mpegTS("ts"),
  @HiveField(1)
  fragmentedMp4("mp4");

  const FinampSegmentContainer(this.container);

  /// The container to use to transport the segments
  final String container;
}

@HiveType(typeId: 74)
enum FinampFeatureChipType {
  @HiveField(0)
  playCount,
  @HiveField(1)
  additionalPeople,
  @HiveField(2)
  playbackMode,
  @HiveField(3)
  codec,
  @HiveField(4)
  bitRate,
  @HiveField(5)
  bitDepth,
  @HiveField(6)
  size,
  @HiveField(7)
  normalizationGain,
  @HiveField(8)
  sampleRate;

  /// Human-readable version of the [FinampFeatureChipType]
  @override
  @Deprecated("Use toLocalisedString when possible")
  String toString() => _humanReadableName(this);

  String toLocalisedString(BuildContext context) =>
      _humanReadableLocalisedName(this, context);

  String _humanReadableName(FinampFeatureChipType featureChipType) {
    switch (featureChipType) {
      case FinampFeatureChipType.playCount:
        return "Play Count";
      case FinampFeatureChipType.additionalPeople:
        return "Additional People";
      case FinampFeatureChipType.playbackMode:
        return "Playback Mode";
      case FinampFeatureChipType.codec:
        return "codec";
      case FinampFeatureChipType.bitRate:
        return "Bit Rate";
      case FinampFeatureChipType.bitDepth:
        return "Bit Depth";
      case FinampFeatureChipType.size:
        return "size";
      case FinampFeatureChipType.normalizationGain:
        return "Normalization Gain";
      case FinampFeatureChipType.sampleRate:
        return "Sample Rate";
    }
  }

  String _humanReadableLocalisedName(
      FinampFeatureChipType featureChipType, BuildContext context) {
    switch (featureChipType) {
      case FinampFeatureChipType.playCount:
        return AppLocalizations.of(context)!.playCount;
      case FinampFeatureChipType.additionalPeople:
        return AppLocalizations.of(context)!.additionalPeople;
      case FinampFeatureChipType.playbackMode:
        return AppLocalizations.of(context)!.playbackMode;
      case FinampFeatureChipType.codec:
        return AppLocalizations.of(context)!.codec;
      case FinampFeatureChipType.bitRate:
        return AppLocalizations.of(context)!.bitRate;
      case FinampFeatureChipType.bitDepth:
        return AppLocalizations.of(context)!.bitDepth;
      case FinampFeatureChipType.size:
        return AppLocalizations.of(context)!.size;
      case FinampFeatureChipType.normalizationGain:
        return AppLocalizations.of(context)!.normalizationGain;
      case FinampFeatureChipType.sampleRate:
        return AppLocalizations.of(context)!.sampleRate;
    }
  }
}

@JsonSerializable()
@HiveType(typeId: 75)
class FinampFeatureChipsConfiguration {
  const FinampFeatureChipsConfiguration({
    required this.enabled,
    required this.features,
  });

  @HiveField(0)
  final bool enabled;

  @HiveField(1)
  final List<FinampFeatureChipType> features;

  factory FinampFeatureChipsConfiguration.fromJson(Map<String, dynamic> json) =>
      _$FinampFeatureChipsConfigurationFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FinampFeatureChipsConfigurationToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  // implement copyWith
  FinampFeatureChipsConfiguration copyWith({
    bool? enabled,
    List<FinampFeatureChipType>? features,
  }) {
    return FinampFeatureChipsConfiguration(
      enabled: enabled ?? this.enabled,
      features: features ?? this.features,
    );
  }
}


@HiveType(typeId: 76)
class DeviceInfo {
  DeviceInfo({
    required this.name,
    required this.id,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String? id;
}
