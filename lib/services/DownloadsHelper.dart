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
import 'JellyfinApiData.dart';
import 'getInternalSongDir.dart';
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
    // Check if we have external storage permission. It's a bit of a hack, but
    // we only do this if downloadLocation.deletable is true because if it's
    // true, we're downloading to a user location. You wouldn't want the app
    // asking for permission when using internal storage.
    if (downloadLocation.deletable) {
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

      if (parent.imageId != null &&
          !_downloadedImagesBox.containsKey(parent.imageId) &&
          parent.hasOwnImage) {
        _downloadsLogger
            .info("Downloading parent image for ${parent.name} (${parent.id}");

        final downloadDir = await _getDownloadDirectory(
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
        Directory downloadDir = await _getDownloadDirectory(
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
          path: path_helper.relative(
              path_helper.join(downloadDir.path, fileName),
              from: downloadLocation.path),
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

        // If the item has an image ID, handle getting/noting the downloaded
        // image.
        if (item.imageId != null) {
          if (_downloadedImagesBox.containsKey(item.imageId)) {
            _downloadsLogger.info(
                "Image ${item.imageId} already exists in downloadedImagesBox, adding requiredBy to DownloadedImage.");

            final downloadedImage = _downloadedImagesBox.get(item.imageId)!;

            downloadedImage.requiredBy.add(item.id);

            _addDownloadImageToDownloadedImages(downloadedImage);
          } else if (item.hasOwnImage) {
            _downloadsLogger.info(
                "Downloading image for ${item.name} (${item.id}) as it has its own image");
            await _downloadImage(
              item: item,
              downloadDir: downloadDir,
              downloadLocation: downloadLocation,
            );
          } else if (parent.type != "MusicAlbum") {
            _downloadsLogger.info(
                "Downloading parent image for ${item.name} (${item.id}) as the parent is not an album but the parent image is not downloaded");
            await _downloadImage(
              item: item,
              downloadDir: downloadDir,
              downloadLocation: downloadLocation,
            );
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
      final List<Future> deleteDownloadFutures = [];
      final Map<String, Directory> directoriesToCheck = {};

      for (final jellyfinItemId in jellyfinItemIds) {
        DownloadedSong? downloadedSong = getDownloadedSong(jellyfinItemId);

        if (downloadedSong == null) {
          _downloadsLogger.info(
              "Could not find $jellyfinItemId in downloadedItemsBox, assuming already deleted");
        } else {
          DownloadedImage? downloadedImage =
              getDownloadedImage(downloadedSong.song);

          if (deletedFor != null) {
            _downloadsLogger
                .info("Removing $deletedFor dependency from $jellyfinItemId");
            downloadedSong.requiredBy.remove(deletedFor);
          }

          downloadedImage?.requiredBy.remove(jellyfinItemId);

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

              downloadedImage?.requiredBy.remove(deletedFor);
            }

            // We only have to care about deleting directories if files are
            // stored with human readable file names.
            if (downloadedSong.useHumanReadableNames) {
              // We use the parent here since downloadedSong.path still includes
              // the filename. We assume that downloadedSong.path is not null,
              // as if downloadedSong.useHumanReadableNames is true, the path
              // would have been set at some point.
              Directory songDirectory = downloadedSong.file.parent;

              if (!directoriesToCheck.containsKey(songDirectory.path)) {
                // Add the directory to the directory map.
                // We keep the directories in a map so that we can easily check
                // for duplicates.
                directoriesToCheck[songDirectory.path] = songDirectory;
              }
            }
          }

          if (downloadedImage?.requiredBy.length == 0) {
            deleteDownloadFutures.add(_handleDeleteImage(downloadedImage!));
          }
        }
      }

      if (deletedFor != null) {
        final downloadedImage = _downloadedImagesBox.get(deletedFor);

        downloadedImage?.requiredBy.remove(deletedFor);

        if (downloadedImage != null) {
          deleteDownloadFutures.add(_handleDeleteImage(downloadedImage));
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

  Future<void> _handleDeleteImage(DownloadedImage downloadedImage) async {
    if (downloadedImage.requiredBy.length == 0) {
      _downloadsLogger
          .info("Image ${downloadedImage.id} has no dependencies, deleting.");

      _downloadsLogger.info(
          "Deleting ${downloadedImage.downloadId} from flutter_downloader");

      _downloadedImagesBox.delete(downloadedImage.id);
      _downloadedImageIdsBox.delete(downloadedImage.downloadId);

      await FlutterDownloader.remove(
        taskId: downloadedImage.downloadId,
        shouldDeleteContent: true,
      );
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
    if (downloadedSong.downloadLocation == null) {
      _downloadsLogger.warning(
          "Download location for ${downloadedSong.song.id} ${downloadedSong.song.name} returned null, looking for one now");

      bool hasFoundLocation = false;

      final internalSongDir = await getInternalSongDir();
      final potentialSongFile = File(path_helper.join(
          internalSongDir.path, path_helper.basename(downloadedSong.path)));

      // If the file exists in the (actual, not the potentially incorrect one
      // stored) internal song dir, set the download location ID to the internal
      // song dir and reset the stored internal song dir if it doesn't exist.
      // Also make the song's path relative to this new location.
      if (await potentialSongFile.exists()) {
        _downloadsLogger.info(
            "${downloadedSong.song.id} ${downloadedSong.song.name} exists at default internal song dir location, setting song to internal song dir");

        downloadedSong.downloadLocationId =
            FinampSettingsHelper.finampSettings.internalSongDir.id;
        hasFoundLocation = true;

        if (!await Directory(
                FinampSettingsHelper.finampSettings.internalSongDir.path)
            .exists()) {
          await FinampSettingsHelper.resetDefaultDownloadLocation();
        }

        downloadedSong.path = path_helper.relative(potentialSongFile.path,
            from: downloadedSong.downloadLocation!.path);

        downloadedSong.isPathRelative = true;
        addDownloadedSong(downloadedSong);
      } else {
        // Loop through all download locations. If we don't find one, assume the
        // download location has been deleted.
        FinampSettingsHelper.finampSettings.downloadLocationsMap
            .forEach((key, value) {
          if (downloadedSong.path.contains(value.path)) {
            _downloadsLogger.info(
                "Found download location (${value.name} ${value.id}), setting location for ${downloadedSong.song.id}");

            downloadedSong.downloadLocationId = value.id;

            addDownloadedSong(downloadedSong);
            hasFoundLocation = true;
          }
        });
      }

      if (!hasFoundLocation) {
        _downloadsLogger.severe(
            "Failed to find download location for ${downloadedSong.song.name} ${downloadedSong.song.id}! The download location may have been deleted.");
        // return false;
      }
    }

    return await _verifyDownload(downloadedSong: downloadedSong);
  }

  Future<bool> verifyDownloadedImage(DownloadedImage downloadedImage) async =>
      await _verifyDownload(downloadedImage: downloadedImage);

  Future<bool> _verifyDownload(
      {DownloadedSong? downloadedSong,
      DownloadedImage? downloadedImage}) async {
    assert((downloadedSong == null) ^ (downloadedImage == null));

    late String id;
    late String downloadId;
    late File file;
    late DownloadLocation downloadLocation; // Checked before this func is run
    late bool isPathRelative;
    DownloadTask? downloadTask;

    if (downloadedSong != null) {
      id = downloadedSong.song.id;
      downloadId = downloadedSong.downloadId;
      file = downloadedSong.file;
      downloadLocation = downloadedSong.downloadLocation!;
      isPathRelative = downloadedSong.isPathRelative;
      downloadTask = await downloadedSong.downloadTask;
    } else {
      id = downloadedImage!.id;
      downloadId = downloadedImage.downloadId;
      file = downloadedImage.file;
      downloadLocation = downloadedImage.downloadLocation!;
      isPathRelative = true;
      downloadTask = await downloadedImage.downloadTask;
    }

    if (downloadTask == null) {
      _downloadsLogger.severe(
          "Download task list for $downloadId ($id) returned null, assuming item not downloaded");
      return false;
    }

    if (downloadTask.status == DownloadTaskStatus.complete) {
      _downloadsLogger.info("Song $id exists offline, using local file");

      // Here we check if the file exists. This is important for
      // human-readable files, since the user could have deleted the file. iOS
      // also likes to move around the documents path after updates for some
      // reason.
      if (await file.exists()) {
        return true;
      }

      // Songs that don't have a deletable download location (internal storage)
      // will be in the internal directory, so we check here first
      if (!downloadLocation.deletable) {
        _downloadsLogger.warning(
            "${file.path} not found! Checking if the document directory has moved.");

        final currentDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        DownloadLocation internalStorageLocation =
            FinampSettingsHelper.finampSettings.internalSongDir;

        // If the song path doesn't contain the current path, assume the
        // path has changed.
        if (!file.path.contains(currentDocumentsDirectory.path)) {
          _downloadsLogger.warning(
              "Item does not contain documents directory, assuming moved.");

          if (internalStorageLocation.path !=
              path_helper.join(currentDocumentsDirectory.path, "songs")) {
            // Append /songs to the documents directory and create the new
            // song dir if it doesn't exist for some reason.
            final newSongDir = Directory(
                path_helper.join(currentDocumentsDirectory.path, "songs"));

            _downloadsLogger.warning(
                "Difference found in settings documents paths. Changing ${internalStorageLocation.path} to ${newSongDir.path} in settings.");

            // Set the new path in FinampSettings.
            internalStorageLocation =
                await FinampSettingsHelper.resetDefaultDownloadLocation();
          }

          // If the song's path is not relative, make it relative. This only
          // handles songs since all images will have relative paths.
          if (!isPathRelative) {
            downloadedSong!.path = path_helper.relative(downloadedSong.path,
                from: downloadedSong.downloadLocation!.path);
            downloadedSong.isPathRelative = true;
            addDownloadedSong(downloadedSong);
          }

          if (await downloadedSong?.file.exists() ??
              await downloadedImage!.file.exists()) {
            _downloadsLogger
                .info("Found item in new path! Everything is fine™");
            return true;
          } else {
            _downloadsLogger.warning(
                "$id not found in new path! Assuming that it was deleted before an update.");
          }
        } else {
          _downloadsLogger.warning(
              "The stored documents directory and the new one are both the same.");
        }
      }
      // If the function has got to this point, the file was probably deleted.

      // If the file was not found, delete it in DownloadsHelper so that it properly shows as deleted.
      _downloadsLogger.warning(
          "${file.path} not found! Assuming deleted by user. Deleting with DownloadsHelper");
      deleteDownloads(
        jellyfinItemIds: [id],
      );

      // If offline, throw an error. Otherwise, return false.
      // TODO: This will need changing for #188
      if (FinampSettingsHelper.finampSettings.isOffline) {
        return Future.error(
            "File could not be found. Not falling back to online stream due to offline mode");
      } else {
        return false;
      }
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
    if (item.imageId != null) {
      return _downloadedImagesBox.get(item.imageId);
    } else {
      return null;
    }
  }

  /// Adds a song to the database. If a song with the same ID already exists, it
  /// is overwritten.
  void addDownloadedSong(DownloadedSong newDownloadedSong) =>
      _downloadedItemsBox.put(newDownloadedSong.song.id, newDownloadedSong);

  /// Checks all downloaded items/parents for missing images and downloads them.
  /// Returns the amount of images downloaded.
  Future<int> downloadMissingImages() async {
    // Get an iterable of downloaded items where the download has an image but
    // that image isn't downloaded
    Iterable<DownloadedSong> missingItems = downloadedItems.where((element) =>
        element.song.imageId != null &&
        !_downloadedImagesBox.containsKey(element.song.imageId));

    List<Future<bool>> verifyFutures = [];

    // We check if the downloaded song is valid because we'll need a download
    // location to download its image (download location will be null if made
    // before 0.6, and most missing images will be because they were downloaded
    // before 0.6)
    for (final missingItem in missingItems) {
      verifyFutures.add(verifyDownloadedSong(missingItem));
    }

    List<bool> verifyResults = await Future.wait(verifyFutures);

    // If any downloads were invalid, regenerate the iterable
    if (verifyResults.contains(false)) {
      missingItems = downloadedItems.where((element) =>
          element.song.imageId != null &&
          !_downloadedImagesBox.containsKey(element.song.imageId));
    }

    final List<Future<void>> downloadFutures = [];

    for (final missingItem in missingItems) {
      downloadFutures.add(_downloadImage(
        item: missingItem.song,
        downloadDir: missingItem.file.parent,
        downloadLocation: missingItem.downloadLocation!,
      ));
    }

    Iterable<DownloadedParent> missingParents = downloadedParents.where(
        (element) =>
            element.item.imageId != null &&
            !_downloadedImagesBox.containsKey(element.item.imageId));

    verifyFutures = [];

    for (final missingParent in missingParents) {
      // Since parents don't have their own location/path, we take their first
      // child.
      final downloadedSong =
          getDownloadedSong(missingParent.downloadedChildren.values.first.id);

      if (downloadedSong == null) {
        _downloadsLogger.warning(
            "Failed to get downloaded song for parent ${missingParent.item.name}! This shouldn't happen...");
        continue;
      }

      verifyFutures.add(verifyDownloadedSong(downloadedSong));
    }

    verifyResults = await Future.wait(verifyFutures);

    if (verifyFutures.contains(false)) {
      missingParents = downloadedParents.where((element) =>
          element.item.imageId != null &&
          !_downloadedImagesBox.containsKey(element.item.imageId));
    }

    for (final missingParent in missingParents) {
      final downloadedSong =
          getDownloadedSong(missingParent.downloadedChildren.values.first.id);

      if (downloadedSong == null) {
        _downloadsLogger.warning(
            "Failed to get downloaded song for parent ${missingParent.item.name}! This REALLY shouldn't happen...");
        continue;
      }

      downloadFutures.add(_downloadImage(
        item: missingParent.item,
        downloadDir: downloadedSong.file.parent,
        downloadLocation: downloadedSong.downloadLocation!,
      ));
    }

    await Future.wait(downloadFutures);

    return downloadFutures.length;
  }

  Iterable<DownloadedParent> get downloadedParents =>
      _downloadedParentsBox.values;

  Iterable<DownloadedSong> get downloadedItems => _downloadedItemsBox.values;
  Iterable<DownloadedImage> get downloadedImages => _downloadedImagesBox.values;

  ValueListenable<Box<DownloadedSong>> getDownloadedItemsListenable(
          {List<String>? keys}) =>
      _downloadedItemsBox.listenable(keys: keys);

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
  /// given item has an image. If the item does not have an image, the function
  /// will throw an assert error. The function will return immediately if an
  /// image with the same ID is already downloaded.
  Future<void> _downloadImage({
    required BaseItemDto item,
    required Directory downloadDir,
    required DownloadLocation downloadLocation,
  }) async {
    assert(item.imageId != null);

    if (_downloadedImagesBox.containsKey(item.imageId)) return;

    final imageUrl = _jellyfinApiData.getImageUrl(
      item: item,
      quality: 100,
      format: "png",
    );
    final tokenHeader = _jellyfinApiData.getTokenHeader();
    final relativePath =
        path_helper.relative(downloadDir.path, from: downloadLocation.path);
    final fileName = "${item.imageId}.png";

    final imageDownloadId = await FlutterDownloader.enqueue(
      url: imageUrl.toString(),
      savedDir: downloadDir.path,
      headers: {
        if (tokenHeader != null) "X-Emby-Token": tokenHeader,
      },
      fileName: fileName,
      openFileFromNotification: false,
      showNotification: false,
    );

    if (imageDownloadId == null) {
      _downloadsLogger.severe(
          "Adding image download for ${item.imageId} failed! downloadId is null. This only really happens if something goes horribly wrong with flutter_downloader's platform interface. This should never happen...");
    }

    final imageInfo = DownloadedImage.create(
      id: item.imageId!,
      downloadId: imageDownloadId!,
      path: path_helper.join(relativePath, fileName),
      requiredBy: [item.id],
      downloadLocationId: downloadLocation.id,
    );

    _addDownloadImageToDownloadedImages(imageInfo);
    _downloadedImageIdsBox.put(imageDownloadId, imageInfo.id);
  }

  /// Adds a [DownloadedImage] to the DownloadedImages box
  void _addDownloadImageToDownloadedImages(DownloadedImage downloadedImage) {
    _downloadedImagesBox.put(downloadedImage.id, downloadedImage);
  }

  /// Get the download directory for the given item. Will create the directory
  /// if it doesn't exist.
  Future<Directory> _getDownloadDirectory({
    required BaseItemDto item,
    required Directory downloadBaseDir,
    required bool useHumanReadableNames,
  }) async {
    late Directory directory;

    if (useHumanReadableNames) {
      directory =
          Directory(path_helper.join(downloadBaseDir.path, item.albumArtist));
    } else {
      directory = Directory(downloadBaseDir.path);
    }

    if (!await directory.exists()) {
      await directory.create();
    }

    return directory;
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

  /// Whether or not [path] is relative.
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

  DownloadLocation? get downloadLocation => FinampSettingsHelper
      .finampSettings.downloadLocationsMap[downloadLocationId];

  Future<DownloadTask?> get downloadTask async {
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id = '$downloadId'");

    if (tasks?.isEmpty == false) {
      return tasks!.first;
    }

    return null;
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
    required this.requiredBy,
    required this.downloadLocationId,
  });

  /// The image ID
  @HiveField(0)
  String id;

  /// The download ID of the song (for FlutterDownloader)
  @HiveField(1)
  String downloadId;

  /// The relative path to the image file. To get the absolute path, use the
  /// file getter.
  @HiveField(2)
  String path;

  /// The list of item IDs that use this image. If this is empty, the image
  /// should be deleted.
  /// TODO: Investigate adding set support to Hive
  @HiveField(3)
  List<String> requiredBy;

  /// The ID of the DownloadLocation that holds this file.
  @HiveField(4)
  String downloadLocationId;

  DownloadLocation? get downloadLocation => FinampSettingsHelper
      .finampSettings.downloadLocationsMap[downloadLocationId];

  File get file {
    if (downloadLocation == null) {
      throw "Download location is null for image $id, this shouldn't happen...";
    }

    return File(path_helper.join(downloadLocation!.path, path));
  }

  Future<DownloadTask?> get downloadTask async {
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id = '$downloadId'");

    if (tasks?.isEmpty == false) {
      return tasks!.first;
    }
  }

  /// Creates a new DownloadedImage. Does not actually handle downloading or
  /// anything. This is only really a thing since having to manually specify
  /// empty lists is a bit jank.
  static DownloadedImage create({
    required String id,
    required String downloadId,
    required String path,
    List<String>? requiredBy,
    required String downloadLocationId,
  }) =>
      DownloadedImage(
        id: id,
        downloadId: downloadId,
        path: path,
        requiredBy: requiredBy ?? [],
        downloadLocationId: downloadLocationId,
      );
}
