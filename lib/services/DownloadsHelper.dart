import 'dart:convert';
import 'dart:io';

import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'JellyfinApiData.dart';

class DownloadsHelper {
  List<String> queue = [];
  Directory _songDir;
  JellyfinApiData _jellyfinApiData = GetIt.instance<JellyfinApiData>();

  Future<void> addDownload(BaseItemDto id) async {
    Directory songDir = await _getSongDir();

    List<BaseItemDto> songs = await _jellyfinApiData.getItems(
      parentItem: id,
      includeItemTypes: "Audio",
    );

    String baseUrl = await _jellyfinApiData.getBaseUrl();

    for (BaseItemDto song in songs) {
      String songUrl = baseUrl + "/Items/${song.id}/File";
      Future songInfoFuture =
          File("${songDir.path}/${song.id}-BaseItemDto.json")
              .writeAsString(json.encode(song));

      List<MediaSourceInfo> mediaSourceInfo =
          await _jellyfinApiData.getPlaybackInfo(song.id);

      Future mediaSourceInfoFuture =
          File("${songDir.path}/${song.id}-MediaSourceInfo.json")
              .writeAsString(json.encode(mediaSourceInfo[0]));

      String downloadId = await FlutterDownloader.enqueue(
        url: songUrl,
        savedDir: songDir.path,
        headers: {
          // "X-Emby-Authorization": await _jellyfinApiData.getAuthHeader(),
          "X-Emby-Token": await _jellyfinApiData.getTokenHeader()
        },
        fileName: song.id + ".${mediaSourceInfo[0].container}",
        openFileFromNotification: false,
        showNotification: false,
      );

      Future downloadIdFuture =
          File("${songDir.path}/${song.id}-DownloadId.txt")
              .writeAsString(downloadId);

      await Future.wait(
          [songInfoFuture, mediaSourceInfoFuture, downloadIdFuture]);
    }
  }

  /// Gets the download status for the given item id (Jellyfin item id, not flutter_downloader task id).
  /// If itemId-DownloadId.txt doesn't exist, it is assumed that the item is not downloaded. If this is the case, null is returned.
  /// Throws an error if more than one download status exists or if the query doesn't return anything despite itemId-DownloadId.txt existing.
  Future<DownloadTask> getDownloadStatus(String itemId) async {
    Directory songDir = await _getSongDir();
    File downloadIdFile = File("${songDir.path}/$itemId-DownloadId.txt");

    if (!await downloadIdFile.exists()) {
      return null;
    }

    String downloadId = await downloadIdFile.readAsString();
    List<DownloadTask> downloadStatus =
        await FlutterDownloader.loadTasksWithRawQuery(
            query: "SELECT * FROM task WHERE task_id='$downloadId'");

    if (downloadStatus.length > 1) {
      // If the query returns more than one item, something probably isn't right.
      return Future.error(
          "getDownloadStatus returned more than one downloadStatuses for item $itemId. getDownloadStatus got ${downloadStatus.toString()}");
    } else if (downloadStatus.length == 0) {
      return null;
    } else {
      return downloadStatus[0];
    }
  }

  Future<Directory> _getSongDir() async {
    if (_songDir == null) {
      Directory appDir = await getApplicationDocumentsDirectory();
      _songDir = Directory(appDir.path + "/songs");
      if (!await _songDir.exists()) {
        await _songDir.create();
      }
      return _songDir;
    } else {
      return _songDir;
    }
  }
}
