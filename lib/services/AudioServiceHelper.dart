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
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
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
      List<MediaItem> queue = await Future.wait(itemList.map((e) {
        return _generateMediaItem(e);
      }).toList());

      if (shuffle) {
        await _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
      } else {
        await _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
      }

      // Give the audio service our next initial index so that playback starts
      // at that index.
      _audioHandler.setNextInitialIndex(initialIndex);

      await _audioHandler.updateQueue(queue);

      _audioHandler.play();

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
      // If the queue is empty (like when the app is first launched), run the
      // replace queue function instead so that the song gets played
      if ((_audioHandler.queue.valueOrNull?.length ?? 0) == 0) {
        await replaceQueueWithItem(itemList: [item]);
        return;
      }

      final itemMediaItem = await _generateMediaItem(item);
      await _audioHandler.addQueueItem(itemMediaItem);
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Shuffles every song in the user's current view.
  Future<void> shuffleAll(bool isFavourite) async {
    List<BaseItemDto>? items;

    if (FinampSettingsHelper.finampSettings.isOffline) {
      // If offline, get a shuffled list of songs from _downloadsHelper.
      // This is a bit inefficient since we have to get all of the songs and
      // shuffle them before making a sublist, but I couldn't think of a better
      // way.
      items = _downloadsHelper.downloadedItems.map((e) => e.song).toList();
      items.shuffle();
      if (items.length - 1 >
          FinampSettingsHelper.finampSettings.songShuffleItemCount) {
        items = items.sublist(
            0, FinampSettingsHelper.finampSettings.songShuffleItemCount);
      }
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

    return null;
  }

  Future<MediaItem> _generateMediaItem(BaseItemDto item) async {
    const uuid = Uuid();

    return MediaItem(
      id: uuid.v4(),
      album: item.album ?? "Unknown Album",
      artist: item.artists?.join(", ") ?? item.albumArtist,
      artUri: _jellyfinApiData.getImageUrl(item: item),
      title: item.name ?? "Unknown Name",
      extras: {
        // "parentId": item.parentId,
        // "itemId": item.id,
        "itemJson": item.toJson(),
        "shouldTranscode": FinampSettingsHelper.finampSettings.shouldTranscode,
        "downloadedSongJson": (await _getDownloadedSong(item.id))?.toJson(),
        "isOffline": FinampSettingsHelper.finampSettings.isOffline,
        // TODO: Maybe add transcoding bitrate here?
      },
      rating: Rating.newHeartRating(item.userData?.isFavorite ?? false),
      // Jellyfin returns microseconds * 10 for some reason
      duration: Duration(
        microseconds:
            (item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10),
      ),
    );
  }
}
