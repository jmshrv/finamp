import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Returns the "internal storage" directory for songs (applicationDocumentsDirectory + /songs).
/// If it doesn't exist, the directory is created.
Future<Directory> getInternalSongDir() async {
  // TODO: Start using support directory by default, keep this around for legacy
  Directory appDir = await getApplicationDocumentsDirectory();
  Directory songDir = Directory(appDir.path + "/songs");
  if (!await songDir.exists()) {
    await songDir.create();
  }
  return songDir;
}
