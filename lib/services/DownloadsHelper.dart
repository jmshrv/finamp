import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
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
  Box<DownloadedImage> _downloadedImagesBox = Hive.box("DownloadedImages");
  final downloadsLogger = Logger("DownloadsHelper");

  Future<void> addDownloads({
    required List<BaseItemDto> items,
    required BaseItemDto parent,
    required Directory downloadBaseDir,
    required bool useHumanReadableNames,

    /// The view that this download is in. Used for sorting in offline mode.
    required String viewId,
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
            parent.id,
            DownloadedParent(
                item: parent, downloadedChildren: {}, viewId: viewId));
      }

      for (final item in items) {
        if (_downloadedItemsBox.containsKey(item.id)) {
          // If the item already exists, add the parent item to its requiredBy field and skip actually downloading the song.
          // We also add the item to the downloadedChildren of the parent that we're downloading.
          downloadsLogger.info(
              "Item ${item.id} already exists in downloadedItemsBox, adding requiredBy to DownloadedItem and adding to ${parent.id}'s downloadedChildren");

          // This is technically nullable but we check if it contains the key
          // in order to get to this point.
          DownloadedSong itemFromBox = _downloadedItemsBox.get(item.id)!;

          itemFromBox.requiredBy.add(parent.id);
          addDownloadedSong(itemFromBox);
          _addItemToDownloadedAlbum(parent.id, item);
          continue;
        }

        // Base URL shouldn't be null at this point (user has to be logged in
        // to get to the point where they can add downloads).
        String songUrl =
            _jellyfinApiData.currentUser!.baseUrl + "/Items/${item.id}/File";

        List<MediaSourceInfo>? mediaSourceInfo =
            await _jellyfinApiData.getPlaybackInfo(item.id);

        String fileName;
        Directory downloadDir;
        if (useHumanReadableNames) {
          if (mediaSourceInfo == null) {
            downloadsLogger.warning(
                "Media source info for ${item.id} returned null, filename may be weird.");
          }
          // We use a regex to filter out bad characters from song/album names.
          fileName =
              "${item.album?.replaceAll(RegExp('[\/\?\<>\\:\*\|\"]'), "_")} - ${item.indexNumber ?? 0} - ${item.name?.replaceAll(RegExp('[\/\?\<>\\:\*\|\"]'), "_")}.${mediaSourceInfo?[0].container}";
          downloadDir =
              Directory(downloadBaseDir.path + "/${item.albumArtist}");

          if (!await downloadDir.exists()) {
            await downloadDir.create();
          }
        } else {
          fileName = item.id + ".${mediaSourceInfo?[0].container}";
          downloadDir = Directory(downloadBaseDir.path);
        }

        String? tokenHeader = _jellyfinApiData.getTokenHeader();

        String? songDownloadId = await FlutterDownloader.enqueue(
          url: songUrl,
          savedDir: downloadDir.path,
          headers: {
            if (tokenHeader != null) "X-Emby-Token": tokenHeader,
          },
          fileName: fileName,
          openFileFromNotification: false,
          showNotification: false,
        );

        if (songDownloadId == null) {
          downloadsLogger.severe(
              "Adding download for ${item.id} failed! downloadId is null. This only really happens if something goes horribly wrong with flutter_downloader's platform interface. This should never happen...");
        }
        DownloadedSong songInfo = DownloadedSong(
          song: item,
          mediaSourceInfo: mediaSourceInfo![0],
          downloadId: songDownloadId!,
          requiredBy: [parent.id],
          path: "${downloadDir.path}/$fileName",
          useHumanReadableNames: useHumanReadableNames,
          viewId: viewId,
        );

        // Adds the current song to the downloaded items box with its media info and download id
        addDownloadedSong(songInfo);

        // Adds the current song to the parent's DownloadedAlbum
        _addItemToDownloadedAlbum(parent.id, item);

        // Adds the download id and the item id to the download ids box so that we can track the download id back to the actual song

        _downloadIdsBox.put(songDownloadId, songInfo);

        // Get the image ID for the downloaded image
        final imageId = _jellyfinApiData.getImageId(item);

        // If the item has an image ID, handle getting/noting the downloaded
        // image.
        if (imageId != null) {
          if (_downloadedImagesBox.containsKey(imageId)) {
            downloadsLogger.info(
                "Image $imageId already exists in downloadedImagesBox, adding requiredBySong to DownloadedImage.");

            final downloadedImage = _downloadedImagesBox.get(imageId)!;

            downloadedImage.requiredBySongs.add(item.id);

            _addDownloadImageToDownloadedImages(downloadedImage);
          } else {
            // If the image is not downloaded, download it. This is very similar
            // to downloading the song.
            final imageUrl = _jellyfinApiData.getImageUrl(item: item);

            final imagePath = "${downloadDir.path}/$imageId";

            final imageDownloadId = await FlutterDownloader.enqueue(
              url: imageUrl.toString(),
              savedDir: downloadDir.path,
              headers: {
                if (tokenHeader != null) "X-Emby-Token": tokenHeader,
              },
              fileName: imageId,
              openFileFromNotification: false,
              showNotification: false,
            );

            if (imageDownloadId == null) {
              downloadsLogger.severe(
                  "Adding image download for $imageId failed! downloadId is null. This only really happens if something goes horribly wrong with flutter_downloader's platform interface. This should never happen...");
            }

            final imageInfo = DownloadedImage.create(
              id: imageId,
              downloadId: imageDownloadId!,
              path: imagePath,
              requiredBySongs: [item.id],
            );

            _addDownloadImageToDownloadedImages(imageInfo);
          }
        }
      }
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Gets the download status for the given item ids (Jellyfin item id, not flutter_downloader task id).
  Future<List<DownloadTask>?> getDownloadStatus(List<String> itemIds) async {
    try {
      List<String> downloadIds = [];

      for (final itemId in itemIds) {
        if (_downloadedItemsBox.containsKey(itemId)) {
          // _downloadedItemsBox.get shouldn't return null as an item with the
          // key itemId already exists.
          downloadIds.add(_downloadedItemsBox.get(itemId)!.downloadId);
        }
      }
      List<DownloadTask>? downloadStatuses =
          await FlutterDownloader.loadTasksWithRawQuery(
              query:
                  "SELECT * FROM task WHERE task_id IN ${_dartListToSqlList(downloadIds)}");
      return downloadStatuses;
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Deletes download tasks for items with ids in jellyfinItemIds from storage
  /// and removes the Hive entries for that download task. If deletedFor is
  /// specified, also do checks to delete the parent album. The only time
  /// deletedFor is not specified is when a user plays a song that has been
  /// manually deleted.
  Future<void> deleteDownloads({
    required List<String> jellyfinItemIds,
    String? deletedFor,
  }) async {
    try {
      List<Future> deleteDownloadFutures = [];
      Map<String, Directory> directoriesToCheck = {};

      for (final jellyfinItemId in jellyfinItemIds) {
        DownloadedSong? downloadedSong =
            _downloadedItemsBox.get(jellyfinItemId);

        if (downloadedSong == null) {
          downloadsLogger.info(
              "Could not find $jellyfinItemId in downloadedItemsBox, assuming already deleted");
        } else {
          if (deletedFor != null) {
            downloadsLogger
                .info("Removing $deletedFor dependency from $jellyfinItemId");
            downloadedSong.requiredBy.remove(deletedFor);
          }

          if (downloadedSong.requiredBy.length == 0 || deletedFor == null) {
            downloadsLogger.info(
                "Item $jellyfinItemId has no dependencies or was manually deleted, deleting files");

            downloadsLogger.info(
                "Deleting ${downloadedSong.downloadId} from flutter_downloader");
            deleteDownloadFutures.add(FlutterDownloader.remove(
              taskId: downloadedSong.downloadId,
              shouldDeleteContent: true,
            ));

            _downloadedItemsBox.delete(jellyfinItemId);

            _downloadIdsBox.delete(downloadedSong.downloadId);

            if (deletedFor != null) {
              DownloadedParent? downloadedAlbumTemp =
                  _downloadedParentsBox.get(deletedFor);
              if (downloadedAlbumTemp != null) {
                downloadedAlbumTemp.downloadedChildren.remove(jellyfinItemId);
                _downloadedParentsBox.put(deletedFor, downloadedAlbumTemp);
              }
            }

            // We only have to care about deleting directories if files are
            // stored with human readable file names.
            if (downloadedSong.useHumanReadableNames) {
              // We use the parent here since downloadedSong.path still includes
              // the filename. We assume that downloadedSong.path is not null,
              // as if downloadedSong.useHumanReadableNames is true, the path
              // would have been set at some point.
              Directory songDirectory = Directory(downloadedSong.path).parent;

              if (!directoriesToCheck.containsKey(songDirectory.path)) {
                // Add the directory to the directory map.
                // We keep the directories in a map so that we can easily check
                // for duplicates.
                directoriesToCheck[songDirectory.path] = songDirectory;
              }
            }
          }
        }
      }

      await Future.wait(deleteDownloadFutures);

      directoriesToCheck.values.forEach((element) async {
        // Loop through each directory and check if it's empty. If it is, delete the directory.
        if (await element.list().isEmpty) {
          downloadsLogger.info("${element.path} is empty, deleting");
          element.delete();
        }
      });

      if (deletedFor != null) {
        _downloadedParentsBox.delete(deletedFor);
      }
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

  Future<List<DownloadTask>?> getIncompleteDownloads() async {
    try {
      return await FlutterDownloader.loadTasksWithRawQuery(
          query: "SELECT * FROM task WHERE status <> 3");
    } catch (e) {
      downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<List<DownloadTask>?> getDownloadsWithStatus(
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
  DownloadedSong? getJellyfinItemFromDownloadId(String downloadId) {
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

  DownloadedSong? getDownloadedSong(String id) {
    try {
      return _downloadedItemsBox.get(id);
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  DownloadedParent? getDownloadedParent(String id) {
    try {
      return _downloadedParentsBox.get(id);
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  DownloadedImage? getDownloadedImage(String id) {
    try {
      return _downloadedImagesBox.get(id);
    } catch (e) {
      downloadsLogger.severe(e);
      rethrow;
    }
  }

  /// Adds a song to the database. If a song with the same ID already exists, it
  /// is overwritten.
  void addDownloadedSong(DownloadedSong newDownloadedSong) {
    _downloadedItemsBox.put(newDownloadedSong.song.id, newDownloadedSong);
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

  ValueListenable<Box<DownloadedSong>> getDownloadedItemsListenable(
      {List<String>? keys}) {
    try {
      return _downloadedItemsBox.listenable(keys: keys);
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
      DownloadedParent? albumTemp = _downloadedParentsBox.get(albumId);

      if (albumTemp == null) {
      } else {
        albumTemp.downloadedChildren[item.id] = item;
        _downloadedParentsBox.put(albumId, albumTemp);
      }
    } catch (e) {
      downloadsLogger.severe(e);
    }
  }

  /// Adds a [DownloadedImage] to the DownloadedImages box
  void _addDownloadImageToDownloadedImages(DownloadedImage downloadedImage) {
    _downloadedImagesBox.put(downloadedImage.id, downloadedImage);
  }
}

@HiveType(typeId: 3)
@JsonSerializable(
  explicitToJson: true,
  anyMap: true,
)
class DownloadedSong {
  DownloadedSong({
    required this.song,
    required this.mediaSourceInfo,
    required this.downloadId,
    required this.requiredBy,
    required this.path,
    required this.useHumanReadableNames,
    required this.viewId,
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

  /// The list of parent item IDs the item is downloaded for. If this is 0, the
  /// song should be deleted.
  @HiveField(3)
  List<String> requiredBy;

  /// The path of the song file. Like useHumanReadableNames, this used to not be
  /// stored (I just hardcoded the song location to a dir in internal storage).
  /// Because of this, the value can still be null.
  @HiveField(4)
  String path;

  /// Whether or not the file is stored with a human readable name. We need this
  /// when deleting downloads, as we need to check for empty folders when
  /// deleting files with human readable names.
  @HiveField(5)
  bool useHumanReadableNames;

  /// The view that this download is in. Used for sorting in offline mode.
  @HiveField(6)
  String viewId;

  factory DownloadedSong.fromJson(Map<String, dynamic> json) =>
      _$DownloadedSongFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadedSongToJson(this);
}

@HiveType(typeId: 4)
class DownloadedParent {
  DownloadedParent({
    required this.item,
    required this.downloadedChildren,
    required this.viewId,
  });

  @HiveField(0)
  BaseItemDto item;
  @HiveField(1)
  Map<String, BaseItemDto> downloadedChildren;

  /// The view that this download is in. Used for sorting in offline mode.
  @HiveField(2)
  String viewId;
}

@HiveType(typeId: 40)
class DownloadedImage {
  DownloadedImage({
    required this.id,
    required this.downloadId,
    required this.path,
    required this.requiredByParents,
    required this.requiredBySongs,
  });

  /// The image ID
  @HiveField(0)
  String id;

  /// The download ID of the song (for FlutterDownloader)
  @HiveField(1)
  String downloadId;

  /// The path to the image file
  @HiveField(2)
  String path;

  /// The number of [DownloadedParent]s that use this image. If this and
  /// [requiredBySongs] are both empty, the image should be deleted.
  @HiveField(3)
  List<String> requiredByParents;

  /// The number of [DownloadedSong]s that use this image. If this and
  /// [requiredByParents] are both empty, the image should be deleted.
  @HiveField(4)
  List<String> requiredBySongs;

  /// The combined lengths of [requiredByParents] and [requiredBySongs]. This is
  /// the total number of songs/parents that use this image. If it's 0, delete
  /// this image.
  int get requiredByCount => requiredByParents.length + requiredBySongs.length;

  /// Creates a new DownloadedImage. Does not actually handle downloading or
  /// anything. This is only really a thing since having to manually specify
  /// empty lists is a bit jank.
  static DownloadedImage create({
    required String id,
    required String downloadId,
    required String path,
    List<String>? requiredByParents,
    List<String>? requiredBySongs,
  }) =>
      DownloadedImage(
        id: id,
        downloadId: downloadId,
        path: path,
        requiredByParents: requiredByParents ?? [],
        requiredBySongs: requiredBySongs ?? [],
      );
}
