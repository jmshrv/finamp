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
import 'isar_downloads.dart';
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

  Iterable<DownloadedParent> get _downloadedParents =>
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

  DownloadedSong? _getDownloadedSong(String id) {
    try {
      return _downloadedItemsBox.get(id);
    } catch (e) {
      _downloadsLogger.severe(e);
      rethrow;
    }
  }

  DownloadedParent? _getDownloadedParent(String id) {
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
  Future<bool> _verifyDownloadedSong(DownloadedSong downloadedSong) async {
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
        //teardown
        //addDownloadedSong(downloadedSong);
      } else {
        // Loop through all download locations. If we don't find one, assume the
        // download location has been deleted.
        FinampSettingsHelper.finampSettings.downloadLocationsMap
            .forEach((key, value) {
          if (downloadedSong.path.contains(value.path)) {
            _downloadsLogger.info(
                "Found download location (${value.name} ${value.id}), setting location for ${downloadedSong.song.id}");

            downloadedSong.downloadLocationId = value.id;

            //teardown
            //addDownloadedSong(downloadedSong);
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

  Future<bool> _verifyDownloadedImage(DownloadedImage downloadedImage) async =>
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
            //teardown
            //addDownloadedSong(downloadedSong);
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
      // teardown
      //deleteDownloads(
      //  jellyfinItemIds: [id],
      //);

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
      DownloadedSong? downloadedSong;
          // teardown
          //getJellyfinItemFromDownloadId(downloadTask.taskId);

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
        // teardown
        //deleteFutures
        //    .add(deleteDownloads(jellyfinItemIds: [downloadedSong.song.id]));

        if (parentItems[downloadedSong.song.id] == null) {
          parentItems[downloadedSong.song.id] = [];
        }

        parentItems[downloadedSong.song.id]!
            .add(await _jellyfinApiData.getItemById(parent));
      }
    }

    await Future.wait(deleteFutures);

    // Removed by teardown
    /*for (final downloadedSong in downloadedSongs) {
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
    }*/

    return redownloadCount;
  }

  /// Migrates id-based images to blurhash-based images (for 0.6.15). Should
  /// only be run if a migration has not been performed.
  Future<void> migrateBlurhashImages() async {
    final Map<String, DownloadedImage> imageMap = {};

    _downloadsLogger.info("Performing image blurhash migration");

    // Get a map to link blurhashes to images. This will be the list of images
    // we keep.
    for (final item in _downloadedItems) {
      final image = _downloadedImagesBox.get(item.song.id);

      if (image != null && item.song.blurHash != null) {
        imageMap[item.song.blurHash!] = image;
      }
    }

    // Do above, but for parents.
    for (final parent in _downloadedParents) {
      final image = _downloadedImagesBox.get(parent.item.id);

      if (image != null && parent.item.blurHash != null) {
        imageMap[parent.item.blurHash!] = image;
      }
    }

    final imagesToKeep = imageMap.values.toSet();

    // Get a list of all images not in the keep set
    final imagesToDelete = _downloadedImages
        .where((element) => !imagesToKeep.contains(element))
        .toList();

    for (final image in imagesToDelete) {
      final song = _getDownloadedSong(image.requiredBy.first);

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
    if (imagesCount != _downloadedImages.length) {
      final err =
          "Unexpected number of items in images to keep/delete! Expected ${_downloadedImages.length}, got $imagesCount";
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

    for (final image in _downloadedImages) {
      final item = _getDownloadedSong(image.requiredBy.first) ??
          _getDownloadedParent(image.requiredBy.first);

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

  Iterable<DownloadedSong> get _downloadedItems => _downloadedItemsBox.values;

  Iterable<DownloadedImage> get _downloadedImages => _downloadedImagesBox.values;


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
