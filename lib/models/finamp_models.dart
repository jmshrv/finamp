import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:collection/collection.dart';
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

// These consts are so that we can easily keep the same default for
// FinampSettings's constructor and Hive's defaultValue.
const _isOfflineDefault = false;
const _shouldTranscodeDefault = false;
const _transcodeBitrateDefault = 320000;
const _androidStopForegroundOnPauseDefault = false;
const _isFavouriteDefault = false;
const _songShuffleItemCountDefault = 250;
const _replayGainActiveDefault = true;
// 3/4 volume in dB. In my testing, most tracks were louder than the default target
// of -14.0 LUFS, so the gain rarely needed to be increased. -5.0 gives us a bit of
// headroom in case we need to boost a track (since volume can't go above 1.0),
// without reducing the volume too much.
const _replayGainIOSBaseGainDefault = -5.0;
const _replayGainTargetLufsDefault = -14.0;
const _replayGainNormalizationFactorDefault = 1.0;
const _replayGainModeDefault = ReplayGainMode.hybrid;
const _contentViewType = ContentViewType.list;
const _contentGridViewCrossAxisCountPortrait = 2;
const _contentGridViewCrossAxisCountLandscape = 3;
const _showTextOnGridView = true;
const _sleepTimerSeconds = 1800; // 30 Minutes
const _useCoverAsBackground = true;
const _playerScreenCoverMinimumPadding = 1.5;
const _hideSongArtistsIfSameAsAlbumArtists = true;
const _showArtistsTopSongs = true;
const _disableGesture = false;
const _showFastScroller = true;
const _bufferDurationSeconds = 600;
const _tabOrder = TabContentType.values;
const _swipeInsertQueueNext = true;
const _defaultLoopMode = FinampLoopMode.none;
const _autoLoadLastQueueOnStartup = true;
const _shouldTranscodeDownloadsDefault = TranscodeDownloadsSetting.never;
const _shouldRedownloadTranscodesDefault = false;
const _defaultResyncOnStartup = true;
const _enableVibration = true;
const _prioritizeCoverFactor = 8.0;
const _suppressPlayerPadding = false;
const _hideQueueButton = false;
const _reportQueueToServerDefault = false;
const _periodicPlaybackSessionUpdateFrequencySecondsDefault = 150;
const _showArtistChipImage = true;

@HiveType(typeId: 28)
class FinampSettings {
  FinampSettings({
    this.isOffline = _isOfflineDefault,
    this.shouldTranscode = _shouldTranscodeDefault,
    this.transcodeBitrate = _transcodeBitrateDefault,
    // downloadLocations is required since the other values can be created with
    // default values. create() is used to return a FinampSettings with
    // downloadLocations.
    required this.downloadLocations,
    this.androidStopForegroundOnPause = _androidStopForegroundOnPauseDefault,
    required this.showTabs,
    this.onlyShowFavourite = _isFavouriteDefault,
    this.sortBy = SortBy.sortName,
    this.sortOrder = SortOrder.ascending,
    this.songShuffleItemCount = _songShuffleItemCountDefault,
    this.replayGainActive = _replayGainActiveDefault,
    this.replayGainIOSBaseGain = _replayGainIOSBaseGainDefault,
    this.replayGainTargetLufs = _replayGainTargetLufsDefault,
    this.replayGainNormalizationFactor = _replayGainNormalizationFactorDefault,
    this.replayGainMode = _replayGainModeDefault,
    this.contentViewType = _contentViewType,
    this.contentGridViewCrossAxisCountPortrait =
        _contentGridViewCrossAxisCountPortrait,
    this.contentGridViewCrossAxisCountLandscape =
        _contentGridViewCrossAxisCountLandscape,
    this.showTextOnGridView = _showTextOnGridView,
    this.sleepTimerSeconds = _sleepTimerSeconds,
    required this.downloadLocationsMap,
    this.useCoverAsBackground = _useCoverAsBackground,
    this.playerScreenCoverMinimumPadding = _playerScreenCoverMinimumPadding,
    this.hideSongArtistsIfSameAsAlbumArtists =
        _hideSongArtistsIfSameAsAlbumArtists,
    this.showArtistsTopSongs = _showArtistsTopSongs,
    this.bufferDurationSeconds = _bufferDurationSeconds,
    required this.tabSortBy,
    required this.tabSortOrder,
    this.loopMode = _defaultLoopMode,
    this.tabOrder = _tabOrder,
    this.autoloadLastQueueOnStartup = _autoLoadLastQueueOnStartup,
    this.hasCompletedBlurhashImageMigration = true,
    this.hasCompletedBlurhashImageMigrationIdFix = true,
    this.hasCompleteddownloadsServiceMigration = true,
    this.requireWifiForDownloads = false,
    this.onlyShowFullyDownloaded = false,
    this.showDownloadsWithUnknownLibrary = true,
    this.maxConcurrentDownloads = 10,
    this.downloadWorkers = 5,
    this.resyncOnStartup = _defaultResyncOnStartup,
    this.preferQuickSyncs = true,
    this.hasCompletedIsarUserMigration = true,
    this.downloadTranscodingCodec,
    this.downloadTranscodeBitrate,
    this.shouldTranscodeDownloads = _shouldTranscodeDownloadsDefault,
    this.shouldRedownloadTranscodes = _shouldRedownloadTranscodesDefault,
    this.swipeInsertQueueNext = _swipeInsertQueueNext,
    this.enableVibration = _enableVibration,
    this.prioritizeCoverFactor = _prioritizeCoverFactor,
    this.suppressPlayerPadding = _suppressPlayerPadding,
    this.hideQueueButton = _hideQueueButton,
    this.reportQueueToServer = _reportQueueToServerDefault,
    this.periodicPlaybackSessionUpdateFrequencySeconds =
        _periodicPlaybackSessionUpdateFrequencySecondsDefault,
    this.showArtistChipImage = _showArtistChipImage,
  });

