import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'finamp_settings_helper.dart';
import 'downloads_helper.dart';
import '../models/jellyfin_models.dart';
import 'music_player_background_task.dart';

/// Just some functions to make talking to AudioService a bit neater.
class AudioServiceHelper {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
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

      List<MediaItem> queue = [];
      for (BaseItemDto item in itemList) {
        try {
          queue.add(await _generateMediaItem(item));
        } catch (e) {
          audioServiceHelperLogger.severe(e);
        }
      }

      // if (!shuffle) {
      //   // Give the audio service our next initial index so that playback starts
      //   // at that index. We don't do this if shuffling because it causes the
      //   // queue to always start at the start (although you could argue that we
      //   // still should if initialIndex is not 0, but that doesn't happen
      //   // anywhere in this app so oh well).
      _audioHandler.setNextInitialIndex(initialIndex);
      // }

      await _audioHandler.updateQueue(queue);

      if (shuffle) {
        await _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
      } else {
        await _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
      }

      _audioHandler.play();
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  bool hasQueueItems() {
    return (_audioHandler.queue.valueOrNull?.length ?? 0) != 0;
  }

  @Deprecated("Use addQueueItems instead")
  Future<void> addQueueItem(BaseItemDto item) async {
    await addQueueItems([item]);
  }

  Future<void> addQueueItems(List<BaseItemDto> items) async {
    try {
      // If the queue is empty (like when the app is first launched), run the
      // replace queue function instead so that the song gets played
      if ((_audioHandler.queue.valueOrNull?.length ?? 0) == 0) {
        await replaceQueueWithItem(itemList: items);
        return;
      }

      final mediaItems =
          await Future.wait(items.map((i) => _generateMediaItem(i)));
      await _audioHandler.addQueueItems(mediaItems);
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> insertQueueItemsNext(List<BaseItemDto> items) async {
    try {
      // See above comment in addQueueItem
      if ((_audioHandler.queue.valueOrNull?.length ?? 0) == 0) {
        await replaceQueueWithItem(itemList: items);
        return;
      }

      final mediaItems =
          await Future.wait(items.map((i) => _generateMediaItem(i)));
      await _audioHandler.insertQueueItemsNext(mediaItems);
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
      items = await _jellyfinApiHelper.getItems(
        isGenres: false,
        parentItem: _finampUserHelper.currentUser!.currentView,
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

  /// Start instant mix from item.
  Future<void> startInstantMixForItem(BaseItemDto item) async {
    List<BaseItemDto>? items;

    try {
      items = await _jellyfinApiHelper.getInstantMix(item);
      if (items != null) {
        await replaceQueueWithItem(itemList: items, shuffle: false);
      }
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Start instant mix from a selection of artists.
  Future<void> startInstantMixForArtists(List<String> artistIds) async {
    List<BaseItemDto>? items;

    try {
      items = await _jellyfinApiHelper.getArtistMix(artistIds);
      if (items != null) {
        await replaceQueueWithItem(itemList: items, shuffle: false);
      }
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Start instant mix from a selection of albums.
  Future<void> startInstantMixForAlbums(List<String> albumIds) async {
    List<BaseItemDto>? items;

    try {
      items = await _jellyfinApiHelper.getAlbumMix(albumIds);
      if (items != null) {
        await replaceQueueWithItem(itemList: items, shuffle: false);
      }
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
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
          _jellyfinApiHelper.getImageUrl(item: item),
      title: item.name ?? "Unknown Name",
      extras: {
        // "parentId": item.parentId,
        // "itemId": item.id,
        "itemJson": item.toJson(),
        "shouldTranscode": FinampSettingsHelper.finampSettings.shouldTranscode,
        "downloadedSongJson": isDownloaded
            ? (_downloadsHelper.getDownloadedSong(item.id))!.toJson()
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
