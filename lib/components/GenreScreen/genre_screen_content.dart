import 'dart:async';

import 'package:finamp/components/curated_item_sections.dart';
import 'package:finamp/components/GenreScreen/genre_count_column.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/favourite_button.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/download_button.dart';
import '../padded_custom_scrollview.dart';

part 'genre_screen_content.g.dart';

@riverpod
Future<(List<BaseItemDto>, int)> genreCuratedItems(
  Ref ref,
  BaseItemDto parent,
  BaseItemDtoType baseItemType,
  BaseItemDto? library,
) async {
  final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
  final genreCuratedItemSelectionType = (baseItemType == BaseItemDtoType.artist)
      ? ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeArtists)
      : (baseItemType == BaseItemDtoType.album)
          ? ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeAlbums)
          : ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeTracks);
  final artistListType = ref.watch(finampSettingsProvider.artistListType);
  final artistInfoForType = (artistListType == ArtistType.albumartist)
        ? BaseItemDtoType.album
        : BaseItemDtoType.track;

  List<BaseItemDto>? items;
  int? itemCount;

  if (isOffline) {
    // If "Most Played" is selected when Offline Mode is enabled, we switch to a fallback option
    // as the PlayCount data might not be an accurate representation of the online state
    final offlineSelectionType = (genreCuratedItemSelectionType == CuratedItemSelectionType.mostPlayed)
        ? CuratedItemSelectionType.favorites//ref.watch(finampSettingsProvider.genreMostPlayedOfflineFallback)
        : genreCuratedItemSelectionType;
    final result = await getCuratedItemsOffline(
      ref: ref,
      parent: parent,
      genreCuratedItemSelectionType: offlineSelectionType,
      baseItemType: baseItemType,
      library: library,
      artistInfoForType: (baseItemType == BaseItemDtoType.artist)
          ? artistInfoForType
          : null,
    );
    items = result.$1;
    itemCount = result.$2;
  } else {
    final result = await getCuratedItemsOnline(
      parent: parent,
      genreCuratedItemSelectionType: genreCuratedItemSelectionType,
      baseItemType: baseItemType,
      library: library,
      sortBySecondary: (baseItemType == BaseItemDtoType.album)
          ? "PremiereDate,SortName"
          : "SortName",
      artistListType: (baseItemType == BaseItemDtoType.artist)
          ? artistListType
          : null,
    );
    items = result.$1;
    itemCount = result.$2;
  }
  return (items, itemCount);
}

Future<(List<BaseItemDto>,int)> getCuratedItemsOnline({
  required BaseItemDto parent,
  required CuratedItemSelectionType genreCuratedItemSelectionType,
  required BaseItemDtoType baseItemType,
  BaseItemDto? library,
  String? sortBySecondary,
  ArtistType? artistListType,
}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final sortByMain = switch (genreCuratedItemSelectionType) {
    CuratedItemSelectionType.mostPlayed => "PlayCount",
    CuratedItemSelectionType.recentlyAdded => "DateCreated",
    CuratedItemSelectionType.latestReleases => "PremiereDate",
    _ => "Random", // for Favorites and Random
  };
  final sortBy = 
    [sortByMain, if (sortBySecondary != null && sortBySecondary.isNotEmpty) sortBySecondary]
    .join(',');
  int itemCount;
    
  final fetchedItems = await jellyfinApiHelper.getItemsWithTotalRecordCount(
    parentItem: library,
    genreFilter: parent, 
    sortBy: sortBy,
    sortOrder: "Descending",
    isFavorite: (genreCuratedItemSelectionType == CuratedItemSelectionType.favorites) 
        ? true : null,
    limit: 5,
    includeItemTypes: baseItemType.idString,
    artistType: (baseItemType == BaseItemDtoType.artist)
        ? artistListType : null,
  );
  // Set the Item Count
  if (genreCuratedItemSelectionType == CuratedItemSelectionType.favorites) {
    // When we filter the favorites, we have to make an additional request to get the correct number
    // otherwise we would only get the totalRecordCount of Favorites of that genre
    final fetchedItemCountWithoutFavorites = await jellyfinApiHelper.getItemsWithTotalRecordCount(
      parentItem: library,
      genreFilter: parent,
      limit: 1,
      includeItemTypes: baseItemType.idString,
      artistType: (baseItemType == BaseItemDtoType.artist)
          ? artistListType : null,
    );
    itemCount = fetchedItemCountWithoutFavorites.totalRecordCount;
  } else {
    itemCount = fetchedItems.totalRecordCount;
  }
  return (fetchedItems.items ?? [], itemCount);
}

