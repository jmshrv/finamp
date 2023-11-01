import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

/// Logs offline listens or failed submissions to a file.
class OfflineListenLogHelper {
  final _logger = Logger("OfflineListenLogHelper");

  Future<Directory> get _logDirectory async {
    if (!Platform.isAndroid) {
      return await getApplicationDocumentsDirectory();
    }

    final List<Directory>? dirs =
        await getExternalStorageDirectories(type: StorageDirectory.documents);
    return dirs?.first ?? await getApplicationDocumentsDirectory();
  }

  Future<File> get _logFile async {
    final Directory directory = await _logDirectory;
    return File("${directory.path}/listens.json");
  }

  Future<void> logOfflineListen(MediaItem item) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final itemJson = item.extras!["itemJson"];
    final id = itemJson["Id"];
    final name = itemJson["Name"];
    final albumArtist = itemJson["AlbumArtist"];
    final album = itemJson["Album"];
    final trackMbid = itemJson["ProviderIds"]?["MusicBrainzTrack"];

    await _logOfflineListen(timestamp, id, name, albumArtist, album, trackMbid);
  }

  Future<void> _logOfflineListen(
    int timestamp,
    String id,
    String name,
    String? artist,
    String? album,
    String? trackMbid,
  ) async {
    final data = {
      'timestamp': timestamp,
      'id': id,
      'title': name,
      'artist': artist,
      'album': album,
      'track_mbid': trackMbid,
    };
    final content = json.encode(data) + Platform.lineTerminator;

    final file = await _logFile;
    try {
      file.writeAsString(content, mode: FileMode.append, flush: true);
    } catch (e) {
      _logger.warning("Failed to write listen to file: $content");
    }
  }
}