import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocaleHelper {
  static const boxName = "Locale";

  static ValueListenable<Box<Locale?>> get localeListener =>
      Hive.box<Locale?>(boxName).listenable();

  static Locale? get locale => Hive.box<Locale?>(boxName).get(boxName);

  static String? get localeString {
    final locale = LocaleHelper.locale;
    return locale != null
        ? (locale.countryCode != null
            ? "${locale.languageCode.toLowerCase()}_${locale.countryCode?.toUpperCase()}"
            : locale.toString())
        : null;
  }

  static void setLocale(Locale? locale) {
    Hive.box<Locale?>(boxName).put(boxName, locale);
  }
}
