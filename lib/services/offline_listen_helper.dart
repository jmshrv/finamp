import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:get_it/get_it.dart';
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

    await _logOfflineListen(
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      itemId: itemJson["Id"],
      name: itemJson["Name"],
      artist: itemJson["AlbumArtist"],
      album: itemJson["Album"],
      trackMbid: itemJson["ProviderIds"]?["MusicBrainzTrack"],
      userId: _finampUserHelper.currentUserId,
    );
  }

  /// Logs a listen to a file.
  ///
  /// This is used when the user is offline or submitting live playback events fails.
  /// The [timestamp] provided to this function should be in seconds
  /// and marks the time the track was stopped.
  Future<void> _logOfflineListen({
    required int timestamp,
    required String itemId,
    required String name,
    String? artist,
    String? album,
    String? trackMbid,
    String? userId,
  }) async {
    final data = {
      'timestamp': timestamp,
      'item_id': itemId,
      'title': name,
      'artist': artist,
      'album': album,
      'track_mbid': trackMbid,
      'user_id': userId,
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