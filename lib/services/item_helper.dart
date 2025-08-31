import 'package:collection/collection.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/album_screen_provider.dart';
import 'package:finamp/services/artist_content_provider.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

Future<List<BaseItemDto>> loadChildTracks({
  required PlayableItem item,
  BaseItemDto? genreFilter,
  bool shuffleGenreAlbums = false,
}) {
  switch (item) {
    case AlbumDisc():
      return Future.value(item.tracks);
    case BaseItemDto():
      if (shuffleGenreAlbums) {
        return loadChildTracksFromShuffledGenreAlbums(baseItem: item);
      }
      return loadChildTracksFromBaseItem(baseItem: item, genreFilter: genreFilter);
  }
}

Future<List<BaseItemDto>> loadChildTracksFromBaseItem({required BaseItemDto baseItem, BaseItemDto? genreFilter}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();
  final settings = FinampSettingsHelper.finampSettings;
  final ref = GetIt.instance<ProviderContainer>();

  final Future<List<BaseItemDto>?> newItemsFuture;

  if (settings.isOffline) {
    newItemsFuture = loadChildTracksOffline(baseItem: baseItem, genreFilter: genreFilter);
  } else {
    switch (BaseItemDtoType.fromItem(baseItem)) {
      case BaseItemDtoType.track:
        newItemsFuture = Future.value([baseItem]);
        break;
      case BaseItemDtoType.album:
        newItemsFuture = ref
            .read(getAlbumOrPlaylistTracksProvider(baseItem).future)
            .then((value) => value.$2); // get playable tracks
      case BaseItemDtoType.playlist:
        newItemsFuture = ref
            .read(getSortedPlaylistTracksProvider(baseItem, genreFilter: genreFilter).future)
            .then((value) => value.$2); // get playable tracks
        break;
      case BaseItemDtoType.artist:
        newItemsFuture = ref.read(
          getArtistTracksProvider(baseItem, finampUserHelper.currentUser?.currentView, genreFilter).future,
        );
        break;
      case BaseItemDtoType.genre:
        newItemsFuture = jellyfinApiHelper.getItems(
          parentItem: finampUserHelper.currentUser?.currentView,
          includeItemTypes: [BaseItemDtoType.track.idString].join(","),
          limit: FinampSettingsHelper.finampSettings.trackShuffleItemCount,
          genreFilter: baseItem,
          sortBy: "Random", // important, as we load limited tracks and otherwise would always get the same
        );
        break;
      default:
        newItemsFuture = jellyfinApiHelper.getItems(
          parentItem: baseItem,
          includeItemTypes: [BaseItemDtoType.track.idString].join(","),
          sortBy: "ParentIndexNumber,IndexNumber,SortName",
          sortOrder: null,
          genreFilter: genreFilter,
          // filters: settings.onlyShowFavorites ? "IsFavorite" : null,
        );
    }
  }

  final List<BaseItemDto>? newItems = await newItemsFuture;

  if (newItems == null) {
    GlobalSnackbar.message(
      (scaffold) => AppLocalizations.of(scaffold)!.couldNotLoad(BaseItemDtoType.fromItem(baseItem).name),
    );
    return [];
  }

  return newItems;
}

List<BaseItemDto> groupItems({
  required List<BaseItemDto> items,
  required String? Function(BaseItemDto) groupListBy,
  bool manuallyShuffle = false,
}) {
  var albums = items.groupListsBy(groupListBy).values.toList();
  if (manuallyShuffle) {
    albums = albums..shuffle();
  }
  return albums.flattened.toList();
}

