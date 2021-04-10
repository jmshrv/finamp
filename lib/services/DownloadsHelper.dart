import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';

import 'JellyfinApiData.dart';
import '../models/JellyfinModels.dart';

part 'DownloadsHelper.g.dart';

class DownloadsHelper {
  List<String> queue = [];
  Directory _songDir;
  JellyfinApiData _jellyfinApiData = GetIt.instance<JellyfinApiData>();
  Box<DownloadedSong> _downloadedItemsBox = Hive.box("DownloadedItems");
  Box<DownloadedParent> _downloadedParentsBox = Hive.box("DownloadedParents");
  Box<DownloadedSong> _downloadIdsBox = Hive.box("DownloadIds");
  final downloadsLogger = Logger("DownloadsHelper");

  Future<void> addDownloads(
      {List<BaseItemDto> items, BaseItemDto parent}) async {
    try {
      Directory songDir = await _getSongDir();

      if (!_downloadedParentsBox.containsKey(parent.id)) {
        // If the current album doesn't exist, add the album to the box of albums
        downloadsLogger.info(
            "Album ${parent.name} (${parent.id}) not in albums box, adding now.");
        _downloadedParentsBox.put(
            parent.id, DownloadedParent(item: parent, downloadedChildren: {}));
      }

      for (final item in items) {
        if (_downloadedItemsBox.containsKey(item.id)) {
          // If the item already exists, add the parent item to its requiredBy field and skip actually downloading the song.
          // We also add the item to the downloadedChildren of the parent that we're downloading.
          downloadsLogger.info(
              "Item ${item.id} already exists in downloadedItemsBox, adding requiredBy to DownloadedItem and adding to ${parent.id}'s downloadedChildren");
          DownloadedSong itemFromBox = _downloadedItemsBox.get(item.id);
          itemFromBox.requiredBy.add(parent.id);
          _downloadedItemsBox.put(item.id, itemFromBox);
          _addItemToDownloadedAlbum(parent.id, item);
          continue;
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
            "X-Emby-Token": _jellyfinApiData.getTokenHeader()
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

        // Adds the current song to the parent's DownloadedAlbum
        _addItemToDownloadedAlbum(parent.id, item);

        // Adds the download id and the item id to the download ids box so that we can track the download id back to the actual song

        _downloadIdsBox.put(downloadId, songInfo);
      }
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Gets the download status for the given item ids (Jellyfin item id, not flutter_downloader task id).
  Future<List<DownloadTask>> getDownloadStatus(List<String> itemIds) async {
    try {
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
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Deletes download tasks for items with ids in jellyfinItemIds from storage and removes the Hive entries for that download task
  Future<void> deleteDownloads(
      List<String> jellyfinItemIds, String deletedFor) async {
    try {
      for (final jellyfinItemId in jellyfinItemIds) {
        DownloadedSong downloadedSong = _downloadedItemsBox.get(jellyfinItemId);

        if (downloadedSong == null) {
          downloadsLogger.info(
              "Could not find $jellyfinItemId in downloadedItemsBox, assuming already deleted");
        } else {
          downloadsLogger
              .info("Removing $deletedFor dependency from $jellyfinItemId");
          downloadedSong.requiredBy.remove(deletedFor);

          if (downloadedSong.requiredBy.length == 0) {
            downloadsLogger.info(
                "Item $jellyfinItemId has no dependencies, deleting files");

            FlutterDownloader.remove(
                taskId: downloadedSong.downloadId, shouldDeleteContent: true);

            _downloadedItemsBox.delete(jellyfinItemId);

            _downloadIdsBox.delete(downloadedSong.downloadId);

            DownloadedParent downloadedAlbumTemp =
                _downloadedParentsBox.get(deletedFor);
            if (_downloadedParentsBox != null) {
              downloadedAlbumTemp.downloadedChildren.remove(jellyfinItemId);
              _downloadedParentsBox.put(deletedFor, downloadedAlbumTemp);
            }
          }
        }
      }

      _downloadedParentsBox.delete(deletedFor);
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Calculates the total file size of the song directory.
  /// Returns the total file size in bytes.
  /// Returns 0 if the directory doesn't exist.
  Future<int> getSongDirSize() async {
    try {
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
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<List<DownloadTask>> getIncompleteDownloads() async {
    try {
      return await FlutterDownloader.loadTasksWithRawQuery(
          query: "SELECT * FROM task WHERE status <> 3");
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<List<DownloadTask>> getDownloadsWithStatus(
      DownloadTaskStatus downloadTaskStatus) async {
    try {
      return await FlutterDownloader.loadTasksWithRawQuery(
          query:
              "SELECT * FROM task WHERE status = ${downloadTaskStatus.value}");
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Returns the DownloadedSong of the given Flutter Downloader id.
  /// Returns null if the item is not found.
  DownloadedSong getJellyfinItemFromDownloadId(String downloadId) {
    try {
      return _downloadIdsBox.get(downloadId);
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  /// Checks if an item with the key albumId exists in downloadedAlbumsBox.
  bool isAlbumDownloaded(String albumId) {
    try {
      return _downloadedParentsBox.containsKey(albumId);
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  DownloadedSong getDownloadedSong(String id) {
    try {
      return _downloadedItemsBox.get(id);
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  DownloadedParent getDownloadedParent(String id) {
    try {
      return _downloadedParentsBox.get(id);
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  Iterable<DownloadedParent> get downloadedParents {
    try {
      return _downloadedParentsBox.values;
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  Iterable<DownloadedSong> get downloadedItems {
    try {
      return _downloadedItemsBox.values;
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  /// Converts a dart list to a string with the correct SQL syntax
  String _dartListToSqlList(List dartList) {
    try {
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
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  Future<Directory> _getSongDir() async {
    try {
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
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Adds an item to a DownloadedAlbum's downloadedChildren map
  void _addItemToDownloadedAlbum(String albumId, BaseItemDto item) {
    try {
      DownloadedParent albumTemp = _downloadedParentsBox.get(albumId);
      albumTemp.downloadedChildren[item.id] = item;
      _downloadedParentsBox.put(albumId, albumTemp);
    } catch (e) {
      downloadsLogger.severe(e);
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
class DownloadedParent {
  DownloadedParent({this.item, this.downloadedChildren});

  @HiveField(0)
  final BaseItemDto item;
  @HiveField(1)
  final Map<String, BaseItemDto> downloadedChildren;
}