Future<(List<BaseItemDto>,int)> getCuratedItemsOffline({
  required Ref ref,
  required BaseItemDto parent,
  required CuratedItemSelectionType genreCuratedItemSelectionType,
  required BaseItemDtoType baseItemType,
  BaseItemDto? library,
  BaseItemDtoType? artistInfoForType,
}) async {
  // The "Most Played" functionality is still here, just in case we find a solution on
  // how we can integrate it properly. But as in the current implementation it might return
  // outdated data, getCuratedItemsOffline currently never gets called with mostPlayed
  final downloadsService = GetIt.instance<DownloadsService>();
  final sortBy = switch (genreCuratedItemSelectionType) {
    CuratedItemSelectionType.mostPlayed => SortBy.playCount,
    CuratedItemSelectionType.recentlyAdded => SortBy.dateCreated,
    CuratedItemSelectionType.latestReleases => SortBy.premiereDate,
    _ => SortBy.random, // for Favorites and Random
  };

  final listener = GetIt.instance<DownloadsService>()
        .offlineDeletesStream
        .listen((_) => ref.invalidateSelf());
  ref.onDispose(() => listener.cancel());

  final List<DownloadStub> fetchedItems = (baseItemType == BaseItemDtoType.track)
    ? await downloadsService.getAllTracks(
          viewFilter: library?.id,
          nullableViewFilters: ref.watch(finampSettingsProvider.showDownloadsWithUnknownLibrary),
          onlyFavorites: (genreCuratedItemSelectionType == CuratedItemSelectionType.favorites) 
            ? ref.watch(finampSettingsProvider.trackOfflineFavorites) : false,
          genreFilter: parent)
    : await downloadsService.getAllCollections(
          baseTypeFilter: baseItemType,
          fullyDownloaded: ref.watch(finampSettingsProvider.onlyShowFullyDownloaded),
          viewFilter: (baseItemType == BaseItemDtoType.album)
              ? library?.id
              : null,
          childViewFilter: (baseItemType != BaseItemDtoType.album &&
                  baseItemType != BaseItemDtoType.playlist)
              ? library?.id
              : null,
          nullableViewFilters: (baseItemType == BaseItemDtoType.album) &&
              ref.watch(finampSettingsProvider.showDownloadsWithUnknownLibrary),
          onlyFavorites: (genreCuratedItemSelectionType == CuratedItemSelectionType.favorites) 
            ? ref.watch(finampSettingsProvider.trackOfflineFavorites) : false,
          infoForType: (baseItemType == BaseItemDtoType.artist)
            ? artistInfoForType : null,
          genreFilter: parent);
  var items = fetchedItems.map((e) => e.baseItem).nonNulls.toList();
  var itemCount = items.length;
  items = sortItems(items, sortBy, SortOrder.descending);
  items = items.take(5).toList();
  // When we filter the favorites, we have to make an additional request to get the correct number
  // otherwise we would only get the count of Favorites of that genre
  if (genreCuratedItemSelectionType == CuratedItemSelectionType.favorites) {
    final List<DownloadStub> allFetchedItems = (baseItemType == BaseItemDtoType.track)
    ? await downloadsService.getAllTracks(
          nullableViewFilters: ref.read(finampSettingsProvider.showDownloadsWithUnknownLibrary),
          genreFilter: parent)
    : await downloadsService.getAllCollections(
          baseTypeFilter: baseItemType,
          fullyDownloaded: ref.read(finampSettingsProvider.onlyShowFullyDownloaded),
          infoForType: (baseItemType == BaseItemDtoType.artist)
            ? artistInfoForType : null,
          genreFilter: parent);
    var allItems = allFetchedItems.map((e) => e.baseItem).nonNulls.toList();
    itemCount = allItems.length;
  }
  return (items, itemCount);
}

class GenreScreenContent extends ConsumerStatefulWidget {
  const GenreScreenContent({
    super.key,
    required this.parent,
    this.library,
  });

  final BaseItemDto parent;
  final BaseItemDto? library;

  @override
  ConsumerState<GenreScreenContent> createState() =>
      _GenreScreenContentState();
}

