import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/FinampModels.dart';

class FinampSettingsHelper {
  static ValueListenable<Box<FinampSettings>> get finampSettingsListener =>
      Hive.box<FinampSettings>("FinampSettings")
          .listenable(keys: ["FinampSettings"]);

  // This shouldn't be null as FinampSettings is created on startup.
  // This decision will probably come back to haunt me later.
  static FinampSettings get finampSettings =>
      Hive.box<FinampSettings>("FinampSettings").get("FinampSettings")!;

  /// Deletes the downloadLocation at the given index.
  static void deleteDownloadLocation(int index) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.downloadLocations.removeAt(index);
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }

  /// Add a new download location to FinampSettings
  static void addDownloadLocation(DownloadLocation downloadLocation) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.downloadLocations.add(downloadLocation);
    Hive.box<FinampSettings>("FinampSettings")
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

  static void setAndroidStopForegroundOnPause(
      bool androidStopForegroundOnPause) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.androidStopForegroundOnPause =
        androidStopForegroundOnPause;
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }
}
