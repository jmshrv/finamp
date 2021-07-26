import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'JellyfinApiData.dart';
import 'FinampSettingsHelper.dart';
import 'DownloadsHelper.dart';
import '../models/JellyfinModels.dart';
import 'MusicPlayerBackgroundTask.dart';

/// Just some functions to make talking to AudioService a bit neater.
class AudioServiceHelper {
  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  final audioServiceHelperLogger = Logger("AudioServiceHelper");

  /// Replaces the queue with the given list of items. If startAtIndex is specified, Any items below it
  /// will be ignored. This is used for when the user taps in the middle of an album to start from that point.
  Future<void> replaceQueueWithItem({
    required List<BaseItemDto> itemList,
    int initialIndex = 0,
    bool shuffle = false,
  }) async {
    try {
      if (initialIndex > itemList.length) {
        return Future.error(
            "startAtIndex is bigger than the itemList! ($initialIndex > ${itemList.length})");
      }
      final uuid = Uuid();

      List<MediaItem> queue = await Future.wait(itemList.map((e) async {
        return MediaItem(
          id: uuid.v4(),
          album: e.album ?? "Unknown Album",
          artist: e.albumArtist,
          artUri: FinampSettingsHelper.finampSettings.isOffline
              ? null
              : Uri.parse(
                  "${_jellyfinApiData.currentUser!.baseUrl}/Items/${e.parentId}/Images/Primary?format=jpg"),
          title: e.name ?? "Unknown Name",
          extras: {
            "parentId": e.parentId,
            "itemId": e.id,
            "shouldTranscode":
                FinampSettingsHelper.finampSettings.shouldTranscode,
            // We have to deserialise this because Dart is stupid and can't handle
            // sending classes through isolates.
            "downloadedSongJson": jsonEncode(await _getDownloadedSong(e.id)),
            "isOffline": FinampSettingsHelper.finampSettings.isOffline,
            // TODO: Maybe add transcoding bitrate here?
          },
          // Jellyfin returns microseconds * 10 for some reason
          duration: Duration(
            microseconds: (e.runTimeTicks == null ? 0 : e.runTimeTicks! ~/ 10),
          ),
        );
      }).toList());

      if (!AudioService.running) {
        await startAudioService();
      }
      if (shuffle) {
        await AudioService.setShuffleMode(AudioServiceShuffleMode.all);
      } else {
        await AudioService.setShuffleMode(AudioServiceShuffleMode.none);
      }

      // Give the audio service our next initial index so that playback starts
      // at that index.
      await AudioService.customAction("setNextInitialIndex", initialIndex);

      await AudioService.updateQueue(queue);

      AudioService.play();

      // if (!FinampSettingsHelper.finampSettings.isOffline) {
      //   final PlaybackProgressInfo playbackProgressInfo =
      //       await AudioService.customAction("generatePlaybackProgressInfo");
      //   _jellyfinApiData.reportPlaybackStart(playbackProgressInfo);
      // }
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> addQueueItem(BaseItemDto item) async {
    try {
      final uuid = Uuid();

      final itemMediaItem = MediaItem(
        id: uuid.v4(),
        album: item.album ?? "Unknown Album",
        artist: item.albumArtist,
        artUri: FinampSettingsHelper.finampSettings.isOffline
            ? null
            : Uri.parse(
                "${_jellyfinApiData.currentUser!.baseUrl}/Items/${item.parentId}/Images/Primary?format=jpg"),
        title: item.name ?? "Unknown Name",
        extras: {
          "parentId": item.parentId,
          "itemId": item.id,
          "shouldTranscode":
              FinampSettingsHelper.finampSettings.shouldTranscode,
          "downloadedSongJson": jsonEncode(await _getDownloadedSong(item.id)),
          "isOffline": FinampSettingsHelper.finampSettings.isOffline,
        },
        // Jellyfin returns microseconds * 10 for some reason
        duration: Duration(
          microseconds:
              (item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10),
        ),
      );

      bool wasRunning = true;

      if (!AudioService.running) {
        wasRunning = false;
        await startAudioService();
      }

      if (wasRunning) {
        await AudioService.addQueueItem(itemMediaItem);
      } else {
        await AudioService.updateQueue([itemMediaItem]);
        AudioService.play();
      }
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Starts the background audio service. I only wrote this function to keep
  /// _backgroundTaskEntrypoint in one place.
  Future<void> startAudioService() async {
    try {
      await AudioService.start(
        backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
        androidStopForegroundOnPause:
            FinampSettingsHelper.finampSettings.androidStopForegroundOnPause,
        androidEnableQueue: true,
        androidNotificationChannelName: "Playback",
      );
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<DownloadedSong?> _getDownloadedSong(String itemId) async {
    DownloadedSong? downloadedSong = _downloadsHelper.getDownloadedSong(itemId);
    if (downloadedSong != null) {
      final downloadTaskList =
          await _downloadsHelper.getDownloadStatus([itemId]);

      if (downloadTaskList == null) {
        audioServiceHelperLogger.warning(
            "Download task list for ${downloadedSong.downloadId} ($itemId) returned null, assuming item not downloaded");
        return null;
      }

      final downloadTask = downloadTaskList[0];

      if (downloadTask.status == DownloadTaskStatus.complete) {
        audioServiceHelperLogger
            .info("Song $itemId exists offline, using local file");

        // Here we check if the file exists. This is important for
        // human-readable files, since the user could have deleted the file. iOS
        // also likes to move around the documents path after updates for some
        // reason.
        if (!await File(downloadedSong.path).exists()) {
          // Songs that don't use human readable names should be in the
          // documents path, so we check if its changed.
          if (!downloadedSong.useHumanReadableNames) {
            audioServiceHelperLogger.warning(
                "${downloadedSong.path} not found! Checking if the document directory has moved.");

            final currentDocumentsDirectory =
                await getApplicationDocumentsDirectory();
            final internalStorageLocation =
                FinampSettingsHelper.finampSettings.downloadLocations[0];

            // If the song path doesn't contain the current path, assume the
            // path has changed.
            if (!downloadedSong.path.contains(currentDocumentsDirectory.path)) {
              audioServiceHelperLogger.warning(
                  "Song does not contain documents directory, assuming moved.");

              if (FinampSettingsHelper
                      .finampSettings.downloadLocations[0].path !=
                  "${currentDocumentsDirectory.path}/songs") {
                // Append /songs to the documents directory and create the new
                // song dir if it doesn't exist for some reason.
                final newSongDir =
                    Directory("${currentDocumentsDirectory.path}/songs");

                audioServiceHelperLogger.warning(
                    "Difference found in settings documents paths. Changing ${internalStorageLocation.path} to ${newSongDir.path} in settings.");

                // Set the new path in FinampSettings.
                await FinampSettingsHelper.resetDefaultDownloadLocation();
              }

              // Recreate the downloaded song path with the new documents
              // directory.
              downloadedSong.path =
                  "${currentDocumentsDirectory.path}/songs/${downloadedSong.song.id}.${downloadedSong.mediaSourceInfo.container}";

              if (await File(downloadedSong.path).exists()) {
                audioServiceHelperLogger.info(
                    "Found song in new path. Replacing old path with new path for ${downloadedSong.song.id}.");
                _downloadsHelper.addDownloadedSong(downloadedSong);
                return downloadedSong;
              } else {
                audioServiceHelperLogger.warning(
                    "${downloadedSong.song.id} not found in new path! Assuming that it was deleted before an update.");
              }
            } else {
              audioServiceHelperLogger.warning(
                  "The stored documents directory and the new one are both the same.");
            }
          }
          // If the function has got to this point, the file was probably deleted.

          // If the file was not found, delete it in DownloadsHelper so that it properly shows as deleted.
          audioServiceHelperLogger.warning(
              "${downloadedSong.path} not found! Assuming deleted by user. Deleting with DownloadsHelper");
          _downloadsHelper.deleteDownloads(
            jellyfinItemIds: [downloadedSong.song.id],
          );

          // If offline, throw an error. Otherwise, return a regular URL source.
          if (FinampSettingsHelper.finampSettings.isOffline) {
            return Future.error(
                "File could not be found. Not falling back to online stream due to offline mode");
          } else {
            return null;
          }
        }

        return downloadedSong;
      } else {
        if (FinampSettingsHelper.finampSettings.isOffline) {
          return Future.error(
              "Download is not complete, not adding. Wait for all downloads to be complete before playing.");
        } else {
          return downloadedSong;
        }
      }
    }
  }

  /// Shuffles every song in the user's current view.
  Future<void> shuffleAll(bool isFavourite) async {
    List<BaseItemDto>? items;

    if (FinampSettingsHelper.finampSettings.isOffline) {
      // If offline, set items to all downloaded songs (this is the same method
      // we use in MusicScreenTabView)
      items = _downloadsHelper.downloadedItems.map((e) => e.song).toList();
    } else {
      // If online, get all audio items from the user's view
      items = await _jellyfinApiData.getItems(
        isGenres: false,
        parentItem: _jellyfinApiData.currentUser!.currentView,
        includeItemTypes: "Audio",
        filters: isFavourite ? "IsFavorite" : null,
        limit: FinampSettingsHelper.finampSettings.songShuffleItemCount,
        sortBy: "Random",
      );
    }

    if (items != null) {
      await replaceQueueWithItem(itemList: items, shuffle: true);
    }
  }
}

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => MusicPlayerBackgroundTask());
}
