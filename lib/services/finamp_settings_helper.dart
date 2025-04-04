import 'package:finamp/components/confirmation_prompt_dialog.dart';
import 'package:finamp/services/locale_helper.dart';
import 'package:finamp/services/theme_mode_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';

part 'finamp_settings_helper.g.dart';

@Riverpod(keepAlive: true)
Stream<FinampSettings> finampSettings(Ref ref) {
  return Hive.box<FinampSettings>("FinampSettings")
      .watch()
      .map<FinampSettings>((event) => event.value! as FinampSettings)
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

  static void setShowTab(TabContentType tabContentType, bool value) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.showTabs[tabContentType] = value;
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

  static void overwriteFinampSettings(FinampSettings newFinampSettings) {
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", newFinampSettings);
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
    finampSettingsTemp.oneLineMarqueeTextButton =
        DefaultSettings.oneLineMarqueeTextButton;

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
    FinampSetters.setContentViewType(DefaultSettings.contentViewType);
    finampSettingsTemp.useFixedSizeGridTiles =
        DefaultSettings.useFixedSizeGridTiles;
    FinampSetters.setContentGridViewCrossAxisCountPortrait(
        DefaultSettings.contentGridViewCrossAxisCountPortrait);
    FinampSetters.setContentGridViewCrossAxisCountLandscape(
        DefaultSettings.contentGridViewCrossAxisCountLandscape);
    finampSettingsTemp.fixedGridTileSize = DefaultSettings.fixedGridTileSize;
    finampSettingsTemp.showTextOnGridView = DefaultSettings.showTextOnGridView;
    FinampSetters.setUseCoverAsBackground(DefaultSettings.useCoverAsBackground);
    finampSettingsTemp.showArtistChipImage =
        DefaultSettings.showArtistChipImage;
    finampSettingsTemp.showArtistsTopTracks =
        DefaultSettings.showArtistsTopTracks;
    finampSettingsTemp.allowSplitScreen = DefaultSettings.allowSplitScreen;
    finampSettingsTemp.showProgressOnNowPlayingBar =
        DefaultSettings.showProgressOnNowPlayingBar;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetTranscodingSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    finampSettingsTemp.shouldTranscode = DefaultSettings.shouldTranscode;
    FinampSetters.setTranscodeBitrate(DefaultSettings.transcodeBitrate);
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
    finampSettingsTemp.downloadSizeWarningCutoff =
        DefaultSettings.downloadSizeWarningCutoff;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetAudioServiceSettings() {
    FinampSetters.setAndroidStopForegroundOnPause(
        DefaultSettings.androidStopForegroundOnPause);
    FinampSetters.setTrackShuffleItemCount(
        DefaultSettings.trackShuffleItemCount); // DOES NOT update UI
    FinampSetters.setBufferDuration(Duration(
        seconds: DefaultSettings.bufferDurationSeconds)); // DOES NOT update UI
    FinampSetters.setAutoloadLastQueueOnStartup(
        DefaultSettings.autoLoadLastQueueOnStartup);
  }

  static void resetPlaybackReportingSettings() {
    FinampSetters.setPeriodicPlaybackSessionUpdateFrequencySeconds(DefaultSettings
        .periodicPlaybackSessionUpdateFrequencySeconds); // DOES NOT update UI
    FinampSetters.setReportQueueToServer(DefaultSettings.reportQueueToServer);
    FinampSetters.setPlayOnStaleDelay(DefaultSettings.playOnStaleDelay);
  }

  static void resetNormalizationSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    finampSettingsTemp.volumeNormalizationActive =
        DefaultSettings.volumeNormalizationActive;
    FinampSetters.setVolumeNormalizationIOSBaseGain(
        DefaultSettings.volumeNormalizationIOSBaseGain); // DOES NOT update UI
    finampSettingsTemp.volumeNormalizationMode =
        DefaultSettings.volumeNormalizationMode;

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void resetInteractionsSettings() {
    FinampSettings finampSettingsTemp = finampSettings;

    FinampSetters.setSwipeInsertQueueNext(DefaultSettings.swipeInsertQueueNext);
    finampSettingsTemp.startInstantMixForIndividualTracks =
        DefaultSettings.startInstantMixForIndividualTracks;
    FinampSetters.setShowFastScroller(DefaultSettings.showFastScroller);
    FinampSetters.setDisableGesture(DefaultSettings.disableGesture);
    FinampSetters.setEnableVibration(DefaultSettings.enableVibration);
    FinampSetters.setKeepScreenOnOption(DefaultSettings.keepScreenOnOption);
    FinampSetters.setKeepScreenOnWhilePluggedIn(
        DefaultSettings.keepScreenOnWhilePluggedIn);

    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  static void setCurrentVolume(double newVolume) {
    FinampSettings finampSettingsTemp = finampSettings;
    if (newVolume < 0) {
      newVolume = 0.0;
    } else if (newVolume > 1) {
      newVolume = 1.0;
    }
    finampSettingsTemp.currentVolume = newVolume;
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

extension ApplyIfNonNull<K, V> on K Function(V) {
  void ifNonNull(V? value) {
    if (value != null) {
      this(value);
    }
  }
}
