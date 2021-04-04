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

    for (final item in items) {
      if (_downloadedItemsBox.containsKey(item.id)) {
        // If the item already exists, add the parent item to its requiredBy field and skip actually downloading the song
        print(
            "Item already exists in downloadedItemsBox, adding requiredBy and skipping");
        DownloadedSong itemFromBox = _downloadedItemsBox.get(item.id);
        itemFromBox.requiredBy.add(parent.id);
        _downloadedItemsBox.put(item.id, itemFromBox);
        continue;
      }
      if (!_downloadedAlbumsBox.containsKey(parent.id)) {
        // If the current album doesn't exist, add the album to the box of albums
        print(
            "Album ${parent.name} (${parent.id}) not in albums box, adding now.");
        _downloadedAlbumsBox.put(
            parent.id, DownloadedAlbum(album: parent, downloadedChildren: {}));
      }

      String songUrl =
          _jellyfinApiData.currentUser.baseUrl + "/Items/${item.id}/File";

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
      _downloadedItemsBox.put(item.id, songInfo);

      // Adds the current song to the downloaded albums box
      DownloadedAlbum albumTemp = _downloadedAlbumsBox.get(parent.id);
      albumTemp.downloadedChildren[item.id] = item;
      _downloadedAlbumsBox.put(parent.id, albumTemp);

      // Adds the download id and the item id to the download ids box so that we can track the download id back to the actual song

      _downloadIdsBox.put(downloadId, songInfo);
    }
  }

  /// Gets the download status for the given item ids (Jellyfin item id, not flutter_downloader task id).
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

  /// Deletes download tasks for items with ids in jellyfinItemIds from storage and removes the Hive entries for that download task
  Future<void> deleteDownloads(
      List<String> jellyfinItemIds, String deletedFor) async {
    for (final jellyfinItemId in jellyfinItemIds) {
      DownloadedSong downloadedSong = _downloadedItemsBox.get(jellyfinItemId);

      if (downloadedSong == null) {
        print(
            "Could not find $jellyfinItemId in downloadedItemsBox, assuming already deleted");
      } else {
        print("Removing $deletedFor dependency from $jellyfinItemId");
        downloadedSong.requiredBy.remove(deletedFor);

        if (downloadedSong.requiredBy.length == 0) {
          print("Item $jellyfinItemId has no dependencies, deleting files");

          FlutterDownloader.remove(
              taskId: downloadedSong.downloadId, shouldDeleteContent: true);

          _downloadedItemsBox.delete(jellyfinItemId);

          _downloadIdsBox.delete(downloadedSong.downloadId);

          DownloadedAlbum downloadedAlbumTemp =
              _downloadedAlbumsBox.get(deletedFor);
          if (_downloadedAlbumsBox != null) {
            downloadedAlbumTemp.downloadedChildren.remove(jellyfinItemId);
            _downloadedAlbumsBox.put(deletedFor, downloadedAlbumTemp);
          }
        }
      }
    }

    // Deletes the album from downloadedAlbumsBox if it is never referenced in downloadedItemsBox.
    // I'm pretty sure this is why the app freezes for a few seconds while deleting items, but I can't think of a better way to do this.
    if (_downloadedAlbumsBox.get(deletedFor).downloadedChildren.isEmpty) {
      print(
          "Album no longer has any downloaded children, removing entry from downloadedAlbumsBox");

      // We don't await this since we don't depend on the return value
      _downloadedAlbumsBox.delete(deletedFor);
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
      _downloadedAlbumsBox.containsKey(albumId);

  DownloadedSong getDownloadedSong(String id) => _downloadedItemsBox.get(id);

  Iterable<DownloadedAlbum> get downloadedAlbums => _downloadedAlbumsBox.values;
  Iterable<DownloadedSong> get downloadedItems => _downloadedItemsBox.values;

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
  DownloadedAlbum({this.album, this.downloadedChildren});

  @HiveField(0)
  final BaseItemDto album;
  @HiveField(1)
  final Map<String, BaseItemDto> downloadedChildren;
}
