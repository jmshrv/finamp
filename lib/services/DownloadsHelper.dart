import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';

import 'JellyfinApiData.dart';
import '../models/JellyfinModels.dart';

part 'DownloadsHelper.g.dart';

class DownloadsHelper {
  List<String> queue = [];
  JellyfinApiData _jellyfinApiData = GetIt.instance<JellyfinApiData>();
  Box<DownloadedSong> _downloadedItemsBox = Hive.box("DownloadedItems");
  Box<DownloadedParent> _downloadedParentsBox = Hive.box("DownloadedParents");
  Box<DownloadedSong> _downloadIdsBox = Hive.box("DownloadIds");
  final downloadsLogger = Logger("DownloadsHelper");

  Future<void> addDownloads({
    @required List<BaseItemDto> items,
    @required BaseItemDto parent,
    @required Directory downloadBaseDir,
    @required bool useHumanReadableNames,
  }) async {
    // Check if we have external storage permission.
    // It's a bit of a hack, but we only do this if useHumanReadableNames is true because if it's true, we're downloading to a user location.
    // You wouldn't want the app asking for permission when using internal storage.
    if (useHumanReadableNames) {
      if (!await Permission.storage.request().isGranted) {
        downloadsLogger.severe("Storage permission is not granted, exiting");
        return Future.error(
            "Storage permission is required for external storage");
      }
    }

    try {
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

        String fileName;
        Directory downloadDir;
        if (useHumanReadableNames) {
          fileName =
              "${item.album} - ${item.indexNumber == null ? 0 : item.indexNumber} - ${item.name}.${mediaSourceInfo[0].container}";
          downloadDir =
              Directory(downloadBaseDir.path + "/${item.albumArtist}");

          if (!await downloadDir.exists()) {
            await downloadDir.create();
          }
        } else {
          fileName = item.id + ".${mediaSourceInfo[0].container}";
          downloadDir = Directory(downloadBaseDir.path);
        }

        String downloadId = await FlutterDownloader.enqueue(
          url: songUrl,
          savedDir: downloadDir.path,
          headers: {
            // "X-Emby-Authorization": await _jellyfinApiData.getAuthHeader(),
            "X-Emby-Token": _jellyfinApiData.getTokenHeader()
          },
          fileName: fileName,
          openFileFromNotification: false,
          showNotification: false,
        );

        DownloadedSong songInfo = DownloadedSong(
          song: item,
          mediaSourceInfo: mediaSourceInfo[0],
          downloadId: downloadId,
          requiredBy: [parent.id],
          path: "${downloadDir.path}/$fileName",
          useHumanReadableNames: useHumanReadableNames,
        );

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

            downloadsLogger.info(
                "Deleting ${downloadedSong.downloadId} from flutter_downloader");
            FlutterDownloader.remove(
              taskId: downloadedSong.downloadId,
              shouldDeleteContent: true,
            );

            _downloadedItemsBox.delete(jellyfinItemId);

            _downloadIdsBox.delete(downloadedSong.downloadId);

            DownloadedParent downloadedAlbumTemp =
                _downloadedParentsBox.get(deletedFor);
            if (_downloadedParentsBox != null) {
              downloadedAlbumTemp.downloadedChildren.remove(jellyfinItemId);
              _downloadedParentsBox.put(deletedFor, downloadedAlbumTemp);
            }

            if (downloadedSong.useHumanReadableNames == null) {
              downloadedSong.useHumanReadableNames = false;
            }

            if (downloadedSong.useHumanReadableNames) {
              Directory songDirectory = Directory(downloadedSong.path);
              var x = await songDirectory.parent.list().isEmpty;
              if (await songDirectory.parent.list().isEmpty) {
                await songDirectory.parent.delete();
              }
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

  /// Calculates the total file size of the given directory.
  /// Returns the total file size in bytes.
  /// Returns 0 if the directory doesn't exist.
  Future<int> getDirSize(Directory directory) async {
    try {
      // https://stackoverflow.com/questions/57140112/how-to-get-the-size-of-a-directory-including-its-files
      if (await directory.exists()) {
        int totalSize = 0;
        try {
          await for (FileSystemEntity entity in directory.list()) {
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
    @required this.song,
    @required this.mediaSourceInfo,
    @required this.downloadId,
    @required this.requiredBy,
    @required this.path,
    @required this.useHumanReadableNames,
  });

  /// The Jellyfin item for the song
  @HiveField(0)
  BaseItemDto song;

  /// The media source info for the song (used to get file format)
  @HiveField(1)
  MediaSourceInfo mediaSourceInfo;

  /// The download ID of the song (for FlutterDownloader)
  @HiveField(2)
  String downloadId;

  /// The list of parent item IDs the item is downloaded for. If this is 0, the song should be deleted
  @HiveField(3)
  List<String> requiredBy;

  /// The path of the song file
  @HiveField(4)
  String path;

  /// Whether or not the file is stored with a human readable name. We need this when deleting downloads,
  /// as we need to check for empty folders when deleting files with human readable names.
  @HiveField(5)
  bool useHumanReadableNames;
}

@HiveType(typeId: 4)
class DownloadedParent {
  DownloadedParent({
    this.item,
    this.downloadedChildren,
  });

  @HiveField(0)
  BaseItemDto item;
  @HiveField(1)
  Map<String, BaseItemDto> downloadedChildren;
}