class _GenreScreenContentState extends ConsumerState<GenreScreenContent> {
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  StreamSubscription<void>? _refreshStream;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _refreshStream?.cancel();
    super.dispose();
  }

void openSeeAll(
    TabContentType tabContentType, {
    bool doOverride = true,
  }) {
    bool isFavoriteOverride = false;
    SortBy? sortByOverride;
    SortOrder? sortOrderOverride;

    final genreCuratedItemSelectionTypeSetting = (tabContentType == TabContentType.artists)
        ? ref.read(finampSettingsProvider.genreCuratedItemSelectionTypeArtists)
        : ((tabContentType == TabContentType.albums)
            ? ref.read(finampSettingsProvider.genreCuratedItemSelectionTypeAlbums)
            : ref.read(finampSettingsProvider.genreCuratedItemSelectionTypeTracks));
    final genreCuratedItemSelectionType = (ref.watch(finampSettingsProvider.isOffline) && 
        genreCuratedItemSelectionTypeSetting == CuratedItemSelectionType.mostPlayed)
          ? CuratedItemSelectionType.favorites//ref.read(finampSettingsProvider.genreMostPlayedOfflineFallback)
          : genreCuratedItemSelectionTypeSetting;

    if (doOverride && ref.read(finampSettingsProvider.genreListsInheritSorting)) {
      switch (genreCuratedItemSelectionType) {
        case CuratedItemSelectionType.mostPlayed:
          sortByOverride = SortBy.playCount;
          sortOrderOverride = SortOrder.descending;
          isFavoriteOverride = false;
        case CuratedItemSelectionType.favorites:
          sortByOverride = SortBy.sortName;
          sortOrderOverride = SortOrder.ascending;
          isFavoriteOverride = true;
        case CuratedItemSelectionType.random:
          sortByOverride = SortBy.random;
          sortOrderOverride = SortOrder.ascending;
          isFavoriteOverride = false;
        case CuratedItemSelectionType.latestReleases:
          sortByOverride = SortBy.premiereDate;
          sortOrderOverride = SortOrder.descending;
          isFavoriteOverride = false;
        case CuratedItemSelectionType.recentlyAdded:
          sortByOverride = SortBy.dateCreated;
          sortOrderOverride = SortOrder.descending;
          isFavoriteOverride = false;
      }
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MusicScreen(
          genreFilter: widget.parent,
          tabTypeFilter: tabContentType,
          sortByOverrideInit: sortByOverride,
          sortOrderOverrideInit: sortOrderOverride,
          isFavoriteOverrideInit: isFavoriteOverride,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    final library = finampUserHelper.currentUser?.currentView;
    final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
    final genreCuratedItemSelectionTypeTracksSetting =
        ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeTracks);
    final genreCuratedItemSelectionTypeTracks = 
        (isOffline && genreCuratedItemSelectionTypeTracksSetting == CuratedItemSelectionType.mostPlayed)
            ? CuratedItemSelectionType.favorites//ref.watch(finampSettingsProvider.genreMostPlayedOfflineFallback)
            : genreCuratedItemSelectionTypeTracksSetting;
    final genreCuratedItemSelectionTypeAlbums =
        ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeAlbums);
    final genreCuratedItemSelectionTypeArtists =
        ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeArtists);
    final genreItemSectionsOrder =
        ref.watch(finampSettingsProvider.genreItemSectionsOrder);
    final genreCuratedItemSectionFilterOrder = ref.watch(finampSettingsProvider.genreItemSectionFilterChipOrder);

    final (tracks, trackCount) = ref.watch(genreCuratedItemsProvider(
        widget.parent, BaseItemDtoType.track, widget.library)).valueOrNull ?? (null, null);
    final (albums, albumCount) = ref.watch(genreCuratedItemsProvider(
        widget.parent, BaseItemDtoType.album, widget.library)).valueOrNull ?? (null, null);
    final (artists, artistCount) = ref.watch(genreCuratedItemsProvider(
        widget.parent, BaseItemDtoType.artist, widget.library)).valueOrNull ?? (null, null);

    final isLoading = tracks == null || albums == null || artists == null;
    
    final countsTextColor = IconTheme.of(context).color;
    final countsSubtitleColor = IconTheme.of(context).color!.withOpacity(0.6);
    final countsBorderColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.2);
    final countsBackgroundColor = Theme.of(context).colorScheme.surface;

    return PaddedCustomScrollview(slivers: <Widget>[
      SliverAppBar(
        title: Text(widget.parent.name ??
            AppLocalizations.of(context)!.unknownName),
        pinned: true,
        actions: [
          FavoriteButton(item: widget.parent),
          if (!isLoading)
            DownloadButton(
                item: DownloadStub.fromFinampCollection(
                  FinampCollection(
                      type: FinampCollectionType.collectionWithLibraryFilter,
                      library: library,
                      item: widget.parent,
                  )
                ),
                childrenCount: albumCount)
        ],
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 8, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: buildCountColumn(
                    count: albumCount,
                    label: AppLocalizations.of(context)!.albums,
                    onTap: () {
                      openSeeAll(TabContentType.albums, doOverride: false);
                    },
                    textColor: countsTextColor,
                    subtitleColor: countsSubtitleColor,
                    borderColor: countsBorderColor,
                    backgroundColor: countsBackgroundColor,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: buildCountColumn(
                    count: trackCount,
                    label: AppLocalizations.of(context)!.tracks,
                    onTap: () {
                      openSeeAll(TabContentType.tracks, doOverride: false);
                    },
                    textColor: countsTextColor,
                    subtitleColor: countsSubtitleColor,
                    borderColor: countsBorderColor,
                    backgroundColor: countsBackgroundColor,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: buildCountColumn(
                    count: artistCount,
                    label: (ref.read(finampSettingsProvider.artistListType) == ArtistType.albumartist)
                        ? AppLocalizations.of(context)!.albumArtists
                        : AppLocalizations.of(context)!.performingArtists,
                    onTap: () {
                      openSeeAll(TabContentType.artists, doOverride: false);
                    },
                    textColor: countsTextColor,
                    subtitleColor: countsSubtitleColor,
                    borderColor: countsBorderColor,
                    backgroundColor: countsBackgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      if (!isLoading)
        ...genreItemSectionsOrder.map((type) {
          switch (type) {
            case GenreItemSections.tracks:
              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 12.0),
                sliver: TracksSection(
                  parent: widget.parent,
                  tracks: tracks,
                  childrenForQueue: Future.value(tracks),
                  tracksText: genreCuratedItemSelectionTypeTracks
                      .toLocalisedSectionTitle(context, BaseItemDtoType.track),
                  seeAllCallbackFunction: () => openSeeAll(TabContentType.tracks),
                  includeFilterRow: true,
                  customFilterOrder: genreCuratedItemSectionFilterOrder,
                  selectedFilter: genreCuratedItemSelectionTypeTracks,
                  onFilterSelected: (type) {
                     FinampSetters.setGenreCuratedItemSelectionTypeTracks(type);
                  },
                ),
              );
            case GenreItemSections.albums:
              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 12.0),
                sliver: AlbumSection(
                  parent: widget.parent,
                  albumsText: genreCuratedItemSelectionTypeAlbums
                      .toLocalisedSectionTitle(context, BaseItemDtoType.album),
                  albums: albums,
                  seeAllCallbackFunction: () => openSeeAll(TabContentType.albums),
                  includeFilterRowFor: BaseItemDtoType.album,
                  customFilterOrder: genreCuratedItemSectionFilterOrder,
                  selectedFilter: genreCuratedItemSelectionTypeAlbums,
                  onFilterSelected: (type) {
                     FinampSetters.setGenreCuratedItemSelectionTypeAlbums(type);
                  },
                ),
              );
            case GenreItemSections.artists:
              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 12.0),
                sliver: AlbumSection(
                  parent: widget.parent,
                  albumsText: genreCuratedItemSelectionTypeArtists
                      .toLocalisedSectionTitle(context, BaseItemDtoType.artist),
                  albums: artists,
                  seeAllCallbackFunction: () => openSeeAll(TabContentType.artists),
                  genreFilter: widget.parent,
                  includeFilterRowFor: BaseItemDtoType.artist,
                  customFilterOrder: genreCuratedItemSectionFilterOrder,
                  selectedFilter: genreCuratedItemSelectionTypeArtists,
                  onFilterSelected: (type) {
                     FinampSetters.setGenreCuratedItemSelectionTypeArtists(type);
                  },
                ),
              );
          }
        }).toList(),
      if (isLoading)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        )
    ]);
  }
}