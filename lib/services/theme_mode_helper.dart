import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A helper for setting the theme, like FinampSettingsHelper. We don't do theme
/// stuff in FinampSettingsHelper as we would have to rebuild the MaterialApp on
/// every setting change.
class ThemeModeHelper {
  static ValueListenable<Box<ThemeMode>> get themeModeListener =>
      Hive.box<ThemeMode>("ThemeMode").listenable(keys: ["ThemeMode"]);

  static void setThemeMode(ThemeMode themeMode) {
    Hive.box<ThemeMode>("ThemeMode").put("ThemeMode", themeMode);
  }
}
