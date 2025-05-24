import 'dart:async';

import 'package:finamp/components/curated_item_filter_row.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'downloads_service.dart';
import 'finamp_settings_helper.dart';
import 'jellyfin_api_helper.dart';

part 'artist_content_provider.g.dart';

// Get the Tracks Section content of an artist
@riverpod
Future<
    (
      List<BaseItemDto>,
      CuratedItemSelectionType,
      Set<CuratedItemSelectionType>?
    )> getArtistTracksSection(
  Ref ref,
  BaseItemDto parent,
  BaseItemDto? library,
  BaseItemDto? genreFilter,
) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
  final bool autoSwitchItemCurationTypeEnabled =
      ref.watch(finampSettingsProvider.autoSwitchItemCurationType);
  final Set<CuratedItemSelectionType> disabledFilters = {};
  final artistCuratedItemSectionFilterOrder =
      ref.watch(finampSettingsProvider.artistItemSectionFilterChipOrder);
  CuratedItemSelectionType currentSelectionType = handleOfflineFallbackOption(
    isOffline: isOffline,
    currentFilter:
        ref.watch(finampSettingsProvider.artistCuratedItemSelectionType),
    filterListFor: BaseItemDtoType.track,
    customFilterOrder: artistCuratedItemSectionFilterOrder,
  );
  // If Tracks Section is disabled, we return an empty list
  if (!ref.watch(finampSettingsProvider.showArtistsTracksSection)) {
    return (<BaseItemDto>[], currentSelectionType, null);
  }

  // Get Items
  Future<List<BaseItemDto>> fetchItems(
      CuratedItemSelectionType selectionType) async {
    final sortBy = selectionType.getSortBy();
    if (isOffline) {
      // In Offline Mode:
      // We already fetch all tracks for the playback,
      // and as in offline mode this is much faster,
      // we just sort them and only return the first 5 items.
      final onlyFavorites =
          (selectionType == CuratedItemSelectionType.favorites);
      final List<BaseItemDto> allArtistTracks = await ref.watch(
        getArtistTracksProvider(parent, library, genreFilter,
                onlyFavorites: onlyFavorites)
            .future,
      );
      var items = sortItems(allArtistTracks, sortBy, SortOrder.descending);
      items = items.take(5).toList();
      return items;
    } else {
      // In Online Mode:
      final List<BaseItemDto>? topAlbumArtistTracks =
          await jellyfinApiHelper.getItems(
        libraryFilter: library,
        parentItem: parent,
        genreFilter: genreFilter,
        artistType: ArtistType.albumartist,
        sortBy: sortBy.jellyfinName(TabContentType.tracks),
        sortOrder: "Descending",
        isFavorite:
            (selectionType == CuratedItemSelectionType.favorites) ? true : null,
        limit: 5,
        includeItemTypes: "Audio",
      );
      // For everything except Favorites we can re-use the data from the other provider
      // The other provider would not limit the favorites but run a separate call anyway
      // so we would get a lot of overhead and therefore we are just doing it right here
      final List<BaseItemDto>? topPerformingArtistTracks = (selectionType !=
              CuratedItemSelectionType.favorites)
          ? await ref.watch(
              getPerformingArtistTracksProvider(parent, library, genreFilter)
                  .future)
          : await jellyfinApiHelper.getItems(
              libraryFilter: library,
              parentItem: parent,
              genreFilter: genreFilter,
              artistType: ArtistType.artist,
              sortBy: sortBy.jellyfinName(TabContentType.tracks),
              sortOrder: "Descending",
              isFavorite: true,
              limit: 5,
              includeItemTypes: "Audio",
            );

      final Map<String, BaseItemDto> distinctMap = {
        for (final track in [
          ...?topAlbumArtistTracks,
          ...?topPerformingArtistTracks
        ])
          track.id.toString(): track,
      };

      final List<BaseItemDto> distinctTracks = distinctMap.values.toList();
      var items = sortItems(distinctTracks, sortBy, SortOrder.descending);
      items = items.take(5).toList();
      return items;
    }
  }

  List<BaseItemDto> filterResult(
      List<BaseItemDto> result, CuratedItemSelectionType curatedItemType) {
    if (curatedItemType == CuratedItemSelectionType.mostPlayed) {
      return result
          .where((s) => (s.userData?.playCount ?? 0) > 0)
          .take(5)
          .toList();
    } else if (curatedItemType == CuratedItemSelectionType.recentlyPlayed) {
      return result
          .where((s) => s.userData?.lastPlayedDate != null)
          .take(5)
          .toList();
    } else {
      return result.take(5).toList();
    }
  }

  var result = await fetchItems(currentSelectionType);
  var filteredResult = filterResult(result, currentSelectionType);

  while (autoSwitchItemCurationTypeEnabled &&
      filteredResult.isEmpty &&
      (currentSelectionType == CuratedItemSelectionType.favorites ||
          currentSelectionType == CuratedItemSelectionType.mostPlayed ||
          currentSelectionType == CuratedItemSelectionType.recentlyPlayed)) {
    // Add the currentSelectionType to a Set of disabled types
    disabledFilters.add(currentSelectionType);
    // Get next fallback
    CuratedItemSelectionType newSelectionType = getFallbackFilterOption(
      isOffline: isOffline,
      currentType: currentSelectionType,
      filterListFor: BaseItemDtoType.track,
      customFilterOrder: artistCuratedItemSectionFilterOrder,
      disabledFilters: disabledFilters,
    );
    // Break if we are cycling without new options
    if (newSelectionType == currentSelectionType) break;
    // Call fetchItems again with the newSelectionType
    currentSelectionType = newSelectionType;
    result = await fetchItems(currentSelectionType);
    filteredResult = filterResult(result, currentSelectionType);
  }

  return (filteredResult, currentSelectionType, disabledFilters);
}

