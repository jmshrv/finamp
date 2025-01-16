import 'package:finamp/components/confirmation_prompt_dialog.dart';
import 'package:finamp/screens/layout_settings_screen.dart';
import 'package:finamp/services/locale_helper.dart';
import 'package:finamp/services/theme_mode_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';

part 'finamp_settings_helper.g.dart';

@riverpod
Stream<FinampSettings?> finampSettings(FinampSettingsRef ref) {
  return Hive.box<FinampSettings>("FinampSettings")
      .watch()
      .map<FinampSettings?>((event) => event.value)
      .startWith(FinampSettingsHelper.finampSettings);
}

class FinampSettingsHelper {
  static ValueListenable<Box<FinampSettings>> get finampSettingsListener =>
      Hive.box<FinampSettings>("FinampSettings")
          .listenable(keys: ["FinampSettings"]);

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

  static void setonlyShowFavourites(bool onlyShowFavourites) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.onlyShowFavourites = onlyShowFavourites;
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

  static void setVolumeNormalizationActive(bool volumeNormalizationActive) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.volumeNormalizationActive = volumeNormalizationActive;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setVolumeNormalizationIOSBaseGain(
      double volumeNormalizationIOSBaseGain) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.volumeNormalizationIOSBaseGain =
        volumeNormalizationIOSBaseGain;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setVolumeNormalizationMode(
      VolumeNormalizationMode volumeNormalizationMode) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.volumeNormalizationMode = volumeNormalizationMode;
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

  static void setPlaybackSpeedVisibility(
      PlaybackSpeedVisibility playbackSpeedVisibility) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.playbackSpeedVisibility = playbackSpeedVisibility;
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

  static void setUseCoverAsBackground(bool useCoverAsBackground) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.useCoverAsBackground = useCoverAsBackground;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setPlayerScreenCoverMinimumPadding(
      double playerScreenCoverMinimumPadding) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.playerScreenCoverMinimumPadding =
        playerScreenCoverMinimumPadding;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setShowArtistsTopSongs(bool showArtistsTopSongs) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.showArtistsTopSongs = showArtistsTopSongs;
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

  /// Set the playbackSpeed property
  static void setPlaybackSpeed(double speed) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.playbackSpeed = speed;
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

  static void setHasCompleteddownloadsServiceMigration(
      bool hasCompleteddownloadsServiceMigration) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.hasCompletedDownloadsServiceMigration =
        hasCompleteddownloadsServiceMigration;
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

  static void setHasDownloadedPlaylistInfo(bool hasDownloadedPlaylistInfo) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.hasDownloadedPlaylistInfo = hasDownloadedPlaylistInfo;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setTabOrder(List<TabContentType> newTabOrder) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.tabOrder = newTabOrder;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetTabsSettings() {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.tabOrder = TabContentType.values;
    finampSettingsTemp.showTabs = Map.fromEntries(
      TabContentType.values.map(
        (e) => MapEntry(e, true),
      ),
    );
  }

  static void resetCustomizationSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    finampSettingsTemp.playbackSpeedVisibility =
        DefaultSettings.playbackSpeedVisibility;
    finampSettingsTemp.showStopButtonOnMediaNotification =
        DefaultSettings.showStopButtonOnMediaNotification;
    finampSettingsTemp.showSeekControlsOnMediaNotification =
        DefaultSettings.showSeekControlsOnMediaNotification;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetPlayerScreenSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    finampSettingsTemp.featureChipsConfiguration =
        DefaultSettings.featureChipsConfiguration;
    finampSettingsTemp.playerScreenCoverMinimumPadding =
        DefaultSettings.playerScreenCoverMinimumPadding;
    finampSettingsTemp.suppressPlayerPadding =
        DefaultSettings.suppressPlayerPadding;
    finampSettingsTemp.prioritizeCoverFactor =
        DefaultSettings.prioritizeCoverFactor;
    finampSettingsTemp.hidePlayerBottomActions =
        DefaultSettings.hidePlayerBottomActions;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetLyricsSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    finampSettingsTemp.showLyricsTimestamps =
        DefaultSettings.showLyricsTimestamps;
    finampSettingsTemp.showLyricsScreenAlbumPrelude =
        DefaultSettings.showLyricsScreenAlbumPrelude;
    finampSettingsTemp.lyricsAlignment = DefaultSettings.lyricsAlignment;
    finampSettingsTemp.lyricsFontSize = DefaultSettings.lyricsFontSize;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetAlbumSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    finampSettingsTemp.showCoversOnAlbumScreen =
        DefaultSettings.showCoversOnAlbumScreen;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetLayoutSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    ThemeModeHelper.setThemeMode(DefaultSettings.theme);
    setContentViewType(DefaultSettings.contentViewType);
    finampSettingsTemp.useFixedSizeGridTiles =
        DefaultSettings.useFixedSizeGridTiles;
    setContentGridViewCrossAxisCountPortrait(
        DefaultSettings.contentGridViewCrossAxisCountPortrait);
    setContentGridViewCrossAxisCountLandscape(
        DefaultSettings.contentGridViewCrossAxisCountLandscape);
    finampSettingsTemp.fixedGridTileSize = DefaultSettings.fixedGridTileSize;
    finampSettingsTemp.showTextOnGridView = DefaultSettings.showTextOnGridView;
    setUseCoverAsBackground(DefaultSettings.useCoverAsBackground);
    finampSettingsTemp.showArtistChipImage =
        DefaultSettings.showArtistChipImage;
    finampSettingsTemp.showArtistsTopSongs =
        DefaultSettings.showArtistsTopSongs;
    finampSettingsTemp.allowSplitScreen = DefaultSettings.allowSplitScreen;
    finampSettingsTemp.showProgressOnNowPlayingBar =
        DefaultSettings.showProgressOnNowPlayingBar;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetTranscodingSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    finampSettingsTemp.shouldTranscode = DefaultSettings.shouldTranscode;
    setTranscodeBitrate(DefaultSettings.transcodeBitrate);
    finampSettingsTemp.transcodingSegmentContainer =
        DefaultSettings.transcodingSegmentContainer;
    finampSettingsTemp.shouldTranscodeDownloads =
        DefaultSettings.shouldTranscodeDownloads;
    finampSettingsTemp.downloadTranscodingCodec = FinampTranscodingCodec
        .opus; // starts uninitilized, idk what value this should be
    finampSettingsTemp.downloadTranscodeBitrate =
        128000; // starts uninitilized, idk what value this should be

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetDownloadSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    finampSettingsTemp.requireWifiForDownloads =
        DefaultSettings.requireWifiForDownloads;
    finampSettingsTemp.trackOfflineFavorites =
        DefaultSettings.trackOfflineFavorites;
    finampSettingsTemp.resyncOnStartup = DefaultSettings.resyncOnStartup;
    finampSettingsTemp.preferQuickSyncs = DefaultSettings.preferQuickSyncs;
    finampSettingsTemp.shouldRedownloadTranscodes =
        DefaultSettings.shouldRedownloadTranscodes;
    finampSettingsTemp.showDownloadsWithUnknownLibrary =
        DefaultSettings.showDownloadsWithUnknownLibrary;
    finampSettingsTemp.downloadWorkers = DefaultSettings.downloadWorkers;
    finampSettingsTemp.maxConcurrentDownloads =
        DefaultSettings.maxConcurrentDownloads;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetAudioServiceSettings() {
    setAndroidStopForegroundOnPause(
        DefaultSettings.androidStopForegroundOnPause);
    setSongShuffleItemCount(
        DefaultSettings.songShuffleItemCount); // DOES NOT update UI
    setBufferDuration(Duration(
        seconds: DefaultSettings.bufferDurationSeconds)); // DOES NOT update UI
    setAutoloadLastQueueOnStartup(DefaultSettings.autoLoadLastQueueOnStartup);
    setPeriodicPlaybackSessionUpdateFrequencySeconds(DefaultSettings
        .periodicPlaybackSessionUpdateFrequencySeconds); // DOES NOT update UI
    setReportQueueToServer(DefaultSettings.reportQueueToServer);
  }

