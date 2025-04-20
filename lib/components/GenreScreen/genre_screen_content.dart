import 'dart:async';

import 'package:finamp/components/ArtistScreen/artist_screen_sections.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/download_button.dart';
import '../padded_custom_scrollview.dart';

class GenreScreenContent extends ConsumerStatefulWidget {
  const GenreScreenContent({
    super.key,
    required this.parent
  });

  final BaseItemDto parent;

  @override
  ConsumerState<GenreScreenContent> createState() =>
      _GenreScreenContentState();
}

class _GenreScreenContentState extends ConsumerState<GenreScreenContent> {
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsService = GetIt.instance<DownloadsService>();
  bool _isLoading = true;

  StreamSubscription<void>? _refreshStream;

  @override
  void initState() {
    _refreshStream = _downloadsService.offlineDeletesStream.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _refreshStream?.cancel();
    super.dispose();
  }

  void openSeeAll(TabContentType tabContentType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MusicScreen(
          genreFilter: widget.parent,
          tabTypeFilter: tabContentType,
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    final Future<List<List<BaseItemDto>?>> futures;
    final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
    var settings = FinampSettingsHelper.finampSettings;
    List<BaseItemDto> allChildren = [];

    final genreCuratedItemSelectionType = (isOffline)
        ? ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeOffline)
        : ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeOnline);

