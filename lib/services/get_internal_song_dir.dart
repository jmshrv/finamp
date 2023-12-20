import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_helper;

/// Returns the "internal storage" directory for songs (applicationDocumentsDirectory + /songs).
/// If it doesn't exist, the directory is created.
Future<Directory> getInternalSongDir() async {
  // TODO: Start using support directory by default, keep this around for legacy
  return await getApplicationDocumentsDirectory();
}
