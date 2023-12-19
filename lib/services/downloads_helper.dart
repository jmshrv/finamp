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

  final _downloadsLogger = Logger("DownloadsHelper");

  DownloadsHelper();

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

  /// Checks if a DownloadedSong is actually downloaded, and fixes common issues
  /// related to downloads (such as changed appdirs). Returns true if the song
  /// is downloaded, and false otherwise.
  /// TODO is this just about not using relative paths before?  images skips it.
  /// what does this do extra?
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
        //teardown - this just updates with new path info.
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
}
