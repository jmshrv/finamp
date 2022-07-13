import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'jellyfin_models.dart';
import '../services/get_internal_song_dir.dart';

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
    this.showCoverAsPlayerBackground = false,
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
  @HiveField(7)
  SortBy sortBy;

  /// Current sort order setting.
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
    );
  }

  /// Returns the DownloadLocation that is the internal song dir. See the
  /// description of the "deletable" property to see how this works. This can
  /// technically throw a StateError, but that should never happen™.
  DownloadLocation get internalSongDir =>
      downloadLocationsMap.values.firstWhere((element) => !element.deletable);

  /// Whether or not to use blurred cover art as background on player screen.
  @HiveField(16)
  bool showCoverAsPlayerBackground;
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
  String toString() => _humanReadableName(this);

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
  String toString() => _humanReadableName(this);

  String _humanReadableName(ContentViewType contentViewType) {
    switch (contentViewType) {
      case ContentViewType.list:
        return "List";
      case ContentViewType.grid:
        return "Grid";
    }
  }
}