// Get Albums where the artist is an album artist
@riverpod
Future<List<BaseItemDto>> getArtistAlbums(
  Ref ref,
  BaseItemDto parent,
  BaseItemDto? library,
  BaseItemDto? genreFilter,
) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
  // Get Items
  if (isOffline) {
    // In Offline Mode:
    // Get Albums where artist is Album Artist sorted by Premiere Date
    final List<DownloadStub> fetchArtistAlbums =
        await downloadsService.getAllCollections(
            viewFilter: library?.id,
            childViewFilter: null,
            nullableViewFilters: ref
                .watch(finampSettingsProvider.showDownloadsWithUnknownLibrary),
            baseTypeFilter: BaseItemDtoType.album,
            relatedTo: parent,
            artistType: ArtistType.albumartist,
            genreFilter: genreFilter);
    fetchArtistAlbums.sort((a, b) => (a.baseItem?.premiereDate ?? "")
        .compareTo(b.baseItem!.premiereDate ?? ""));
    final List<BaseItemDto> artistAlbums =
        fetchArtistAlbums.map((e) => e.baseItem).nonNulls.toList();
    return artistAlbums;
  } else {
    // In Online Mode:
    // Get Albums where artist is Album Artist sorted by Premiere Date
    final List<BaseItemDto>? artistAlbums = await jellyfinApiHelper.getItems(
        libraryFilter: library,
        parentItem: parent,
        genreFilter: genreFilter,
        sortBy: "PremiereDate,SortName",
        includeItemTypes: "MusicAlbum",
        artistType: ArtistType.albumartist);
    return artistAlbums ?? [];
  }
}

// Get Albums with tracks in it on which the artist is a performing artist
// (note that this also might include albums where the artist is album artist as well,
// so we have to filter this list later for the appears on section to exclude those)
@riverpod
Future<List<BaseItemDto>> getPerformingArtistAlbums(
  Ref ref,
  BaseItemDto parent,
  BaseItemDto? library,
  BaseItemDto? genreFilter,
) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
  // Get Items
  if (isOffline) {
    // In Offline Mode:
    // Get Albums where artist is Performing Artist sorted by Premiere Date
    final List<DownloadStub> fetchPerformingArtistAlbums =
        await downloadsService.getAllCollections(
            viewFilter: library?.id,
            childViewFilter: null,
            nullableViewFilters: ref
                .watch(finampSettingsProvider.showDownloadsWithUnknownLibrary),
            baseTypeFilter: BaseItemDtoType.album,
            relatedTo: parent,
            artistType: ArtistType.artist,
            genreFilter: genreFilter);
    fetchPerformingArtistAlbums.sort((a, b) => (a.baseItem?.premiereDate ?? "")
        .compareTo(b.baseItem!.premiereDate ?? ""));
    final List<BaseItemDto> performingArtistAlbums =
        fetchPerformingArtistAlbums.map((e) => e.baseItem).nonNulls.toList();
    return performingArtistAlbums;
  } else {
    // In Online Mode:
    // Get Albums where artist is Performing Artist sorted by Premiere Date
    final List<BaseItemDto>? performingArtistAlbums =
        await jellyfinApiHelper.getItems(
      libraryFilter: library,
      parentItem: parent,
      genreFilter: genreFilter,
      sortBy: "PremiereDate,SortName",
      includeItemTypes: "MusicAlbum",
      artistType: ArtistType.artist,
    );
    return performingArtistAlbums ?? [];
  }
}

