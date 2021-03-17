import 'dart:io';

import 'package:flutter/foundation.dart';
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
  Box<DownloadedSong> downloadedItemsBox = Hive.box("DownloadedItems");
  Box<DownloadedAlbum> downloadedAlbumsBox = Hive.box("DownloadedAlbums");
  Box<DownloadedSong> _downloadIdsBox = Hive.box("DownloadIds");

  Future<void> addDownloads(
      {List<BaseItemDto> items, BaseItemDto parent}) async {
    Directory songDir = await _getSongDir();
    String baseUrl = await _jellyfinApiData.getBaseUrl();

    for (final item in items) {
      if (downloadedItemsBox.containsKey(item.id)) {
        // If the item already exists, add the parent item to its requiredBy field and skip actually downloading the song
        DownloadedSong itemFromBox = downloadedItemsBox.get(item.id);
        itemFromBox.requiredBy.add(parent.id);
        downloadedItemsBox.put(item.id, itemFromBox);
        continue;
      }
      if (!downloadedAlbumsBox.containsKey(item.parentId)) {
        // If the current album doesn't exist, add the album to the box of albums
        print(
            "Album ${parent.name} (${parent.id}) not in albums box, adding now.");
        downloadedAlbumsBox.put(
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
          downloadId: downloadId,
          requiredBy: [parent.id]);

      // Adds the current song to the downloaded items box with its media info and download id
      downloadedItemsBox.put(item.id, songInfo);

      // Adds the current song to the downloaded albums box
      DownloadedAlbum albumTemp = downloadedAlbumsBox.get(parent.id);
      albumTemp.children.add(item);
      downloadedAlbumsBox.put(parent.id, albumTemp);

      // Adds the download id and the item id to the download ids box so that we can track the download id back to the actual song

      _downloadIdsBox.put(downloadId, songInfo);
    }
  }

  /// Gets the download status for the given item id (Jellyfin item id, not flutter_downloader task id).
  /// If itemId-DownloadId.txt doesn't exist, it is assumed that the item is not downloaded. If this is the case, null is returned.
  /// Throws an error if more than one download status exists or if the query doesn't return anything despite itemId-DownloadId.txt existing.
  Future<List<DownloadTask>> getDownloadStatus(List<String> itemIds) async {
    List<String> downloadIds = [];

    for (final itemId in itemIds) {
      if (downloadedItemsBox.containsKey(itemId)) {
        downloadIds.add(downloadedItemsBox.get(itemId).downloadId);
      }
    }
    List<DownloadTask> downloadStatuses =
        await FlutterDownloader.loadTasksWithRawQuery(
            query:
                "SELECT * FROM task WHERE task_id IN ${_dartListToSqlList(downloadIds)}");
    return downloadStatuses;
  }

  /// Deletes download tasks for items with ids in jellyfinItemIds from storage and removes the Hive entries for that download task
  Future<void> deleteDownloads(
      List<String> jellyfinItemIds, String deletedFor) async {
    List<Future> deleteTaskFutures = [];

    for (final jellyfinItemId in jellyfinItemIds) {
      DownloadedSong downloadedSong = downloadedItemsBox.get(jellyfinItemId);

      if (downloadedSong == null) {
        print(
            "Could not find $jellyfinItemId in downloadedItemsBox, assuming already deleted");
      } else {
        print("Removing $deletedFor dependency from ${downloadedSong.song.id}");
        downloadedSong.requiredBy.remove(deletedFor);

        if (downloadedSong.requiredBy.length == 0) {
          print(
              "Item ${downloadedSong.song.id} has no dependencies, deleting files");

          deleteTaskFutures.add(FlutterDownloader.remove(
              taskId: downloadedSong.downloadId, shouldDeleteContent: true));
          deleteTaskFutures
              .add(downloadedItemsBox.delete(downloadedSong.song.id));

          deleteTaskFutures
              .add(_downloadIdsBox.delete(downloadedSong.downloadId));
        }
      }
    }

    await Future.wait(deleteTaskFutures);

    // Create a map of arguments for use in the compute() below
    // We convert the iterable from downloadedItemsBox to a list because compute() can't pass iterables as arguments
    Map<String, dynamic> argsMap = Map();
    argsMap["deletedFor"] = deletedFor;
    argsMap["listToSearch"] = downloadedItemsBox.values.toList();

    // Deletes the album from downloadedAlbumsBox if it is never referenced in downloadedItemsBox.
    // The actual check is run in a compute() since it would hang the UI otherwise.
    // We run this after waiting for deleteTaskFutures to ensure that all downloads have been deleted from downloadedItemsBox
    if (!await compute(_doesContainItem, argsMap)) {
      print(
          "Album no longer has any dependencies, removing entry from downloadedAlbumsBox");

      // We don't await this since we don't depend on the return value
      downloadedAlbumsBox.delete(deletedFor);
    }
  }

  /// Calculates the total file size of the song directory.
  /// Returns the total file size in bytes.
  /// Returns 0 if the directory doesn't exist.
  Future<int> getSongDirSize() async {
    // https://stackoverflow.com/questions/57140112/how-to-get-the-size-of-a-directory-including-its-files
    Directory songDir = await _getSongDir();
    if (await songDir.exists()) {
      int totalSize = 0;
      try {
        await for (FileSystemEntity entity in songDir.list()) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      } catch (e) {
        return Future.error(e);
      }
      return totalSize;
    } else {
      return 0;
    }
  }

  Future<List<DownloadTask>> getIncompleteDownloads() async {
    return await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE status <> 3");
  }

  Future<List<DownloadTask>> getDownloadsWithStatus(
      DownloadTaskStatus downloadTaskStatus) async {
    return await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE status = ${downloadTaskStatus.value}");
  }

  /// Returns the DownloadedSong of the given Flutter Downloader id.
  /// Returns null if the item is not found.
  DownloadedSong getJellyfinItemFromDownloadId(String downloadId) {
    return _downloadIdsBox.get(downloadId);
  }

  /// Checks if an item with the key albumId exists in downloadedAlbumsBox.
  bool isAlbumDownloaded(String albumId) =>
      downloadedAlbumsBox.containsKey(albumId);

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
  DownloadedSong({
    this.song,
    this.mediaSourceInfo,
    this.downloadId,
    this.requiredBy,
  });

  /// The Jellyfin item for the song
  @HiveField(0)
  final BaseItemDto song;

  /// The media source info for the song (used to get file format)
  @HiveField(1)
  final MediaSourceInfo mediaSourceInfo;

  /// The download ID of the song (for FlutterDownloader)
  @HiveField(2)
  final String downloadId;

  /// The list of parent item IDs the item is downloaded for. If this is 0, the song should be deleted
  @HiveField(3)
  final List<String> requiredBy;
}

@HiveType(typeId: 4)
class DownloadedAlbum {
  DownloadedAlbum({this.album, this.children});

  @HiveField(0)
  final BaseItemDto album;
  @HiveField(1)
  final List<BaseItemDto> children;
}

/// Checks if the given List<DownloadedSong>'s requiredBys contains deletedFor.
/// This function is only used in deleteDownloads().
/// This function was only made so that it can be run in a compute().
/// It's also why it takes a map of args instead of just having multiple arguments.
bool _doesContainItem(Map<String, dynamic> args) {
  return args["listToSearch"]
      .map((e) => e.requiredBy)
      .contains(args["deletedFor"]);
}
