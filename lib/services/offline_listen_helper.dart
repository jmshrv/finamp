import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

/// Logs offline listens or failed submissions to a file.
class OfflineListenLogHelper {
  final _logger = Logger("OfflineListenLogHelper");
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

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

  /// Logs a listen to a file.
  ///
  /// This is used when the user is offline or submitting live playback events fails.
  Future<void> logOfflineListen(MediaItem item) async {
    final itemJson = item.extras!["itemJson"];

    final offlineListen = OfflineListen(
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      userId: _finampUserHelper.currentUserId!,
      itemId: itemJson["Id"],
      name: itemJson["Name"],
      artist: itemJson["AlbumArtist"],
      album: itemJson["Album"],
      trackMbid: itemJson["ProviderIds"]?["MusicBrainzTrack"],
    );

    await _logOfflineListen(offlineListen);
  }

  /// Logs a listen to a file.
  ///
  /// This is used when the user is offline or submitting live playback events fails.
  /// The [timestamp] provided to this function should be in seconds
  /// and marks the time the track was stopped.
  Future<void> _logOfflineListen(OfflineListen listen) async {
    Hive.box<OfflineListen>("OfflineListens").add(listen);

    _exportOfflineListenToFile(listen);
  }

  Future<void> _exportOfflineListenToFile(OfflineListen listen) async {
    final data = {
      'timestamp': listen.timestamp,
      'item_id': listen.itemId,
      'title': listen.name,
      'artist': listen.artist,
      'album': listen.album,
      'track_mbid': listen.trackMbid,
      'user_id': listen.userId,
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