  @HiveField(0, defaultValue: _isOfflineDefault)
  bool isOffline;
  @HiveField(1, defaultValue: _shouldTranscodeDefault)
  bool shouldTranscode;
  @HiveField(2, defaultValue: _transcodeBitrateDefault)
  int transcodeBitrate;

  @Deprecated("Use downloadedLocationsMap instead")
  @HiveField(3)
  List<DownloadLocation> downloadLocations;

  @HiveField(4, defaultValue: _androidStopForegroundOnPauseDefault)
  bool androidStopForegroundOnPause;
  @HiveField(5)
  Map<TabContentType, bool> showTabs;

  /// Used to remember if the user has set their music screen to favourites
  /// mode.
  @HiveField(6, defaultValue: _isFavouriteDefault)
  bool onlyShowFavourite;

  /// Current sort by setting.
  @Deprecated("Use per-tab sort by instead")
  @HiveField(7)
  SortBy sortBy;

  /// Current sort order setting.
  @Deprecated("Use per-tab sort order instead")
  @HiveField(8)
  SortOrder sortOrder;

  /// Amount of songs to get when shuffling songs.
  @HiveField(9, defaultValue: _songShuffleItemCountDefault)
  int songShuffleItemCount;

  /// The content view type used by the music screen.
  @HiveField(10, defaultValue: _contentViewType)
  ContentViewType contentViewType;

  /// Amount of grid tiles to use per-row when portrait.
  @HiveField(11, defaultValue: _contentGridViewCrossAxisCountPortrait)
  int contentGridViewCrossAxisCountPortrait;

  /// Amount of grid tiles to use per-row when landscape.
  @HiveField(12, defaultValue: _contentGridViewCrossAxisCountLandscape)
  int contentGridViewCrossAxisCountLandscape;

  /// Whether or not to show the text (title, artist etc) on the grid music
  /// screen.
  @HiveField(13, defaultValue: _showTextOnGridView)
  bool showTextOnGridView = _showTextOnGridView;

  /// The number of seconds to wait in a sleep timer. This is so that the app
  /// can remember the last duration. I'd use a Duration type here but Hive
  /// doesn't come with an adapter for it by default.
  @HiveField(14, defaultValue: _sleepTimerSeconds)
  int sleepTimerSeconds;

  @HiveField(15, defaultValue: {})
  Map<String, DownloadLocation> downloadLocationsMap;

  /// Whether or not to use blurred cover art as background on player screen.
  @HiveField(16, defaultValue: _useCoverAsBackground)
  bool useCoverAsBackground = _useCoverAsBackground;

  @HiveField(17, defaultValue: _hideSongArtistsIfSameAsAlbumArtists)
  bool hideSongArtistsIfSameAsAlbumArtists =
      _hideSongArtistsIfSameAsAlbumArtists;

