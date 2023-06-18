import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LocaleAdapter extends TypeAdapter<Locale> {
  @override
  int get typeId => 42;

  @override
  Locale read(BinaryReader reader) {
    final localeList = reader.readStringList();

    final languageCode = localeList[0];

    // scriptCode and countryCode are empty strings when null (see write)
    final scriptCode = localeList[1] == "" ? null : localeList[1];
    final countryCode = localeList[2] == "" ? null : localeList[2];

    return Locale.fromSubtags(
      languageCode: languageCode,
      scriptCode: scriptCode,
      countryCode: countryCode,
    );
  }

  @override
  void write(BinaryWriter writer, Locale obj) {
    writer.writeStringList([
      obj.languageCode,
      obj.scriptCode ?? "",
      obj.countryCode ?? "",
    ]);
  }
}