// Fetch every performing artist track
// (note that this intentionally also includes tracks
// where the artist is also an album artist)
@riverpod
Future<List<BaseItemDto>> getPerformingArtistTracks(
  Ref ref,
  BaseItemDto parent,
  BaseItemDto? library,
  BaseItemDto? genreFilter, {
  bool onlyFavorites = false,
}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final bool isOffline = ref.watch(finampSettingsProvider.isOffline);

  // Get Items
  if (isOffline) {
    // In Offline Mode:
    final List<BaseItemDto> performingArtistTracks = [];
    // Fetch every album where the artist is a performing artist
    final List<BaseItemDto> allPerformingArtistAlbums = await ref.watch(
      getPerformingArtistAlbumsProvider(parent, library, genreFilter).future,
    );
    // Loop through the albums and add the tracks
    for (var album in allPerformingArtistAlbums) {
      final performingArtistAlbumTracks =
          await downloadsService.getCollectionTracks(
        album,
        playable: true,
        onlyFavorites: onlyFavorites,
      );
      // Now we remove every track where the artist is NOT an performing artist...
      final filteredPerformingArtistTracks =
          performingArtistAlbumTracks.where((track) {
        return track.artistItems?.any((artist) => artist.id == parent.id) ??
            false;
      });
      // and add the tracks to the list
      performingArtistTracks.addAll(filteredPerformingArtistTracks);
    }
    return performingArtistTracks;
  } else {
    // In Online Mode:
    final List<BaseItemDto>? allPerformingArtistTracks =
        await jellyfinApiHelper.getItems(
      libraryFilter: library,
      parentItem: parent,
      genreFilter: genreFilter,
      sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
      includeItemTypes: "Audio",
      artistType: ArtistType.artist,
      isFavorite: (onlyFavorites == true) ? true : null,
    );
    return allPerformingArtistTracks ?? [];
  }
}

// Get all Tracks for playback
@riverpod
Future<List<BaseItemDto>> getArtistTracks(
  Ref ref,
  BaseItemDto parent,
  BaseItemDto? library,
  BaseItemDto? genreFilter, {
  bool onlyFavorites = false,
}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final isOffline = ref.watch(finampSettingsProvider.isOffline);
  // Get Items
  if (isOffline) {
    // In Offline Mode:
    // First fetch every album of the album artist
    final List<BaseItemDto> allAlbumArtistAlbums = await ref.watch(
      getArtistAlbumsProvider(parent, library, genreFilter).future,
    );
    // Then add the tracks of every album
    final List<BaseItemDto> sortedTracks = [];
    for (var album in allAlbumArtistAlbums) {
      sortedTracks.addAll(await downloadsService.getCollectionTracks(
        album,
        playable: true,
        onlyFavorites: onlyFavorites,
      ));
    }
    // Fetch every performing artist track
    final List<BaseItemDto> allPerformingArtistTracks = await ref.watch(
      getPerformingArtistTracksProvider(parent, library, genreFilter,
              onlyFavorites: onlyFavorites)
          .future,
    );
    // Filter out the tracks already added through album artist albums
    final existingIds = sortedTracks.map((t) => t.id).toSet();
    final List<BaseItemDto> allPerformingArtistTracksFiltered =
        allPerformingArtistTracks
            .where((track) => !existingIds.contains(track.id))
            .toList();
    // Add the remaining tracks
    sortedTracks.addAll(allPerformingArtistTracksFiltered);
    // And return the tracks
    return sortedTracks;
  } else {
    // In Online Mode:
    // Fetch every album artist track
    final allAlbumArtistTracksResponse = await jellyfinApiHelper.getItems(
      libraryFilter: library,
      parentItem: parent,
      genreFilter: genreFilter,
      sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
      includeItemTypes: "Audio",
      artistType: ArtistType.albumartist,
    );
    // Get all performing artist tracks
    final List<BaseItemDto> allPerformingArtistTracks = await ref.watch(
      getPerformingArtistTracksProvider(parent, library, genreFilter,
              onlyFavorites: onlyFavorites)
          .future,
    );
    // We now remove albumartist tracks from performance artist tracks to avoid duplicates
    final allAlbumArtistTracks = allAlbumArtistTracksResponse ?? [];
    final allPerformingTracks = allPerformingArtistTracks;
    final albumArtistTrackIds =
        allAlbumArtistTracks.map((item) => item.id).toSet();
    final filteredPerformingTracks = allPerformingTracks
        .where((performingTrack) =>
            !albumArtistTrackIds.contains(performingTrack.id))
        .toList();
    // combine and return
    final combinedTracks = [
      ...allAlbumArtistTracks,
      ...filteredPerformingTracks
    ];
    return combinedTracks;
  }
}