  @HiveField(18, defaultValue: _bufferDurationSeconds)
  int bufferDurationSeconds;

  @HiveField(19, defaultValue: _disableGesture)
  bool disableGesture = _disableGesture;

  @HiveField(20, defaultValue: {})
  Map<TabContentType, SortBy> tabSortBy;

  @HiveField(21, defaultValue: {})
  Map<TabContentType, SortOrder> tabSortOrder;

  @HiveField(22, defaultValue: _tabOrder)
  List<TabContentType> tabOrder;

  @HiveField(23, defaultValue: false)
  bool hasCompletedBlurhashImageMigration;

  @HiveField(24, defaultValue: false)
  bool hasCompletedBlurhashImageMigrationIdFix;

  @HiveField(25, defaultValue: _showFastScroller)
  bool showFastScroller = _showFastScroller;

  @HiveField(26, defaultValue: _swipeInsertQueueNext)
  bool swipeInsertQueueNext;

  @HiveField(27, defaultValue: _defaultLoopMode)
  FinampLoopMode loopMode;

  @HiveField(28, defaultValue: _autoLoadLastQueueOnStartup)
  bool autoloadLastQueueOnStartup;

  @HiveField(29, defaultValue: _replayGainActiveDefault)
  bool replayGainActive;

  @HiveField(30, defaultValue: _replayGainIOSBaseGainDefault)
  double replayGainIOSBaseGain;

  @HiveField(31, defaultValue: _replayGainTargetLufsDefault)
  double replayGainTargetLufs;

  @HiveField(32, defaultValue: _replayGainNormalizationFactorDefault)
  double replayGainNormalizationFactor;

  @HiveField(33, defaultValue: _replayGainModeDefault)
  ReplayGainMode replayGainMode;

  @HiveField(34, defaultValue: false)
  bool hasCompleteddownloadsServiceMigration;

  @HiveField(35, defaultValue: false)
  bool requireWifiForDownloads;

  @HiveField(36, defaultValue: false)
  bool onlyShowFullyDownloaded;

  @HiveField(37, defaultValue: true)
  bool showDownloadsWithUnknownLibrary;

  @HiveField(38, defaultValue: 10)
  int maxConcurrentDownloads;

  @HiveField(39, defaultValue: 5)
  int downloadWorkers;

  @HiveField(40, defaultValue: _defaultResyncOnStartup)
  bool resyncOnStartup;

  @HiveField(41, defaultValue: true)
  bool preferQuickSyncs;

  @HiveField(42, defaultValue: false)
  bool hasCompletedIsarUserMigration;

  @HiveField(43)
  FinampTranscodingCodec? downloadTranscodingCodec;

  @HiveField(44, defaultValue: _shouldTranscodeDownloadsDefault)
  TranscodeDownloadsSetting shouldTranscodeDownloads;

  @HiveField(45)
  int? downloadTranscodeBitrate;

  @HiveField(46, defaultValue: _shouldRedownloadTranscodesDefault)
  bool shouldRedownloadTranscodes;

  @HiveField(47, defaultValue: _enableVibration)
  bool enableVibration;

  @HiveField(48, defaultValue: _playerScreenCoverMinimumPadding)
  double playerScreenCoverMinimumPadding = _playerScreenCoverMinimumPadding;

  @HiveField(49, defaultValue: _prioritizeCoverFactor)
  double prioritizeCoverFactor;

  @HiveField(50, defaultValue: _suppressPlayerPadding)
  bool suppressPlayerPadding;

  @HiveField(51, defaultValue: _hideQueueButton)
  bool hideQueueButton;

  @HiveField(52, defaultValue: _reportQueueToServerDefault)
  bool reportQueueToServer;

  @HiveField(53,
      defaultValue: _periodicPlaybackSessionUpdateFrequencySecondsDefault)
  int periodicPlaybackSessionUpdateFrequencySeconds;

  @HiveField(54, defaultValue: _showArtistsTopSongs)
  bool showArtistsTopSongs = _showArtistsTopSongs;

  @HiveField(55, defaultValue: _showArtistChipImage)
  bool showArtistChipImage;

  static Future<FinampSettings> create() async {
    final downloadLocation = await DownloadLocation.create(
      name: "Internal Storage",
      // TODO update backup exclusions on iOS and make sure support dir is covered
      // default download location moved to support dir based on existing comment
      baseDirectory: DownloadLocationType.internalSupport,
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
    );
  }

