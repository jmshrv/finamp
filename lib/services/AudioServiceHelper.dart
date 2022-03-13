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

  Future<MediaItem> _generateMediaItem(BaseItemDto item) async {
    const uuid = Uuid();

    final downloadedSong = _downloadsHelper.getDownloadedSong(item.id);
    final isDownloaded = downloadedSong == null
        ? false
        : await _downloadsHelper.verifyDownloadedSong(downloadedSong);

    return MediaItem(
      id: uuid.v4(),
      album: item.album ?? "Unknown Album",
      artist: item.artists?.join(", ") ?? item.albumArtist,
      artUri: _downloadsHelper.getDownloadedImage(item)?.file.uri ??
          _jellyfinApiData.getImageUrl(item: item),
      title: item.name ?? "Unknown Name",
      extras: {
        // "parentId": item.parentId,
        // "itemId": item.id,
        "itemJson": item.toJson(),
        "shouldTranscode": FinampSettingsHelper.finampSettings.shouldTranscode,
        "downloadedSongJson": isDownloaded
            ? (await _downloadsHelper.getDownloadedSong(item.id))!.toJson()
            : null,
        "isOffline": FinampSettingsHelper.finampSettings.isOffline,
        // TODO: Maybe add transcoding bitrate here?
      },
      // Jellyfin returns microseconds * 10 for some reason
      duration: Duration(
        microseconds:
            (item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10),
      ),
    );
  }
}