    // Get Items
    if (isOffline) {
      // Offline Mode
        var artistInfoForType = (settings.artistListType == ArtistType.albumartist)
            ? BaseItemDtoType.album
            : BaseItemDtoType.track;

      futures = Future.wait([
        // Tracks
        Future.sync(() async {
          List<BaseItemDto>? fetched = [];
          if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.randomWithFavorites ||
            genreCuratedItemSelectionType == GenreCuratedItemSelectionType.favoritesOnly) {
              final List<DownloadStub> genreTracksFavorites =
                await _downloadsService.getAllTracks(
                  nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
                  onlyFavorites: settings.trackOfflineFavorites,
                  genreFilter: widget.parent
              );
              var items = genreTracksFavorites.map((e) => e.baseItem).nonNulls.toList();
              items = sortItems(items, SortBy.random, SortOrder.descending);
              items = items.take(5).toList();
              fetched.addAll(items);
          }
          if (genreCuratedItemSelectionType != GenreCuratedItemSelectionType.favoritesOnly &&
            fetched.length < 5) {
            var remainingLimit = 5 - fetched.length;
            final List<DownloadStub> genreTracks =
              await _downloadsService.getAllTracks(
                nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
                genreFilter: widget.parent
            );
            var items = genreTracks.map((e) => e.baseItem).nonNulls
              .where((item) => !fetched.contains(item)).toList();
            items = sortItems(items, SortBy.random, SortOrder.descending);
            items = items.take(remainingLimit).toList();
            fetched.addAll(items);
          }
          return fetched;
        }),
        // Albums
        Future.sync(() async {
          List<BaseItemDto>? fetched = [];
          if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.randomWithFavorites ||
            genreCuratedItemSelectionType == GenreCuratedItemSelectionType.favoritesOnly) {
              final List<DownloadStub> genreAlbumsFavorites =
                await _downloadsService.getAllCollections(
                  baseTypeFilter: BaseItemDtoType.album,
                  fullyDownloaded: settings.onlyShowFullyDownloaded,
                  onlyFavorites: settings.trackOfflineFavorites,
                  genreFilter: widget.parent
              );
              var items = genreAlbumsFavorites.map((e) => e.baseItem).nonNulls.toList();
              items = sortItems(items, SortBy.random, SortOrder.descending);
              items = items.take(5).toList();
              fetched.addAll(items);
          }
          if (genreCuratedItemSelectionType != GenreCuratedItemSelectionType.favoritesOnly &&
            fetched.length < 5) {
            var remainingLimit = 5 - fetched.length;
            final List<DownloadStub> genreAlbums =
                await _downloadsService.getAllCollections(
                  baseTypeFilter: BaseItemDtoType.album,
                  fullyDownloaded: settings.onlyShowFullyDownloaded,
                  genreFilter: widget.parent
              );
            var items = genreAlbums.map((e) => e.baseItem).nonNulls
              .where((item) => !fetched.contains(item)).toList();
            items = sortItems(items, SortBy.random, SortOrder.descending);
            items = items.take(remainingLimit).toList();
            fetched.addAll(items);
          }
          return fetched;
        }),
        // Artists
        Future.sync(() async {
          List<BaseItemDto>? fetched = [];
          if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.randomWithFavorites ||
            genreCuratedItemSelectionType == GenreCuratedItemSelectionType.favoritesOnly) {
              final List<DownloadStub> genreArtistsFavorites =
                await _downloadsService.getAllCollections(
                  baseTypeFilter: BaseItemDtoType.artist,
                  fullyDownloaded: settings.onlyShowFullyDownloaded,
                  onlyFavorites: settings.trackOfflineFavorites,
                  infoForType: artistInfoForType,
                  genreFilter: widget.parent
              );
              var items = genreArtistsFavorites.map((e) => e.baseItem).nonNulls.toList();
              items = sortItems(items, SortBy.random, SortOrder.descending);
              items = items.take(5).toList();
              fetched.addAll(items);
          }
          if (genreCuratedItemSelectionType != GenreCuratedItemSelectionType.favoritesOnly &&
            fetched.length < 5) {
            var remainingLimit = 5 - fetched.length;
            final List<DownloadStub> genreArtists =
                await _downloadsService.getAllCollections(
                  baseTypeFilter: BaseItemDtoType.artist,
                  fullyDownloaded: settings.onlyShowFullyDownloaded,
                  infoForType: artistInfoForType,
                  genreFilter: widget.parent
              );
            var items = genreArtists.map((e) => e.baseItem).nonNulls
              .where((item) => !fetched.contains(item)).toList();
            items = sortItems(items, SortBy.random, SortOrder.descending);
            items = items.take(remainingLimit).toList();
            fetched.addAll(items);
          }
          return fetched;
        }),
      ]);

      // Get All downloaded Tracks for Playback
      Future.sync(() async {
       final List<DownloadStub> allGenreTracks =
              await _downloadsService.getAllTracks(
                nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
                onlyFavorites:
                    settings.onlyShowFavourites && settings.trackOfflineFavorites,
                genreFilter: widget.parent
          );
        // First fetch every album of the album artist or genre
        var items = allGenreTracks.map((e) => e.baseItem).nonNulls.toList();
        items = sortItems(items, settings.tabSortBy[TabContentType.tracks],
        settings.tabSortOrder[TabContentType.tracks]);
        return items;
      });
    } else {
      // Online Mode
      futures = Future.wait([
        // Tracks 
        Future.sync(() async {
          List<BaseItemDto>? fetched = [];
          if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.mostPlayed) {
            fetched = await jellyfinApiHelper.getItems(
              parentItem: widget.parent,
              sortBy: "PlayCount,SortName",
              sortOrder: "Descending",
              limit: 5,
              includeItemTypes: "Audio",
            );
          } else {
            if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.randomWithFavorites ||
            genreCuratedItemSelectionType == GenreCuratedItemSelectionType.favoritesOnly) {
              fetched = await jellyfinApiHelper.getItems(
                parentItem: widget.parent,
                sortBy: "Random",
                filters: "IsFavoriteOrLikes",
                limit: 5,
                includeItemTypes: "Audio",
                );
            }
            if (genreCuratedItemSelectionType != GenreCuratedItemSelectionType.favoritesOnly && 
              fetched!.length < 5) {
                var remainingLimit = 5 - fetched.length;
                var randomTracks = await jellyfinApiHelper.getItems(
                  parentItem: widget.parent,
                  sortBy: "Random",
                  limit: remainingLimit,
                  includeItemTypes: "Audio",
                );
                fetched = [...fetched, ...randomTracks ?? []];
            }
          }
          return fetched;
        }),
        // Albums
        Future.sync(() async {
          List<BaseItemDto>? fetched = [];
          if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.mostPlayed) {
            fetched = await jellyfinApiHelper.getItems(
              parentItem: widget.parent,
              sortBy: "PlayCount,PremiereDate,SortName",
              sortOrder: "Descending",
              limit: 5,
              includeItemTypes: "MusicAlbum",
            );
          } else {
            if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.randomWithFavorites ||
            genreCuratedItemSelectionType == GenreCuratedItemSelectionType.favoritesOnly) {
              fetched = await jellyfinApiHelper.getItems(
                parentItem: widget.parent,
                sortBy: "Random",
                filters: "IsFavoriteOrLikes",
                limit: 5,
                includeItemTypes: "MusicAlbum",
              );
            }
            if (genreCuratedItemSelectionType != GenreCuratedItemSelectionType.favoritesOnly) {
              if (fetched!.length < 5) {
                var remainingLimit = 5 - fetched.length;
                var randomAlbums = await jellyfinApiHelper.getItems(
                  parentItem: widget.parent,
                  sortBy: "Random",
                  limit: remainingLimit,
                  includeItemTypes: "MusicAlbum",
                );
                fetched = [...fetched, ...randomAlbums ?? []];
              }
            }
          }
          return fetched;
        }),
        // Artists
        Future.sync(() async {
          List<BaseItemDto>? fetched = [];
          if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.mostPlayed) {
            fetched = await jellyfinApiHelper.getItems(
              genreFilter: widget.parent,
              sortBy: "PlayCount,SortName",
              sortOrder: "Descending",
              limit: 5,
              includeItemTypes: "MusicArtist",
              artistType: settings.artistListType,
            );
          } else {
            if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.randomWithFavorites ||
            genreCuratedItemSelectionType == GenreCuratedItemSelectionType.favoritesOnly) {
              fetched = await jellyfinApiHelper.getItems(
                genreFilter: widget.parent,
                sortBy: "Random",
                filters: "IsFavoriteOrLikes",
                limit: 5,
                includeItemTypes: "MusicArtist",
              );
            }
            if (genreCuratedItemSelectionType != GenreCuratedItemSelectionType.favoritesOnly) {
              if (fetched!.length < 5) {
                var remainingLimit = 5 - fetched.length;
                var randomArtists = await jellyfinApiHelper.getItems(
                  genreFilter: widget.parent,
                  sortBy: "Random",
                  limit: remainingLimit,
                  includeItemTypes: "MusicArtist",
                );
                fetched = [...fetched, ...randomArtists ?? []];
              }
            }
          }
          return fetched;
        }),
      ]);

      // Get All Tracks for Download Sync Button and Playback
      Future.sync(() async {
        // Fetch every genre track
        return await jellyfinApiHelper.getItems(
          parentItem: widget.parent,
          sortBy: settings.tabSortBy[TabContentType.tracks]
                ?.jellyfinName(TabContentType.tracks) ?? "Album,SortName",
                  includeItemTypes: "Audio",
        );
      });
    }

    return FutureBuilder(
        future: futures,
        builder: (context, snapshot) {
          _isLoading = (snapshot.connectionState == ConnectionState.waiting);
          var tracks = snapshot.data?.elementAtOrNull(0) ?? [];
          var topAlbums = snapshot.data?.elementAtOrNull(1) ?? [];
          var topArtists = snapshot.data?.elementAtOrNull(2) ?? [];
          var allTracks = snapshot.data?.elementAtOrNull(3) ?? [];

          allChildren = [...allTracks];

          return PaddedCustomScrollview(slivers: <Widget>[
            SliverAppBar(
              title: Text(widget.parent.name ??
                  AppLocalizations.of(context)!.unknownName),
              pinned: true,
              actions: [
                if (!_isLoading)
                  DownloadButton(
                      item: DownloadStub.fromItem(
                          item: widget.parent,
                          type: DownloadItemType.collection),
                      children: (allChildren.isNotEmpty) ? allChildren : null)
              ],
            ),
            if (!_isLoading)
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 12.0),
                sliver: TracksSection(
                  parent: widget.parent,
                  tracks: tracks,
                  childrenForQueue: Future.value(tracks),
                  tracksText: genreCuratedItemSelectionType.toLocalisedSectionTitle(context, BaseItemDtoType.track),
                  seeAllCallbackFunction: () => openSeeAll(TabContentType.tracks),
                ),
              ),
            if (!_isLoading)
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 12.0),
                sliver: AlbumSection(
                  parent: widget.parent,
                  albumsText: genreCuratedItemSelectionType.toLocalisedSectionTitle(context, BaseItemDtoType.album),
                  albums: topAlbums,
                  seeAllCallbackFunction: () => openSeeAll(TabContentType.albums),
                ),
              ),
            if (!_isLoading)
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 12.0),
                sliver: AlbumSection(
                  parent: widget.parent,
                  albumsText: genreCuratedItemSelectionType.toLocalisedSectionTitle(context, BaseItemDtoType.artist),
                  albums: topArtists,
                  seeAllCallbackFunction: () => openSeeAll(TabContentType.artists),
                  genreFilter: widget.parent,
                ),
              ),
            if (_isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              )
          ]);
        });
  }

}