import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path_helper;

import 'finamp_settings_helper.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'get_internal_song_dir.dart';
import '../models/jellyfin_models.dart';
import '../models/finamp_models.dart';

class DownloadsHelper {
  List<String> queue = [];
  final _jellyfinApiData = GetIt.instance<JellyfinApiHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _downloadedItemsBox = Hive.box<DownloadedSong>("DownloadedItems");
  final _downloadedParentsBox = Hive.box<DownloadedParent>("DownloadedParents");
  final _downloadIdsBox = Hive.box<DownloadedSong>("DownloadIds");
  final _downloadedImagesBox = Hive.box<DownloadedImage>("DownloadedImages");
  final _downloadedImageIdsBox = Hive.box<String>("DownloadedImageIds");

  final _downloadsLogger = Logger("DownloadsHelper");

  List<DownloadedParent>? _downloadedParentsCache;

  Iterable<DownloadedParent> get downloadedParents =>
      _downloadedParentsCache ?? _loadSortedDownloadedParents();

  DownloadsHelper() {
    _downloadedParentsBox.watch().listen((event) {
      _downloadedParentsCache = null;
    });
  }

  List<DownloadedParent> _loadSortedDownloadedParents() {
    return _downloadedParentsCache = _downloadedParentsBox.values.toList()
      ..sort((a, b) {
        final nameA = a.item.name;
        final nameB = b.item.name;

        return nameA != null && nameB != null
            ? nameA.toLowerCase().compareTo(nameB.toLowerCase())
            : 0;
      });
  }

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

