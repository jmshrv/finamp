import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path_helper;

import 'FinampSettingsHelper.dart';
import 'itemHasOwnImage.dart';
import 'JellyfinApiData.dart';
import '../models/JellyfinModels.dart';
import '../models/FinampModels.dart';

part 'DownloadsHelper.g.dart';

class DownloadsHelper {
  List<String> queue = [];
  JellyfinApiData _jellyfinApiData = GetIt.instance<JellyfinApiData>();
  Box<DownloadedSong> _downloadedItemsBox = Hive.box("DownloadedItems");
  Box<DownloadedParent> _downloadedParentsBox = Hive.box("DownloadedParents");
  Box<DownloadedSong> _downloadIdsBox = Hive.box("DownloadIds");
  Box<DownloadedImage> _downloadedImagesBox = Hive.box("DownloadedImages");
  Box<String> _downloadedImageIdsBox = Hive.box("DownloadedImageIds");

  final _downloadsLogger = Logger("DownloadsHelper");

  Future<void> addDownloads({
    required List<BaseItemDto> items,
    required BaseItemDto parent,
    required bool useHumanReadableNames,
    required DownloadLocation downloadLocation,

    /// The view that this download is in. Used for sorting in offline mode.
    required String viewId,
  }) async {
    // Check if we have external storage permission.
    // It's a bit of a hack, but we only do this if useHumanReadableNames is true because if it's true, we're downloading to a user location.
    // You wouldn't want the app asking for permission when using internal storage.
    if (useHumanReadableNames) {
      if (!await Permission.storage.request().isGranted) {
        _downloadsLogger.severe("Storage permission is not granted, exiting");
        return Future.error(
            "Storage permission is required for external storage");
      }
    }

    try {
      if (!_downloadedParentsBox.containsKey(parent.id)) {
        // If the current album doesn't exist, add the album to the box of albums
        _downloadsLogger.info(
            "Album ${parent.name} (${parent.id}) not in albums box, adding now.");
        _downloadedParentsBox.put(
            parent.id,
            DownloadedParent(
                item: parent, downloadedChildren: {}, viewId: viewId));
      }

      final parentImageId = _jellyfinApiData.getImageId(parent);

      if (parentImageId != null &&
          !_downloadedImagesBox.containsKey(parentImageId) &&
          itemHasOwnImage(parent)) {
        _downloadsLogger
            .info("Downloading parent image for ${parent.name} (${parent.id}");

        final downloadDir = _getDownloadDirectory(
          item: parent,
          downloadBaseDir: Directory(downloadLocation.path),
          useHumanReadableNames: useHumanReadableNames,
        );

        await _downloadImage(
          item: parent,
          downloadDir: downloadDir,
          downloadLocation: downloadLocation,
        );
      }

      if (_jellyfinApiData.getImageId(parent) != null)
        for (final item in items) {
          if (_downloadedItemsBox.containsKey(item.id)) {
            // If the item already exists, add the parent item to its requiredBy field and skip actually downloading the song.
            // We also add the item to the downloadedChildren of the parent that we're downloading.
            _downloadsLogger.info(
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
          Directory downloadDir = _getDownloadDirectory(
            item: item,
            downloadBaseDir: Directory(downloadLocation.path),
            useHumanReadableNames: useHumanReadableNames,
          );
          if (useHumanReadableNames) {
            if (mediaSourceInfo == null) {
              _downloadsLogger.warning(
                  "Media source info for ${item.id} returned null, filename may be weird.");
            }
            // We use a regex to filter out bad characters from song/album names.
            fileName =
                "${item.album?.replaceAll(RegExp('[\/\?\<>\\:\*\|\"]'), "_")} - ${item.indexNumber ?? 0} - ${item.name?.replaceAll(RegExp('[\/\?\<>\\:\*\|\"]'), "_")}.${mediaSourceInfo?[0].container}";

            if (!await downloadDir.exists()) {
              await downloadDir.create();
            }
          } else {
            fileName = item.id + ".${mediaSourceInfo?[0].container}";
            downloadDir = Directory(downloadLocation.path);
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
            _downloadsLogger.severe(
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
            downloadLocationId: downloadLocation.id,
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
              _downloadsLogger.info(
                  "Image $imageId already exists in downloadedImagesBox, adding requiredBySong to DownloadedImage.");

              final downloadedImage = _downloadedImagesBox.get(imageId)!;

              downloadedImage.requiredBySongs.add(item.id);

              _addDownloadImageToDownloadedImages(downloadedImage);
            } else if (itemHasOwnImage(item)) {
              _downloadsLogger.info(
                  "Downloading image for ${item.name} (${item.id}) as it has its own image");
              await _downloadImage(
                  item: item,
                  downloadDir: downloadDir,
                  downloadLocation: downloadLocation);
            }
          }
        }
    } catch (e) {
      _downloadsLogger.severe(e);
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
      _downloadsLogger.severe(e);
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
          _downloadsLogger.info(
              "Could not find $jellyfinItemId in downloadedItemsBox, assuming already deleted");
        } else {
          if (deletedFor != null) {
            _downloadsLogger
                .info("Removing $deletedFor dependency from $jellyfinItemId");
            downloadedSong.requiredBy.remove(deletedFor);
          }

          if (downloadedSong.requiredBy.length == 0 || deletedFor == null) {
            _downloadsLogger.info(
                "Item $jellyfinItemId has no dependencies or was manually deleted, deleting files");

            _downloadsLogger.info(
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
          _downloadsLogger.info("${element.path} is empty, deleting");
          element.delete();
        }
      });

      if (deletedFor != null) {
        _downloadedParentsBox.delete(deletedFor);
      }
    } catch (e) {
      _downloadsLogger.severe(e);
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
      _downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<List<DownloadTask>?> getIncompleteDownloads() async {
    try {
      return await FlutterDownloader.loadTasksWithRawQuery(
          query: "SELECT * FROM task WHERE status <> 3");
    } catch (e) {
      _downloadsLogger.severe(e);
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
      _downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Returns the DownloadedSong of the given Flutter Downloader id.
  /// Returns null if the item is not found.
  DownloadedSong? getJellyfinItemFromDownloadId(String downloadId) {
    try {
      return _downloadIdsBox.get(downloadId);
    } catch (e) {
      _downloadsLogger.severe(e);
      rethrow;
    }
  }

  /// Returns the DownloadedImage of the given Flutter Downloader id.
  /// Returns null if the item is not found.
  DownloadedImage? getDownloadedImageFromDownloadId(String downloadId) {
    try {
      return _downloadedImagesBox.get(_downloadedImageIdsBox.get(downloadId));
    } catch (e) {
      _downloadsLogger.severe(e);
      rethrow;
    }
  }

  /// Checks if an item with the key albumId exists in downloadedAlbumsBox.
  bool isAlbumDownloaded(String albumId) {
    try {
      return _downloadedParentsBox.containsKey(albumId);
    } catch (e) {
      _downloadsLogger.severe(e);
      rethrow;
    }
  }

  DownloadedSong? getDownloadedSong(String id) {
    try {
      return _downloadedItemsBox.get(id);
    } catch (e) {
      _downloadsLogger.severe(e);
      rethrow;
    }
  }

  DownloadedParent? getDownloadedParent(String id) {
    try {
      return _downloadedParentsBox.get(id);
    } catch (e) {
      _downloadsLogger.severe(e);
      rethrow;
    }
  }

  /// Checks if a DownloadedSong is actually downloaded, and fixes common issues
  /// related to downloads (such as changed appdirs). Returns true if the song
  /// is downloaded, and false otherwise.
  Future<bool> verifyDownloadedSong(DownloadedSong downloadedSong) async {
    final downloadTaskList = await getDownloadStatus([downloadedSong.song.id]);

    if (downloadTaskList == null) {
      _downloadsLogger.warning(
          "Download task list for ${downloadedSong.downloadId} (${downloadedSong.song.id}) returned null, assuming item not downloaded");
      return false;
    }

    final downloadTask = downloadTaskList[0];

    if (downloadTask.status == DownloadTaskStatus.complete) {
      _downloadsLogger.info(
          "Song ${downloadedSong.song.id} exists offline, using local file");

      // Here we check if the file exists. This is important for
      // human-readable files, since the user could have deleted the file. iOS
      // also likes to move around the documents path after updates for some
      // reason.
      if (!await File(downloadedSong.path).exists()) {
        // Songs that don't use human readable names should be in the
        // documents path, so we check if its changed.
        if (!downloadedSong.useHumanReadableNames) {
          _downloadsLogger.warning(
              "${downloadedSong.path} not found! Checking if the document directory has moved.");

          final currentDocumentsDirectory =
              await getApplicationDocumentsDirectory();
          DownloadLocation internalStorageLocation =
              FinampSettingsHelper.finampSettings.internalSongDir;

          // If the song path doesn't contain the current path, assume the
          // path has changed.
          if (!downloadedSong.path.contains(currentDocumentsDirectory.path)) {
            _downloadsLogger.warning(
                "Song does not contain documents directory, assuming moved.");

            if (internalStorageLocation.path !=
                "${currentDocumentsDirectory.path}/songs") {
              // Append /songs to the documents directory and create the new
              // song dir if it doesn't exist for some reason.
              final newSongDir =
                  Directory("${currentDocumentsDirectory.path}/songs");

              _downloadsLogger.warning(
                  "Difference found in settings documents paths. Changing ${internalStorageLocation.path} to ${newSongDir.path} in settings.");

              // Set the new path in FinampSettings.
              internalStorageLocation =
                  await FinampSettingsHelper.resetDefaultDownloadLocation();
            }

            // Recreate the downloaded song path with the new documents
            // directory.
            // downloadedSong.path =
            //     "${currentDocumentsDirectory.path}/songs/${downloadedSong.song.id}.${downloadedSong.mediaSourceInfo.container}";
            if (!downloadedSong.isPathRelative) {
              downloadedSong.path =
                  '${downloadedSong.song.id}.${downloadedSong.mediaSourceInfo.container}';
              downloadedSong.isPathRelative = true;
            }

            if (await File(path_helper.join(
                    internalStorageLocation.path, downloadedSong.path))
                .exists()) {
              _downloadsLogger.info(
                  "Found song in new path. Replacing old path with new path for ${downloadedSong.song.id}.");
              addDownloadedSong(downloadedSong);
              return true;
            } else {
              _downloadsLogger.warning(
                  "${downloadedSong.song.id} not found in new path! Assuming that it was deleted before an update.");
            }
          } else {
            _downloadsLogger.warning(
                "The stored documents directory and the new one are both the same.");
          }
        }
        // If the function has got to this point, the file was probably deleted.

        // If the file was not found, delete it in DownloadsHelper so that it properly shows as deleted.
        _downloadsLogger.warning(
            "${downloadedSong.path} not found! Assuming deleted by user. Deleting with DownloadsHelper");
        deleteDownloads(
          jellyfinItemIds: [downloadedSong.song.id],
        );

        // If offline, throw an error. Otherwise, return a regular URL source.
        if (FinampSettingsHelper.finampSettings.isOffline) {
          return Future.error(
              "File could not be found. Not falling back to online stream due to offline mode");
        } else {
          return false;
        }
      }

      return true;
    } else {
      if (FinampSettingsHelper.finampSettings.isOffline) {
        return Future.error(
            "Download is not complete, not adding. Wait for all downloads to be complete before playing.");
      } else {
        return false;
      }
    }
  }

  DownloadedImage? getDownloadedImage(BaseItemDto item) {
    try {
      final imageId = _jellyfinApiData.getImageId(item);

      if (imageId != null) return _downloadedImagesBox.get(imageId);
    } catch (e) {
      _downloadsLogger.severe(e);
      rethrow;
    }
  }

  File? getImageFile(DownloadedImage image) {
    final downloadLocation = FinampSettingsHelper
        .finampSettings.downloadLocationsMap[image.downloadLocationId];

    if (downloadLocation != null) {
      return File(path_helper.join(downloadLocation.path, image.path));
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
      _downloadsLogger.severe(e);
      rethrow;
    }
  }

  Iterable<DownloadedSong> get downloadedItems {
    try {
      return _downloadedItemsBox.values;
    } catch (e) {
      _downloadsLogger.severe(e);
      rethrow;
    }
  }

  ValueListenable<Box<DownloadedSong>> getDownloadedItemsListenable(
      {List<String>? keys}) {
    try {
      return _downloadedItemsBox.listenable(keys: keys);
    } catch (e) {
      _downloadsLogger.severe(e);
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
      _downloadsLogger.severe(e);
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
      _downloadsLogger.severe(e);
    }
  }

  /// Downloads the image for the given item. This function assumes that the
  /// given item has its own image (not inherited). If the item does not have
  /// its own image, the function will throw an assert error.
  Future<void> _downloadImage({
    required BaseItemDto item,
    required Directory downloadDir,
    required DownloadLocation downloadLocation,
  }) async {
    assert(itemHasOwnImage(item));

    final imageId = _jellyfinApiData.getImageId(item)!;
    final imageUrl = _jellyfinApiData.getImageUrl(item: item);
    final tokenHeader = _jellyfinApiData.getTokenHeader();
    final relativePath =
        path_helper.relative(downloadDir.path, from: downloadLocation.path);

    final imagePath = "$relativePath/$imageId";

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
      _downloadsLogger.severe(
          "Adding image download for $imageId failed! downloadId is null. This only really happens if something goes horribly wrong with flutter_downloader's platform interface. This should never happen...");
    }

    final imageInfo = DownloadedImage.create(
      id: imageId,
      downloadId: imageDownloadId!,
      path: imagePath,
      requiredBySongs: [item.id],
      downloadLocationId: downloadLocation.id,
    );

    _addDownloadImageToDownloadedImages(imageInfo);
    _downloadedImageIdsBox.put(imageDownloadId, imageInfo.id);
  }

  /// Adds a [DownloadedImage] to the DownloadedImages box
  void _addDownloadImageToDownloadedImages(DownloadedImage downloadedImage) {
    _downloadedImagesBox.put(downloadedImage.id, downloadedImage);
  }

  Directory _getDownloadDirectory({
    required BaseItemDto item,
    required Directory downloadBaseDir,
    required bool useHumanReadableNames,
  }) {
    if (useHumanReadableNames) {
      return Directory(downloadBaseDir.path + "/${item.albumArtist}");
    } else {
      return Directory(downloadBaseDir.path);
    }
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
    this.isPathRelative = true,
    required this.downloadLocationId,
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

  /// The path of the song file. if [isPathRelative] is true, this will be a
  /// relative path from the song's DownloadLocation.
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

  /// Whether or not [path]
  @HiveField(7, defaultValue: false)
  bool isPathRelative;

  /// The ID of the DownloadLocation that holds this file. Will be null if made
  /// before 0.6.
  @HiveField(8)
  String? downloadLocationId;

  File get file {
    if (isPathRelative) {
      final downloadLocation = FinampSettingsHelper
          .finampSettings.downloadLocationsMap[downloadLocationId];

      if (downloadLocation == null) {
        throw "DownloadLocation was null in file getter for DownloadsSong!";
      }

      return File(path_helper.join(downloadLocation.path, path));
    }

    return File(path);
  }

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
    required this.downloadLocationId,
  });

  /// The image ID
  @HiveField(0)
  String id;

  /// The download ID of the song (for FlutterDownloader)
  @HiveField(1)
  String downloadId;

  /// The relative path to the image file. To get the absolute path, use the
  /// getImageFile function from DownloadsHelper.
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

  /// The ID of the DownloadLocation that holds this file.
  @HiveField(5)
  String downloadLocationId;

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
    required String downloadLocationId,
  }) =>
      DownloadedImage(
        id: id,
        downloadId: downloadId,
        path: path,
        requiredByParents: requiredByParents ?? [],
        requiredBySongs: requiredBySongs ?? [],
        downloadLocationId: downloadLocationId,
      );
}
