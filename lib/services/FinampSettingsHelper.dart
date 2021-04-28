import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/FinampModels.dart';

class FinampSettingsHelper {
  static ValueListenable<Box<FinampSettings>> get finampSettingsListener =>
      Hive.box<FinampSettings>("FinampSettings")
          .listenable(keys: ["FinampSettings"]);

  static FinampSettings get finampSettings =>
      Hive.box<FinampSettings>("FinampSettings").get("FinampSettings");

  /// Deletes the downloadLocation at the given index.
  static void deleteDownloadLocation(int index) {
    FinampSettings finampSettingsTemp = finampSettings;
    finampSettingsTemp.downloadLocations.removeAt(index);
    Hive.box<FinampSettings>("FinampSettings")
        .put("FinampSettings", finampSettingsTemp);
  }
}