  static void resetNormalizationSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    finampSettingsTemp.volumeNormalizationActive =
        DefaultSettings.volumeNormalizationActive;
    setVolumeNormalizationIOSBaseGain(
        DefaultSettings.volumeNormalizationIOSBaseGain); // DOES NOT update UI
    finampSettingsTemp.volumeNormalizationMode =
        DefaultSettings.volumeNormalizationMode;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetInteractionsSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    setSwipeInsertQueueNext(DefaultSettings.swipeInsertQueueNext);
    finampSettingsTemp.startInstantMixForIndividualTracks =
        DefaultSettings.startInstantMixForIndividualTracks;
    setShowFastScroller(DefaultSettings.showFastScroller);
    setDisableGesture(DefaultSettings.disableGesture);
    setEnableVibration(DefaultSettings.enableVibration);
    setKeepScreenOnOption(DefaultSettings.keepScreenOnOption);
    setKeepScreenOnWhilePluggedIn(DefaultSettings.keepScreenOnWhilePluggedIn);

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetAllSettings() {
    resetTranscodingSettings();
    resetDownloadSettings();
    resetAudioServiceSettings();
    resetNormalizationSettings();
    resetInteractionsSettings();

    resetLayoutSettings();
    resetCustomizationSettings();
    resetPlayerScreenSettings();
    resetLyricsSettings();
    resetAlbumSettings();
    resetTabsSettings();

    LocaleHelper.setLocale(null); // Reset to System Language
  }

  static void setSwipeInsertQueueNext(bool swipeInsertQueueNext) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.swipeInsertQueueNext = swipeInsertQueueNext;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setEnableVibration(bool enableVibration) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.enableVibration = enableVibration;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setReportQueueToServer(bool reportQueueToServer) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.reportQueueToServer = reportQueueToServer;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setPeriodicPlaybackSessionUpdateFrequencySeconds(
      int periodicPlaybackSessionUpdateFrequencySeconds) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.periodicPlaybackSessionUpdateFrequencySeconds =
        periodicPlaybackSessionUpdateFrequencySeconds;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setKeepScreenOnOption(KeepScreenOnOption keepScreenOnOption) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.keepScreenOnOption = keepScreenOnOption;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setKeepScreenOnWhilePluggedIn(bool keepScreenOnWhilePluggedIn) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.keepScreenOnWhilePluggedIn = keepScreenOnWhilePluggedIn;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static IconButton makeSettingsResetButtonWithDialog(
      BuildContext context, Function() resetFunction,
      {bool isGlobal = false}) {
    // TODO: Replace the following Strings with localization
    return IconButton(
      onPressed: () async {
        await showDialog(
            context: context,
            builder: (context) => ConfirmationPromptDialog(
                  promptText: isGlobal
                      ? AppLocalizations.of(context)!.resetSettingsPromptGlobal
                      : AppLocalizations.of(context)!.resetSettingsPromptLocal,
                  confirmButtonText: isGlobal
                      ? AppLocalizations.of(context)!
                          .resetSettingsPromptGlobalConfirm
                      : AppLocalizations.of(context)!.reset,
                  abortButtonText: AppLocalizations.of(context)!.genericCancel,
                  onConfirmed: resetFunction,
                  onAborted: () {},
                ));
      },
      icon: const Icon(Icons.refresh),
      tooltip: AppLocalizations.of(context)!.resetToDefaults,
    );
  }
}
