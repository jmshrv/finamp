import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';

class FinampSettingsHelper {
  static ValueListenable<Box<FinampSettings>> get finampSettingsListener =>
      Hive.box<FinampSettings>("FinampSettings")
          .listenable(keys: ["FinampSettings"]);

  static final AutoDisposeStreamProvider<FinampSettings?>
      finampSettingsProvider = StreamProvider.autoDispose((ref) {
    return Hive.box<FinampSettings>("FinampSettings")
        .watch()
        .map<FinampSettings?>((event) => event.value)
        .startWith(finampSettings);
  });

  // This shouldn't be null as FinampSettings is created on startup.
  // This decision will probably come back to haunt me later.
  static FinampSettings get finampSettings =>
      Hive.box<FinampSettings>("FinampSettings").get("FinampSettings")!;

  /// Deletes the downloadLocation at the given index.
  static void deleteDownloadLocation(String id) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.downloadLocationsMap.remove(id);
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  /// Add a new download location to FinampSettings
  static void addDownloadLocation(DownloadLocation downloadLocation) async {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.downloadLocationsMap[downloadLocation.id] =
        downloadLocation;
    await Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  /// Set the isOffline property
  static void setIsOffline(bool isOffline) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.isOffline = isOffline;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  /// Set the shouldTranscode property
  static void setShouldTranscode(bool shouldTranscode) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.shouldTranscode = shouldTranscode;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setTranscodeBitrate(int transcodeBitrate) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.transcodeBitrate = transcodeBitrate;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setShowTab(TabContentType tabContentType, bool value) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.showTabs[tabContentType] = value;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setOnlyShowFavourite(bool onlyShowFavourite) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.onlyShowFavourite = onlyShowFavourite;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setOnlyShowFullyDownloaded(bool onlyShowFullyDownloaded) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.onlyShowFullyDownloaded = onlyShowFullyDownloaded;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setSortBy(TabContentType tabType, SortBy sortBy) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.tabSortBy[tabType] = sortBy;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setSortOrder(TabContentType tabType, SortOrder sortOrder) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.tabSortOrder[tabType] = sortOrder;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setAndroidStopForegroundOnPause(
      bool androidStopForegroundOnPause) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.androidStopForegroundOnPause =
        androidStopForegroundOnPause;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setAutoloadLastQueueOnStartup(bool autoloadLastQueueOnStartup) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.autoloadLastQueueOnStartup = autoloadLastQueueOnStartup;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setSongShuffleItemCount(int songShuffleItemCount) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.songShuffleItemCount = songShuffleItemCount;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setContentGridViewCrossAxisCountPortrait(
      int contentGridViewCrossAxisCountPortrait) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.contentGridViewCrossAxisCountPortrait =
        contentGridViewCrossAxisCountPortrait;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setContentGridViewCrossAxisCountLandscape(
      int contentGridViewCrossAxisCountLandscape) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.contentGridViewCrossAxisCountLandscape =
        contentGridViewCrossAxisCountLandscape;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setContentViewType(ContentViewType contentViewType) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.contentViewType = contentViewType;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setShowTextOnGridView(bool showTextOnGridView) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.showTextOnGridView = showTextOnGridView;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setSleepTimerSeconds(int sleepTimerSeconds) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.sleepTimerSeconds = sleepTimerSeconds;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void overwriteFinampSettings(FinampSettings newFinampSettings) {
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", newFinampSettings);
  }

  static void setShowCoverAsPlayerBackground(bool showCoverAsPlayerBackground) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.showCoverAsPlayerBackground =
        showCoverAsPlayerBackground;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setHideSongArtistsIfSameAsAlbumArtists(
      bool hideSongArtistsIfSameAsAlbumArtists) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.hideSongArtistsIfSameAsAlbumArtists =
        hideSongArtistsIfSameAsAlbumArtists;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setDisableGesture(bool disableGesture) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.disableGesture = disableGesture;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setShowFastScroller(bool showFastScroller) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.showFastScroller = showFastScroller;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setBufferDuration(Duration bufferDuration) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.bufferDuration = bufferDuration;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  /// Set the loopMode property
  static void setLoopMode(FinampLoopMode loopMode) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.loopMode = loopMode;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setHasCompletedBlurhashImageMigration(
      bool hasCompletedBlurhashImageMigration) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.hasCompletedBlurhashImageMigration =
        hasCompletedBlurhashImageMigration;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setHasCompletedBlurhashImageMigrationIdFix(
      bool hasCompletedBlurhashImageMigrationIdFix) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.hasCompletedBlurhashImageMigrationIdFix =
        hasCompletedBlurhashImageMigrationIdFix;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setHasCompletedIsarDownloadsMigration(
      bool hasCompletedIsarDownloadsMigration) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.hasCompletedIsarDownloadsMigration =
        hasCompletedIsarDownloadsMigration;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setHasCompletedIsarUserMigration(
      bool hasCompletedIsarUserMigration) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.hasCompletedIsarUserMigration =
        hasCompletedIsarUserMigration;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setTabOrder(int index, TabContentType tabContentType) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.tabOrder[index] = tabContentType;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetTabs() {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.tabOrder = TabContentType.values;
    finampSettingsTemp.showTabs = Map.fromEntries(
      TabContentType.values.map(
        (e) => MapEntry(e, true),
      ),
    );
  }

  static void setSwipeInsertQueueNext(bool swipeInsertQueueNext) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.swipeInsertQueueNext = swipeInsertQueueNext;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }
}