  DownloadProfile get downloadTranscodingProfile => DownloadProfile(
      transcodeCodec: downloadTranscodingCodec,
      bitrate: downloadTranscodeBitrate);

  /// Returns the DownloadLocation that is the internal song dir. This can
  /// technically throw a StateError, but that should never happen™.
  DownloadLocation get internalSongDir =>
      downloadLocationsMap.values.firstWhere((element) =>
          element.baseDirectory == DownloadLocationType.internalSupport);

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
  bool get needsPermission => baseDirectory.needsPermission;

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
      case _:
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
            baseItemType != BaseItemDtoType.song &&
            baseItemType != BaseItemDtoType.unknown;
      case DownloadItemType.song:
        return baseItemType == BaseItemDtoType.song &&
            baseItem != null &&
            BaseItemDtoType.fromItem(baseItem!) == baseItemType;
      case DownloadItemType.image:
        return baseItem != null;
      case DownloadItemType.finampCollection:
        // TODO create an enum or somthing for this if more custom collections happen
        return baseItem == null &&
            baseItemType == BaseItemDtoType.unknown &&
            (id == "Favorites" ||
                id == "All Playlists" ||
                id == "5 Latest Albums");
      case DownloadItemType.anchor:
        return baseItem == null &&
            baseItemType == BaseItemDtoType.unknown &&
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
        baseItemType: BaseItemDtoType.unknown);
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
  BaseItemDto? get baseItem => _baseItemCached ??=
      ((jsonItem == null) ? null : BaseItemDto.fromJson(jsonDecode(jsonItem!)));
  @ignore
  BaseItemDto? _baseItemCached;

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
      String? viewId}) {
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
      // Not all BaseItemDto are requested with mediasources or childcount.  Do not
      // overwrite with null if the new item does not have them.
      item.mediaSources ??= baseItem?.mediaSources;
      item.childCount ??= baseItem?.childCount;
    }
    assert(item == null ||
        item.mediaSources == null ||
        item.mediaSources!.isNotEmpty);
    var orderedChildren = orderedChildItems?.map((e) => e.isarId).toList();
    if (viewId == null || viewId == this.viewId) {
      if (item == null || baseItem!.mostlyEqual(item)) {
        var equal = const DeepCollectionEquality().equals;
        if (equal(orderedChildren, this.orderedChildren)) {
          return null;
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
  unknown(null, false),
  album("MusicAlbum", false),
  artist("MusicArtist", true),
  playlist("Playlist", true),
  genre("MusicGenre", true),
  song("Audio", false),
  library("CollectionFolder", true),
  folder("Folder", false),
  musicVideo("MusicVideo", false);

  const BaseItemDtoType(this.idString, this.expectChanges);

  final String? idString;
  final bool expectChanges;

  static BaseItemDtoType fromItem(BaseItemDto item) {
    switch (item.type) {
      case "Audio":
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
        return song;
      case "MusicVideo":
        return song;
      default:
        throw "Unknown baseItemDto type ${item.type}";
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
  genreMix;
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
    this.contextLufs,
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
  double? contextLufs;
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
enum ReplayGainMode {
  /// Use track LUFS if playing unrelated tracks, use album LUFS if playing albums
  @HiveField(0)
  hybrid,

  /// Use track LUFS regardless of context
  @HiveField(1)
  trackOnly,

  /// Only normalize if playing albums
  @HiveField(2)
  albumOnly,
}

@HiveType(typeId: 64)
enum DownloadLocationType {
  @HiveField(0)
  internalDocuments(false, false, false, BaseDirectory.applicationDocuments),
  @HiveField(1)
  internalSupport(false, false, false, BaseDirectory.applicationSupport),
  @HiveField(2)
  external(true, false, false, BaseDirectory.root),
  @HiveField(3)
  custom(true, false, true, BaseDirectory.root),
  @HiveField(4)
  none(false, false, false, BaseDirectory.root),
  @HiveField(5)
  migrated(true, false, false, BaseDirectory.root);

  const DownloadLocationType(this.needsPath, this.needsPermission,
      this.useHumanReadableNames, this.baseDirectory);

  final bool needsPath;
  // TODO this isn't used anymore.  Investigate permission stuff.
  final bool needsPermission;
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