Future<List<BaseItemDto>?> loadChildTracksOffline({
  required BaseItemDto baseItem,
  int? limit,
  BaseItemDto? genreFilter,
}) async {
  final downloadsService = GetIt.instance<DownloadsService>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();
  final settings = FinampSettingsHelper.finampSettings;

  List<BaseItemDto> items;

  switch (BaseItemDtoType.fromItem(baseItem)) {
    case BaseItemDtoType.track:
      items = [baseItem];
      break;
    case BaseItemDtoType.genre:
      items = (await downloadsService.getAllTracks(
        viewFilter: finampUserHelper.currentUser?.currentView?.id,
        genreFilter: baseItem,
        nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
      )).map((e) => e.baseItem!).toList();
      items.shuffle();
      if (items.length - 1 > settings.trackShuffleItemCount) {
        items = items.sublist(0, settings.trackShuffleItemCount);
      }
      break;
    case BaseItemDtoType.playlist:
      items = await GetIt.instance<ProviderContainer>()
          .read(getSortedPlaylistTracksProvider(baseItem, genreFilter: genreFilter).future)
          .then((value) => value.$2); // get playable tracks
    case BaseItemDtoType.artist:
      items = await GetIt.instance<ProviderContainer>().read(
        getArtistTracksProvider(baseItem, finampUserHelper.currentUser?.currentView, genreFilter).future,
      );
      break;
    default:
      items = await downloadsService.getCollectionTracks(baseItem, playable: true, genreFilter: genreFilter);
      break;
  }

  return (limit != null ? items.take(limit) : items).toList();
}

Future<List<BaseItemDto>> loadChildTracksFromShuffledGenreAlbums({required BaseItemDto baseItem}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final ref = GetIt.instance<ProviderContainer>();
  final settings = FinampSettingsHelper.finampSettings;

  List<BaseItemDto> newItems = [];

  // We assume that there are roughly 10 tracks per album
  final albumLimit = (settings.trackShuffleItemCount / 10).toInt();
  int totalTrackLimit = settings.trackShuffleItemCount;

  if (settings.isOffline) {
    List<DownloadStub> fetchedGenreAlbums = await downloadsService.getAllCollections(
      baseTypeFilter: BaseItemDtoType.album,
      fullyDownloaded: ref.read(finampSettingsProvider.onlyShowFullyDownloaded),
      viewFilter: finampUserHelper.currentUser?.currentView?.id,
      childViewFilter: finampUserHelper.currentUser?.currentView?.id,
      nullableViewFilters: ref.read(finampSettingsProvider.showDownloadsWithUnknownLibrary),
      genreFilter: baseItem,
    );
    var genreAlbums = fetchedGenreAlbums.map((e) => e.baseItem).nonNulls.toList();
    genreAlbums = sortItems(genreAlbums, SortBy.random, SortOrder.descending);
    genreAlbums = genreAlbums.take(albumLimit).toList();

    // Load Tracks of Albums
    for (final album in genreAlbums) {
      // We stop if the totalTrackLimit is reached
      if (totalTrackLimit <= 0) break;

      List<BaseItemDto> playableAlbumTracks = await downloadsService.getCollectionTracks(album, playable: true);
      if (playableAlbumTracks.isEmpty) continue;

      // We don't add the album if it would exceed the totalTrackLimit
      if (totalTrackLimit - playableAlbumTracks.length < 0) break;

      // Add the tracks and decrease the total limit
      newItems.addAll(playableAlbumTracks);
      totalTrackLimit -= playableAlbumTracks.length;
    }
  } else {
    List<BaseItemDto>? genreAlbums = await jellyfinApiHelper.getItems(
      parentItem: finampUserHelper.currentUser?.currentView,
      includeItemTypes: [BaseItemDtoType.album.idString].join(","),
      limit: albumLimit,
      genreFilter: baseItem,
      sortBy: "Random", // important, as we load limited albums and otherwise would always get the same
    );

    // Load Tracks of Albums
    if (genreAlbums != null) {
      for (final album in genreAlbums) {
        // We stop if the totalTrackLimit is reached
        if (totalTrackLimit <= 0) break;

        List<BaseItemDto>? newAlbumTracks =
            await jellyfinApiHelper.getItems(
              parentItem: album,
              includeItemTypes: [BaseItemDtoType.track.idString].join(","),
              sortBy: "ParentIndexNumber,IndexNumber,SortName",
            ) ??
            [];
        if (newAlbumTracks.isEmpty) continue;

        // We don't add the album if it would exceed the totalTrackLimit
        if (totalTrackLimit - newAlbumTracks.length < 0) break;

        // Add the tracks and decrease the total limit
        newItems.addAll(newAlbumTracks);
        totalTrackLimit -= newAlbumTracks.length;
      }
    }
  }

  if (newItems.isEmpty) {
    GlobalSnackbar.message(
      (scaffold) => AppLocalizations.of(scaffold)!.couldNotLoad(BaseItemDtoType.fromItem(baseItem).name),
    );
  }

  return newItems;
}
