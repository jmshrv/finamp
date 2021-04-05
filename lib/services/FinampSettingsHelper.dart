import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/FinampModels.dart';

class FinampSettingsHelper {
  static ValueListenable<Box<FinampSettings>> get settingsListener =>
      Hive.box<FinampSettings>("FinampSettings")
          .listenable(keys: ["FinampSettings"]);
}
