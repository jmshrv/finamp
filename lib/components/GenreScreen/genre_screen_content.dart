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
    final genreCuratedItemSelectionType =
        ref.watch(finampSettingsProvider.genreCuratedItemSelectionType);


    Future<List<BaseItemDto>?> getCuratedItemsOnline({
      required GenreCuratedItemSelectionType genreCuratedItemSelectionType,
      required BaseItemDtoType itemType,
      required String sortBySecondary,
      ArtistType? artistListType,
    }) async {
      List<BaseItemDto>? fetched = [];
      if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.mostPlayed ||
          genreCuratedItemSelectionType == GenreCuratedItemSelectionType.recentlyAdded ||
          genreCuratedItemSelectionType == GenreCuratedItemSelectionType.latestReleases) {
        var sortByMain = 
          (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.mostPlayed)
            ? "PlayCount"
            : (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.recentlyAdded)
              ? "DateCreated"
              : "PremiereDate";
        var mostPlayedOrLatestItems = await jellyfinApiHelper.getItems(
          parentItem: (itemType == BaseItemDtoType.artist) 
              ? null : widget.parent,
          genreFilter: (itemType == BaseItemDtoType.artist)
              ? widget.parent : null, 
          sortBy: [sortByMain, sortBySecondary].where((s) => s.isNotEmpty).join(','),
          sortOrder: "Descending",
          limit: 5,
          includeItemTypes: itemType.idString,
          artistType: (itemType == BaseItemDtoType.artist)
              ? artistListType : null,
        );
        fetched.addAll(mostPlayedOrLatestItems ?? []);
      } else {
        if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.randomFavoritesFirst ||
            genreCuratedItemSelectionType == GenreCuratedItemSelectionType.favorites) {
          var favoriteItems = await jellyfinApiHelper.getItems(
            parentItem: (itemType == BaseItemDtoType.artist) 
                ? null : widget.parent,
            genreFilter: (itemType == BaseItemDtoType.artist)
                ? widget.parent : null, 
            sortBy: "Random",
            isFavorite: true,
            limit: 5,
            includeItemTypes: itemType.idString,
            artistType: (itemType == BaseItemDtoType.artist)
              ? artistListType : null,
          );
          fetched.addAll(favoriteItems ?? []);
        }
        if (genreCuratedItemSelectionType != GenreCuratedItemSelectionType.favorites &&
            fetched.length < 5) {
          var remainingLimit = 5 - fetched.length;
          var randomItems = await jellyfinApiHelper.getItems(
            parentItem: (itemType == BaseItemDtoType.artist) 
                ? null : widget.parent,
            genreFilter: (itemType == BaseItemDtoType.artist)
                ? widget.parent : null, 
            sortBy: "Random",
            isFavorite: false,
            limit: remainingLimit,
            includeItemTypes: itemType.idString,
            artistType: (itemType == BaseItemDtoType.artist)
              ? artistListType : null,
          );
          fetched.addAll(randomItems ?? []);
        }
      }
      return fetched;
    }

    Future<List<BaseItemDto>?> getCuratedItemsOffline({
      required GenreCuratedItemSelectionType genreCuratedItemSelectionType,
      required BaseItemDtoType baseItemType,
      BaseItemDtoType? artistInfoForType,
    }) async {
      List<BaseItemDto>? fetched = [];
      if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.mostPlayed ||
          genreCuratedItemSelectionType == GenreCuratedItemSelectionType.recentlyAdded ||
          genreCuratedItemSelectionType == GenreCuratedItemSelectionType.latestReleases) {
        final List<DownloadStub> mostPlayedOrLatestItems = (baseItemType == BaseItemDtoType.track)
          ? await _downloadsService.getAllTracks(
                nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
                genreFilter: widget.parent)
          : await _downloadsService.getAllCollections(
                baseTypeFilter: baseItemType,
                fullyDownloaded: settings.onlyShowFullyDownloaded,
                infoForType: (baseItemType == BaseItemDtoType.artist)
                  ? artistInfoForType : null,
                genreFilter: widget.parent);
        var sortByValue = 
          (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.mostPlayed)
            ? SortBy.playCount 
            : (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.recentlyAdded)
              ? SortBy.dateCreated
              : SortBy.premiereDate;
        var items = mostPlayedOrLatestItems.map((e) => e.baseItem).nonNulls.toList();
        items = sortItems(items, sortByValue, SortOrder.descending);
        items = items.take(5).toList();
        fetched.addAll(items);
      } else {
        if (genreCuratedItemSelectionType == GenreCuratedItemSelectionType.randomFavoritesFirst ||
          genreCuratedItemSelectionType == GenreCuratedItemSelectionType.favorites) {
            final List<DownloadStub> genreItemsFavorites = (baseItemType == BaseItemDtoType.track)
              ? await _downloadsService.getAllTracks(
                    nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
                    onlyFavorites: settings.trackOfflineFavorites,
                    genreFilter: widget.parent)
              : await _downloadsService.getAllCollections(
                    baseTypeFilter: baseItemType,
                    fullyDownloaded: settings.onlyShowFullyDownloaded,
                    onlyFavorites: settings.trackOfflineFavorites,
                    infoForType: (baseItemType == BaseItemDtoType.artist)
                      ? artistInfoForType : null,
                    genreFilter: widget.parent);
            var items = genreItemsFavorites.map((e) => e.baseItem).nonNulls.toList();
            items = sortItems(items, SortBy.random, SortOrder.descending);
            items = items.take(5).toList();
            fetched.addAll(items);
        }
        if (genreCuratedItemSelectionType != GenreCuratedItemSelectionType.favorites &&
          fetched.length < 5) {
          var remainingLimit = 5 - fetched.length;
          final List<DownloadStub> genreItems = (baseItemType == BaseItemDtoType.track)
            ? await _downloadsService.getAllTracks(
                  nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
                  genreFilter: widget.parent)
            : await _downloadsService.getAllCollections(
                  baseTypeFilter: baseItemType,
                  fullyDownloaded: settings.onlyShowFullyDownloaded,
                  infoForType: (baseItemType == BaseItemDtoType.artist)
                      ? artistInfoForType : null,
                  genreFilter: widget.parent);
          var items = genreItems.map((e) => e.baseItem).nonNulls
            .where((item) => !fetched.contains(item)).toList();
          items = sortItems(items, SortBy.random, SortOrder.descending);
          items = items.take(remainingLimit).toList();
          fetched.addAll(items);
        }
      }
      return fetched;
    }

    // Get Items
    if (isOffline) {
      // Offline Mode
        var artistInfoForType = (settings.artistListType == ArtistType.albumartist)
            ? BaseItemDtoType.album
            : BaseItemDtoType.track;

      futures = Future.wait([
        // Tracks
        getCuratedItemsOffline(
          genreCuratedItemSelectionType: genreCuratedItemSelectionType,
          baseItemType: BaseItemDtoType.track,
        ),
        // Albums
        getCuratedItemsOffline(
          genreCuratedItemSelectionType: genreCuratedItemSelectionType,
          baseItemType: BaseItemDtoType.album,
        ),
        // Artists
        getCuratedItemsOffline(
          genreCuratedItemSelectionType: genreCuratedItemSelectionType,
          baseItemType: BaseItemDtoType.artist,
          artistInfoForType: artistInfoForType
        ),
      ]);
      // Get All downloaded Tracks for Playback
      Future.sync(() async {
        final List<DownloadStub> allGenreTracks =
              await _downloadsService.getAllTracks(
                nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
                genreFilter: widget.parent
          );
        var items = allGenreTracks.map((e) => e.baseItem).nonNulls.toList();
        items = sortItems(items, settings.tabSortBy[TabContentType.tracks],
        settings.tabSortOrder[TabContentType.tracks]);
        return items;
      });
    } else {
      // Online Mode
      futures = Future.wait([
        // Tracks 
        getCuratedItemsOnline(
          genreCuratedItemSelectionType: genreCuratedItemSelectionType,
          itemType: BaseItemDtoType.track,
          sortBySecondary: "SortName",
        ),
        // Albums
        getCuratedItemsOnline(
          genreCuratedItemSelectionType: genreCuratedItemSelectionType,
          itemType: BaseItemDtoType.album,
          sortBySecondary: "PremiereDate,SortName",
        ),
        // Artists
        getCuratedItemsOnline(
          genreCuratedItemSelectionType: genreCuratedItemSelectionType,
          itemType: BaseItemDtoType.artist,
          sortBySecondary: "SortName",
          artistListType: settings.artistListType,
        ),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: GenreCuratedItemSelectionType.values.asMap().entries.expand((entry) {
                      final int index = entry.key;
                      final type = entry.value;
                      final bool isSelected = genreCuratedItemSelectionType == type;
                      final colorScheme = Theme.of(context).colorScheme;
                      double leftPadding = index == 0 ? 8.0 : 0.0;
                      double rightPadding = index == GenreCuratedItemSelectionType.values.length - 1 ? 8.0 : 6.0;
                      return [
                        Padding(
                          padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
                          child: FilterChip(
                            label: Text(type.toLocalisedString(context)),
                            onSelected: (_) {
                                FinampSetters.setGenreCuratedItemSelectionType(type);
                            },
                            selected: isSelected,
                            showCheckmark: false,
                            selectedColor: colorScheme.primary,
                            backgroundColor: colorScheme.surface,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                            ),
                            shape: StadiumBorder(),
                          ),
                        ),
                      ];
                    }).toList(),
                  ),
                ),
              ),
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