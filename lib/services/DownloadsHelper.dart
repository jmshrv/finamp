import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'JellyfinApiData.dart';
import '../models/JellyfinModels.dart';

part 'DownloadsHelper.g.dart';

class DownloadsHelper {
  List<String> queue = [];
  Directory _songDir;
  JellyfinApiData _jellyfinApiData = GetIt.instance<JellyfinApiData>();
  Box<DownloadedSong> _downloadedItemsBox = Hive.box("DownloadedItems");
  Box<DownloadedAlbum> _downloadedAlbumsBox = Hive.box("DownloadedAlbums");
  Box<DownloadedSong> _downloadIdsBox = Hive.box("DownloadIds");

  Future<void> addDownloads(
      {List<BaseItemDto> items, BaseItemDto parent}) async {
    Directory songDir = await _getSongDir();
    String baseUrl = await _jellyfinApiData.getBaseUrl();

    for (final item in items) {
      if (!_downloadedAlbumsBox.containsKey(item.parentId)) {
        // If the current album doesn't exist, add the album to the box of albums
        print(
            "Album ${parent.name} (${parent.id}) not in albums box, adding now.");
        _downloadedAlbumsBox.put(
            parent.id, DownloadedAlbum(album: parent, children: []));
      }

      String songUrl = baseUrl + "/Items/${item.id}/File";

      List<MediaSourceInfo> mediaSourceInfo =
          await _jellyfinApiData.getPlaybackInfo(item.id);

      String downloadId = await FlutterDownloader.enqueue(
        url: songUrl,
        savedDir: songDir.path,
        headers: {
          // "X-Emby-Authorization": await _jellyfinApiData.getAuthHeader(),
          "X-Emby-Token": await _jellyfinApiData.getTokenHeader()
        },
        fileName: item.id + ".${mediaSourceInfo[0].container}",
        openFileFromNotification: false,
        showNotification: false,
      );

      DownloadedSong songInfo = DownloadedSong(
          song: item,
          mediaSourceInfo: mediaSourceInfo[0],
          downloadId: downloadId);

      // Adds the current song to the downloaded items box with its media info and download id
      _downloadedItemsBox.put(item.id, songInfo);

      // Adds the current song to the downloaded albums box
      DownloadedAlbum albumTemp = _downloadedAlbumsBox.get(parent.id);
      albumTemp.children.add(item);
      _downloadedAlbumsBox.put(parent.id, albumTemp);

      // Adds the download id and the item id to the download ids box so that we can track the download id back to the actual song

      _downloadIdsBox.put(downloadId, songInfo);
    }
  }

  // TODO: Make a system so that downloads get categorised into what albums/playlists they group into for offline play.
  // For example: New song gets downloaded, it isn't from an album/playlist with any downloaded items so make a new album/playlist entry in a db (maybe hive?)
  // Every time an item is deleted, we must check if it means that an album/playlist ends up with 0 downloads so that we remove it from the db
  // Each album/playlist entry should have a property that saves if the user is explicitly downloading that album/playlist so that it can be synced.

  /// Downloads an item and adds it to the database of explicitly downloaded items.
  /// This should be used when downloading stuff like albums and playlists so they can be synced.
  // Future<void> explicitlyDownloadItem(
  //     {BaseItemDto item, List<BaseItemDto> children}) async {
  //   Box explicitlyDownloadedItems =
  //       await Hive.openBox("explicitlyDownloadedItems");
  //   await explicitlyDownloadedItems.add(item);
  //   List<Future> addDownloadsFutures = [];
  //   children.forEach((element) {
  //     addDownloadsFutures.add(addDownloads([element]));
  //   });
  //   await Future.wait(addDownloadsFutures);
  // }

  /// Gets the download status for the given item id (Jellyfin item id, not flutter_downloader task id).
  /// If itemId-DownloadId.txt doesn't exist, it is assumed that the item is not downloaded. If this is the case, null is returned.
  /// Throws an error if more than one download status exists or if the query doesn't return anything despite itemId-DownloadId.txt existing.
  Future<List<DownloadTask>> getDownloadStatus(List<String> itemIds) async {
    List<String> downloadIds = [];

    for (final itemId in itemIds) {
      if (_downloadedItemsBox.containsKey(itemId)) {
        downloadIds.add(_downloadedItemsBox.get(itemId).downloadId);
      }
    }
    List<DownloadTask> downloadStatuses =
        await FlutterDownloader.loadTasksWithRawQuery(
            query:
                "SELECT * FROM task WHERE task_id IN ${_dartListToSqlList(downloadIds)}");
    return downloadStatuses;
  }

  /// Deletes download tasks from storage and removes the txt/json files for that download task
  Future<void> deleteDownloads(List<DownloadTask> downloadTasks) async {
    List<Future> deleteTaskFutures = [];

    for (final downloadTask in downloadTasks) {
      print("deleting ${downloadTask.filename}");
      deleteTaskFutures.add(FlutterDownloader.remove(
          taskId: downloadTask.taskId, shouldDeleteContent: true));
      DownloadedSong item = _downloadIdsBox.get(downloadTask.taskId);
      // deleteTaskFutures.addAll([
      //   File("${songDir.path}/$item-MediaSourceInfo.json").delete(),
      //   File("${songDir.path}/$itemId-DownloadId.txt").delete(),
      //   File("${songDir.path}/${downloadTask.taskId}-ItemId.txt").delete()
      // ]);
      _downloadedItemsBox.delete(item.song.id);
      _downloadedAlbumsBox.delete(item.song.parentId);
      _downloadIdsBox.delete(downloadTask.taskId);
    }

    await Future.wait(deleteTaskFutures);
  }

  /// Converts a dart list to a string with the correct SQL syntax
  String _dartListToSqlList(List dartList) {
    String sqlList = "(";
    int i = 0;
    for (final element in dartList) {
      sqlList += "'${element.toString()}'";
      if (i != (dartList.length - 1)) {
        sqlList += ", ";
      }
      i++;
    }
    sqlList += ")";
    return sqlList;
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

@HiveType(typeId: 3)
class DownloadedSong {
  DownloadedSong({this.song, this.mediaSourceInfo, this.downloadId});

  @HiveField(0)
  final BaseItemDto song;
  @HiveField(1)
  final MediaSourceInfo mediaSourceInfo;
  @HiveField(2)
  final String downloadId;
}

@HiveType(typeId: 4)
class DownloadedAlbum {
  DownloadedAlbum({this.album, this.children});

  @HiveField(0)
  final BaseItemDto album;
  @HiveField(1)
  final List<BaseItemDto> children;
}