      if (parent.blurHash != null &&
          !_downloadedImagesBox.containsKey(parent.blurHash) &&
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
            "${_finampUserHelper.currentUser!.baseUrl}/Items/${item.id}/File";

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
              "${item.album?.replaceAll(RegExp('[/?<>\\:*|"]'), "_")} - ${item.indexNumber ?? 0} - ${item.name?.replaceAll(RegExp('[/?<>\\:*|"]'), "_")}.${mediaSourceInfo?[0].container}";
        } else {
          fileName = "${item.id}.${mediaSourceInfo?[0].container}";
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

        // If the item has an blurhash, handle getting/noting the downloaded
        // image.
        if (item.blurHash != null) {
          if (_downloadedImagesBox.containsKey(item.blurHash)) {
            _downloadsLogger.info(
                "Image ${item.blurHash} already exists in downloadedImagesBox, adding requiredBy to DownloadedImage.");

            final downloadedImage = _downloadedImagesBox.get(item.blurHash)!;

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

          if (downloadedSong.requiredBy.isEmpty || deletedFor == null) {
            _downloadsLogger.info(
                "Item $jellyfinItemId has no dependencies or was manually deleted, deleting files");

            _downloadsLogger.info(
                "Deleting ${downloadedSong.downloadId} from flutter_downloader");
            deleteDownloadFutures.add(FlutterDownloader.remove(
              taskId: downloadedSong.downloadId,
              shouldDeleteContent: true,
            ));

            await _downloadedItemsBox.delete(jellyfinItemId);
            await _downloadIdsBox.delete(downloadedSong.downloadId);

            if (deletedFor != null) {
              DownloadedParent? downloadedAlbumTemp =
                  _downloadedParentsBox.get(deletedFor);
              if (downloadedAlbumTemp != null) {
                downloadedAlbumTemp.downloadedChildren.remove(jellyfinItemId);
                await _downloadedParentsBox.put(deletedFor, downloadedAlbumTemp);
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

          if (downloadedImage?.requiredBy.isEmpty ?? false) {
            deleteDownloadFutures.add(_handleDeleteImage(downloadedImage!));
          }
        }
      }

      if (deletedFor != null) {
        final parentItem = getDownloadedParent(deletedFor)?.item;

        if (parentItem != null) {
          final downloadedImage = getDownloadedImage(parentItem);

          downloadedImage?.requiredBy.remove(deletedFor);

          if (downloadedImage != null) {
            deleteDownloadFutures.add(_handleDeleteImage(downloadedImage));
          }
        }
      }

      await Future.wait(deleteDownloadFutures);

      for (var element in directoriesToCheck.values) {
        // Loop through each directory and check if it's empty. If it is, delete the directory.
        if (await element.list().isEmpty) {
          _downloadsLogger.info("${element.path} is empty, deleting");
          await element.delete();
        }
      }

      if (deletedFor != null) {
        await _downloadedParentsBox.delete(deletedFor);
      }
    } catch (e) {
      _downloadsLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Deletes an image if it no longer has any dependents (requiredBy is empty)
  Future<void> _handleDeleteImage(DownloadedImage downloadedImage) async {
    if (downloadedImage.requiredBy.isEmpty) {
      _downloadsLogger
          .info("Image ${downloadedImage.id} has no dependencies, deleting.");

      await _deleteImage(downloadedImage);
    }
  }

  /// Deletes an image, without checking if anything else depends on it first.
  Future<void> _deleteImage(DownloadedImage downloadedImage) async {
    _downloadsLogger
        .info("Deleting ${downloadedImage.downloadId} from flutter_downloader");

    _downloadedImagesBox.delete(downloadedImage.id);
    _downloadedImageIdsBox.delete(downloadedImage.downloadId);

    await FlutterDownloader.remove(
      taskId: downloadedImage.downloadId,
      shouldDeleteContent: true,
    );
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
              "SELECT * FROM task WHERE status = $downloadTaskStatus.index");
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
    if (item.blurHash != null) {
      return _downloadedImagesBox.get(item.blurHash);
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
        element.song.blurHash != null &&
        !_downloadedImagesBox.containsKey(element.song.blurHash));

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
          element.song.blurHash != null &&
          !_downloadedImagesBox.containsKey(element.song.blurHash));
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
            element.item.blurHash != null &&
            !_downloadedImagesBox.containsKey(element.item.blurHash));

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

    if (verifyResults.contains(false)) {
      missingParents = downloadedParents.where((element) =>
          element.item.blurHash != null &&
          !_downloadedImagesBox.containsKey(element.item.blurHash));
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

  /// Redownloads failed items. This is done by deleting the old downloads and
  /// creating new ones with the same settings. Returns number of songs
  /// redownloaded
  Future<int> redownloadFailed() async {
    final failedDownloadTasks =
        await getDownloadsWithStatus(DownloadTaskStatus.failed);

    if (failedDownloadTasks?.isEmpty ?? true) {
      _downloadsLogger
          .info("Failed downloads list is empty -> not redownloading anything");
      return 0;
    }

    int redownloadCount = 0;
    Map<String, List<BaseItemDto>> parentItems = {};
    List<Future> deleteFutures = [];
    List<DownloadedSong> downloadedSongs = [];

    for (DownloadTask downloadTask in failedDownloadTasks!) {
      DownloadedSong? downloadedSong =
          getJellyfinItemFromDownloadId(downloadTask.taskId);

      if (downloadedSong == null) {
        _downloadsLogger.info("Could not get Jellyfin item for failed task");
        continue;
      }

      _downloadsLogger.info(
          "Redownloading item ${downloadedSong.song.id} (${downloadedSong.song.name})");

      downloadedSongs.add(downloadedSong);

      List<String> parents = downloadedSong.requiredBy;
      for (String parent in parents) {
        // We don't specify deletedFor here because it could cause the parent
        // to get deleted
        deleteFutures
            .add(deleteDownloads(jellyfinItemIds: [downloadedSong.song.id]));

        if (parentItems[downloadedSong.song.id] == null) {
          parentItems[downloadedSong.song.id] = [];
        }

        parentItems[downloadedSong.song.id]!
            .add(await _jellyfinApiData.getItemById(parent));
      }
    }

    await Future.wait(deleteFutures);

    for (final downloadedSong in downloadedSongs) {
      final parents = parentItems[downloadedSong.song.id];

      if (parents == null) {
        _downloadsLogger.warning(
            "Item ${downloadedSong.song.name} (${downloadedSong.song.id}) has no parent items, skipping");
        continue;
      }

      for (final parent in parents) {
        // We can't await all the downloads asynchronously as it could mess
        // with setting up parents again
        await addDownloads(
          items: [downloadedSong.song],
          parent: parent,
          useHumanReadableNames: downloadedSong.useHumanReadableNames,
          downloadLocation: downloadedSong.downloadLocation!,
          viewId: downloadedSong.viewId,
        );
        redownloadCount++;
      }
    }

    return redownloadCount;
  }

  /// Migrates id-based images to blurhash-based images (for 0.6.15). Should
  /// only be run if a migration has not been performed.
  Future<void> migrateBlurhashImages() async {
    final Map<String, DownloadedImage> imageMap = {};

    _downloadsLogger.info("Performing image blurhash migration");

    // Get a map to link blurhashes to images. This will be the list of images
    // we keep.
    for (final item in downloadedItems) {
      final image = _downloadedImagesBox.get(item.song.id);

      if (image != null && item.song.blurHash != null) {
        imageMap[item.song.blurHash!] = image;
      }
    }

    // Do above, but for parents.
    for (final parent in downloadedParents) {
      final image = _downloadedImagesBox.get(parent.item.id);

      if (image != null && parent.item.blurHash != null) {
        imageMap[parent.item.blurHash!] = image;
      }
    }

    final imagesToKeep = imageMap.values.toSet();

    // Get a list of all images not in the keep set
    final imagesToDelete = downloadedImages
        .where((element) => !imagesToKeep.contains(element))
        .toList();

    for (final image in imagesToDelete) {
      final song = getDownloadedSong(image.requiredBy.first);

      if (song != null) {
        final blurHash = song.song.blurHash;

        imageMap[blurHash]?.requiredBy.addAll(image.requiredBy);
      }
    }

    // Go through each requiredBy and remove duplicates. We also set the image's
    // id to the blurhash.
    for (final imageEntry in imageMap.entries) {
      final image = imageEntry.value;

      image.requiredBy = image.requiredBy.toSet().toList();
      _downloadsLogger.warning(image.requiredBy);

      image.id = imageEntry.key;

      imageMap[imageEntry.key] = image;
    }

    // Sanity check to make sure we haven't double counted/missed an image.
    final imagesCount = imagesToKeep.length + imagesToDelete.length;
    if (imagesCount != downloadedImages.length) {
      final err =
          "Unexpected number of items in images to keep/delete! Expected ${downloadedImages.length}, got $imagesCount";
      _downloadsLogger.severe(err);
      throw err;
    }

    // Delete all images.
    await Future.wait(imagesToDelete.map((e) => _deleteImage(e)));

    // Clear out the images box and put the kept images back in
    await _downloadedImagesBox.clear();
    await _downloadedImagesBox.putAll(imageMap);

    // Do the same, but with the downloadId mapping
    await _downloadedImageIdsBox.clear();
    await _downloadedImageIdsBox.putAll(
        imageMap.map((key, value) => MapEntry(value.downloadId, value.id)));

    _downloadsLogger.info("Image blurhash migration complete.");
    _downloadsLogger.info("${imagesToDelete.length} duplicate images deleted.");
  }

  /// Fixes DownloadedImage IDs created by the migration in 0.6.15. In it,
  /// migrated images did not have their IDs set to the blurhash. This function
  /// sets every image's ID to its blurhash. This function should only be run
  /// once, only when required (i.e., upgrading from 0.6.15). In theory, running
  /// it on an unaffected database should do nothing, but there's no point doing
  /// redundant migrations.
  Future<void> fixBlurhashMigrationIds() async {
    _downloadsLogger.info("Fixing blurhash migration IDs from 0.6.15");

    final List<DownloadedImage> images = [];

    for (final image in downloadedImages) {
      final item = getDownloadedSong(image.requiredBy.first) ??
          getDownloadedParent(image.requiredBy.first);

      if (item == null) {
        // I should really use error enums when I rip this whole system out
        throw "Failed to get item from image during blurhash migration fix!";
      }

      switch (item.runtimeType) {
        case DownloadedSong:
          image.id = (item as DownloadedSong).song.blurHash!;
          break;
        case DownloadedParent:
          image.id = (item as DownloadedParent).item.blurHash!;
          break;
        default:
          throw "Item was unexpected type! got ${item.runtimeType}. This really shouldn't happen...";
      }

      images.add(image);
    }

    await _downloadedImagesBox.clear();
    await _downloadedImagesBox
        .putAll(Map.fromEntries(images.map((e) => MapEntry(e.id, e))));

    await _downloadedImageIdsBox.clear();
    await _downloadedImageIdsBox.putAll(
        Map.fromEntries(images.map((e) => MapEntry(e.downloadId, e.id))));
  }

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
  ///
  /// As of 0.6.15, images are indexed by blurhash to ensure that duplicate
  /// images are not downloaded (many albums will have an identical image
  /// per-song).
  Future<void> _downloadImage({
    required BaseItemDto item,
    required Directory downloadDir,
    required DownloadLocation downloadLocation,
  }) async {
    assert(item.blurHash != null);

    if (_downloadedImagesBox.containsKey(item.blurHash)) return;

    final imageUrl = _jellyfinApiData.getImageUrl(
      item: item,
      // Download original file
      quality: null,
      format: null,
    );
    final tokenHeader = _jellyfinApiData.getTokenHeader();
    final relativePath =
        path_helper.relative(downloadDir.path, from: downloadLocation.path);

    // We still use imageIds for filenames despite switching to blurhashes as
    // blurhashes can include characters that filesystems don't support
    final fileName = item.imageId;

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
          "Adding image download for ${item.blurHash} failed! downloadId is null. This only really happens if something goes horribly wrong with flutter_downloader's platform interface. This should never happen...");
    }

    final imageInfo = DownloadedImage.create(
      id: item.blurHash!,
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
