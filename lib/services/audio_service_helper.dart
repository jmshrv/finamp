import 'package:finamp/models/jellyfin_models.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart' as jellyfin_models;
import 'downloads_service.dart';
import 'finamp_settings_helper.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'queue_service.dart';

/// Just some functions to make talking to AudioService a bit neater.
class AudioServiceHelper {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _queueService = GetIt.instance<QueueService>();
  final _isarDownloader = GetIt.instance<DownloadsService>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final audioServiceHelperLogger = Logger("AudioServiceHelper");

  /// Shuffles every song in the user's current view.
  Future<void> shuffleAll(bool onlyShowFavourites) async {
    List<jellyfin_models.BaseItemDto>? items;

    if (FinampSettingsHelper.finampSettings.isOffline) {
      // If offline, get a shuffled list of songs from _downloadsHelper.
      // This is a bit inefficient since we have to get all of the songs and
      // shuffle them before making a sublist, but I couldn't think of a better
      // way.
      items = (await _isarDownloader.getAllSongs(
              viewFilter: _finampUserHelper.currentUser?.currentView?.id,
              nullableViewFilters: FinampSettingsHelper
                  .finampSettings.showDownloadsWithUnknownLibrary))
          .map((e) => e.baseItem!)
          .toList();
      items.shuffle();
      if (items.length - 1 >
          FinampSettingsHelper.finampSettings.songShuffleItemCount) {
        items = items.sublist(
            0, FinampSettingsHelper.finampSettings.songShuffleItemCount);
      }
    } else {
      // If online, get all audio items from the user's view
      items = await _jellyfinApiHelper.getItems(
        parentItem: _finampUserHelper.currentUser!.currentView,
        includeItemTypes: "Audio",
        filters: onlyShowFavourites ? "IsFavorite" : null,
        limit: FinampSettingsHelper.finampSettings.songShuffleItemCount,
        sortBy: "Random",
      );
    }

    if (items != null) {
      await _queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type: onlyShowFavourites
              ? QueueItemSourceType.favorites
              : QueueItemSourceType.allSongs,
          name: QueueItemSourceName(
            type: onlyShowFavourites
                ? QueueItemSourceNameType.yourLikes
                : QueueItemSourceNameType.shuffleAll,
          ),
          id: "shuffleAll",
        ),
        order: FinampPlaybackOrder.shuffled,
      );
    }
  }

  /// Start instant mix from item.
  Future<void> startInstantMixForItem(jellyfin_models.BaseItemDto item) async {
    List<jellyfin_models.BaseItemDto>? items;

    try {
      items = await _jellyfinApiHelper.getInstantMix(item);
      if (items != null) {
        await _queueService.startPlayback(
          items: items,
          source: QueueItemSource(
              type: QueueItemSourceType.songMix,
              name: QueueItemSourceName(
                type: item.name != null
                    ? QueueItemSourceNameType.mix
                    : QueueItemSourceNameType.instantMix,
                localizationParameter: item.name ?? "",
              ),
              id: item.id),
          order: FinampPlaybackOrder
              .linear, // instant mixes should have their order determined by the server, especially to make sure the first item is the one that the mix is based off of
        );
      }
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Start instant mix from a selection of artists.
  Future<void> startInstantMixForArtists(List<BaseItemDto> artists) async {
    List<jellyfin_models.BaseItemDto>? items;

    try {
      items = await _jellyfinApiHelper
          .getArtistMix(artists.map((e) => e.id).toList());
      if (items != null) {
        await _queueService.startPlayback(
          items: items,
          source: QueueItemSource(
            type: QueueItemSourceType.artistMix,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.mix,
                localizationParameter: artists.map((e) => e.name).join(" & ")),
            id: artists.first.id,
            item: artists.first,
          ),
          order: FinampPlaybackOrder
              .linear, // instant mixes should have their order determined by the server, especially to make sure the first item is the one that the mix is based off of
        );
        _jellyfinApiHelper.clearArtistMixBuilderList();
      }
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Start instant mix from a selection of albums.
  Future<void> startInstantMixForAlbums(List<BaseItemDto> albums) async {
    List<jellyfin_models.BaseItemDto>? items;

    try {
      items = await _jellyfinApiHelper
          .getAlbumMix(albums.map((e) => e.id).toList());
      if (items != null) {
        await _queueService.startPlayback(
          items: items,
          source: QueueItemSource(
            type: QueueItemSourceType.albumMix,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.mix,
                localizationParameter: albums.map((e) => e.name).join(" & ")),
            id: albums.first.id,
            item: albums.first,
          ),
          order: FinampPlaybackOrder
              .linear, // instant mixes should have their order determined by the server, especially to make sure the first item is the one that the mix is based off of
        );
        _jellyfinApiHelper.clearAlbumMixBuilderList();
      }
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Start instant mix from a selection of genres.
  Future<void> startInstantMixForGenres(List<BaseItemDto> genres) async {
    List<jellyfin_models.BaseItemDto>? items;

    try {
      items = await _jellyfinApiHelper
          .getGenreMix(genres.map((e) => e.id).toList());
      if (items != null) {
        await _queueService.startPlayback(
          items: items,
          source: QueueItemSource(
            type: QueueItemSourceType.genreMix,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.mix,
                localizationParameter: genres.map((e) => e.name).join(" & ")),
            id: genres.first.id,
            item: genres.first,
          ),
          order: FinampPlaybackOrder
              .linear, // instant mixes should have their order determined by the server, especially to make sure the first item is the one that the mix is based off of
        );
        _jellyfinApiHelper.clearAlbumMixBuilderList();
      }
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }
}
