import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path_helper;
import 'package:audio_service/audio_service.dart';
import 'package:uuid/uuid.dart';

import '../services/finamp_settings_helper.dart';
import '../services/get_internal_song_dir.dart';
import 'jellyfin_models.dart';

part 'finamp_models.g.dart';

@HiveType(typeId: 8)
class FinampUser {
  FinampUser({
    required this.id,
    required this.baseUrl,
    required this.accessToken,
    required this.serverId,
    this.currentViewId,
    required this.views,
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
  @HiveField(5)
  Map<String, BaseItemDto> views;

  BaseItemDto? get currentView => views[currentViewId];
}

// These consts are so that we can easily keep the same default for
// FinampSettings's constructor and Hive's defaultValue.
const _songShuffleItemCountDefault = 250;
const _contentViewType = ContentViewType.list;
const _contentGridViewCrossAxisCountPortrait = 2;
const _contentGridViewCrossAxisCountLandscape = 3;
const _showTextOnGridView = true;
const _sleepTimerSeconds = 1800; // 30 Minutes
const _showCoverAsPlayerBackground = true;
const _hideSongArtistsIfSameAsAlbumArtists = true;
const _disableGesture = false;
const _showFastScroller = true;
const _bufferDurationSeconds = 600;
const _tabOrder = TabContentType.values;
const _defaultLoopMode = FinampLoopMode.all;

@HiveType(typeId: 28)
class FinampSettings {
  FinampSettings({
    this.isOffline = false,
    this.shouldTranscode = false,
    this.transcodeBitrate = 320000,
    // downloadLocations is required since the other values can be created with
    // default values. create() is used to return a FinampSettings with
    // downloadLocations.
    required this.downloadLocations,
    this.androidStopForegroundOnPause = true,
    required this.showTabs,
    this.isFavourite = false,
    this.sortBy = SortBy.sortName,
    this.sortOrder = SortOrder.ascending,
    this.songShuffleItemCount = _songShuffleItemCountDefault,
    this.contentViewType = _contentViewType,
    this.contentGridViewCrossAxisCountPortrait =
        _contentGridViewCrossAxisCountPortrait,
    this.contentGridViewCrossAxisCountLandscape =
        _contentGridViewCrossAxisCountLandscape,
    this.showTextOnGridView = _showTextOnGridView,
    this.sleepTimerSeconds = _sleepTimerSeconds,
    required this.downloadLocationsMap,
    this.showCoverAsPlayerBackground = _showCoverAsPlayerBackground,
    this.hideSongArtistsIfSameAsAlbumArtists =
        _hideSongArtistsIfSameAsAlbumArtists,
    this.bufferDurationSeconds = _bufferDurationSeconds,
    required this.tabSortBy,
    required this.tabSortOrder,
    this.loopMode = _defaultLoopMode,
    this.tabOrder = _tabOrder,
    this.autoloadLastQueueOnStartup = true,
    this.hasCompletedBlurhashImageMigration = true,
    this.hasCompletedBlurhashImageMigrationIdFix = true,
  });

  @HiveField(0)
  bool isOffline;
  @HiveField(1)
  bool shouldTranscode;
  @HiveField(2)
  int transcodeBitrate;

  @Deprecated("Use downloadedLocationsMap instead")
  @HiveField(3)
  List<DownloadLocation> downloadLocations;

  @HiveField(4)
  bool androidStopForegroundOnPause;
  @HiveField(5)
  Map<TabContentType, bool> showTabs;

  /// Used to remember if the user has set their music screen to favourites
  /// mode.
  @HiveField(6)
  bool isFavourite;

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
  @HiveField(16, defaultValue: _showCoverAsPlayerBackground)
  bool showCoverAsPlayerBackground = _showCoverAsPlayerBackground;

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

  @HiveField(26, defaultValue: _defaultLoopMode)
  FinampLoopMode loopMode;

  @HiveField(27, defaultValue: true)
  bool autoloadLastQueueOnStartup;

  static Future<FinampSettings> create() async {
    final internalSongDir = await getInternalSongDir();
    final downloadLocation = DownloadLocation.create(
      name: "Internal Storage",
      path: internalSongDir.path,
      useHumanReadableNames: false,
      deletable: false,
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

  /// Returns the DownloadLocation that is the internal song dir. See the
  /// description of the "deletable" property to see how this works. This can
  /// technically throw a StateError, but that should never happen™.
  DownloadLocation get internalSongDir =>
      downloadLocationsMap.values.firstWhere((element) => !element.deletable);

  Duration get bufferDuration => Duration(seconds: bufferDurationSeconds);

  set bufferDuration(Duration duration) =>
      bufferDurationSeconds = duration.inSeconds;

  SortBy getTabSortBy(TabContentType tabType) {
    return tabSortBy[tabType] ?? SortBy.sortName;
  }

  SortOrder getSortOrder(TabContentType tabType) {
    return tabSortOrder[tabType] ?? SortOrder.ascending;
  }

  bool get shouldRunBlurhashImageMigrationIdFix =>
      hasCompletedBlurhashImageMigration &&
      !hasCompletedBlurhashImageMigrationIdFix;
}

/// Custom storage locations for storing music.
@HiveType(typeId: 31)
class DownloadLocation {
  DownloadLocation(
      {required this.name,
      required this.path,
      required this.useHumanReadableNames,
      required this.deletable,
      required this.id});

  /// Human-readable name for the path (shown in settings)
  @HiveField(0)
  String name;

  /// The path. We store this as a string since it's easier to put into Hive.
  @HiveField(1)
  String path;

  /// If true, store songs using their actual names instead of Jellyfin item IDs.
  @HiveField(2)
  bool useHumanReadableNames;

  /// If true, the user can delete this storage location. It's a bit of a hack,
  /// but the only undeletable location is the internal storage dir, so we can
  /// use this value to get the internal song dir.
  @HiveField(3)
  bool deletable;

  /// Unique ID for the DownloadLocation. If this DownloadLocation was created
  /// before 0.6, it will be "0", very temporarily until it is changed on
  /// startup.
  @HiveField(4, defaultValue: "0")
  String id;

  /// Initialises a new DownloadLocation. id will be a UUID.
  static DownloadLocation create({
    required String name,
    required String path,
    required bool useHumanReadableNames,
    required bool deletable,
  }) {
    return DownloadLocation(
      name: name,
      path: path,
      useHumanReadableNames: useHumanReadableNames,
      deletable: deletable,
      id: const Uuid().v4(),
    );
  }
}

/// Class used in AddDownloadLocationScreen. Basically just a DownloadLocation
/// with nullable values. Shouldn't be used for actually storing download
/// locations.
class NewDownloadLocation {
  NewDownloadLocation({
    this.name,
    this.path,
    this.useHumanReadableNames,
    required this.deletable,
  });

  String? name;
  String? path;
  bool? useHumanReadableNames;
  bool deletable;
}

/// Supported tab types in MusicScreenTabView.
@HiveType(typeId: 36)
enum TabContentType {
  @HiveField(0)
  albums,
  @HiveField(1)
  artists,
  @HiveField(2)
  playlists,
  @HiveField(3)
  genres,
  @HiveField(4)
  songs;

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

  File get file {
    if (isPathRelative) {
      final downloadLocation = FinampSettingsHelper
          .finampSettings.downloadLocationsMap[downloadLocationId];

      if (downloadLocation == null) {
        throw "DownloadLocation was null in file getter for DownloadsSong!";
      }

      return File(path_helper.join(downloadLocation.path, path));
    }

    return File(path);
  }

  DownloadLocation? get downloadLocation => FinampSettingsHelper
      .finampSettings.downloadLocationsMap[downloadLocationId];

  Future<DownloadTask?> get downloadTask async {
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id = '$downloadId'");

    if (tasks?.isEmpty == false) {
      return tasks!.first;
    }

    return null;
  }

  factory DownloadedSong.fromJson(Map<String, dynamic> json) =>
      _$DownloadedSongFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadedSongToJson(this);
}

@HiveType(typeId: 4)
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
  /// TODO: Investigate adding set support to Hive
  @HiveField(3)
  List<String> requiredBy;

  /// The ID of the DownloadLocation that holds this file.
  @HiveField(4)
  String downloadLocationId;

  DownloadLocation? get downloadLocation => FinampSettingsHelper
      .finampSettings.downloadLocationsMap[downloadLocationId];

  File get file {
    if (downloadLocation == null) {
      throw "Download location is null for image $id, this shouldn't happen...";
    }

    return File(path_helper.join(downloadLocation!.path, path));
  }

  Future<DownloadTask?> get downloadTask async {
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id = '$downloadId'");

    if (tasks?.isEmpty == false) {
      return tasks!.first;
    }
    return null;
  }

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
  unknown;
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
  });

  @HiveField(0)
  QueueItemSourceType type;

  @HiveField(1)
  QueueItemSourceName name;

  @HiveField(2)
  String id;

  @HiveField(3)
  BaseItemDto? item;
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
  });

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
}

@HiveType(typeId: 59)
class FinampQueueInfo {
  FinampQueueInfo({
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

