import 'dart:async';

import 'package:finamp/services/genre_screen_provider.dart';
import 'package:finamp/components/curated_item_sections.dart';
import 'package:finamp/components/GenreScreen/genre_count_column.dart';
import 'package:finamp/components/favourite_button.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/download_button.dart';
import '../padded_custom_scrollview.dart';

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
  final Set<CuratedItemSelectionType> _disabledTrackFilters = {};
  final Set<CuratedItemSelectionType> _disabledAlbumFilters = {};
  final Set<CuratedItemSelectionType> _disabledArtistFilters = {};

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
    CuratedItemSelectionType? itemSelectionType,
  }) {
    bool isFavoriteOverride = false;
    SortBy? sortByOverride;
    SortOrder? sortOrderOverride;
   
    if (doOverride && ref.read(finampSettingsProvider.genreListsInheritSorting) && itemSelectionType != null) {
      switch (itemSelectionType) {
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
    final loc = AppLocalizations.of(context)!;
    final genreCuratedItemSectionFilterOrder = ref.watch(finampSettingsProvider.genreItemSectionFilterChipOrder);
    final genreItemSectionsOrder =
        ref.watch(finampSettingsProvider.genreItemSectionsOrder);

    final tracksAsync = ref.watch(genreCuratedItemsProvider(widget.parent, BaseItemDtoType.track, widget.library));
    final albumsAsync = ref.watch(genreCuratedItemsProvider(widget.parent, BaseItemDtoType.album, widget.library));
    final artistsAsync = ref.watch(genreCuratedItemsProvider(widget.parent, BaseItemDtoType.artist, widget.library));

    final (tracks, trackCount, genreCuratedItemSelectionTypeTracks, newDisabledTrackFilters) = tracksAsync.valueOrNull ?? (null, null, null, null);
    final (albums, albumCount, genreCuratedItemSelectionTypeAlbums, newDisabledAlbumFilters) = albumsAsync.valueOrNull ?? (null, null, null, null);
    final (artists, artistCount, genreCuratedItemSelectionTypeArtists, newDisabledArtistFilters) = artistsAsync.valueOrNull ?? (null, null, null, null);

    final isLoading = tracks == null || albums == null || artists == null;

    if (newDisabledTrackFilters != null) {
      _disabledTrackFilters.addAll(newDisabledTrackFilters.whereType<CuratedItemSelectionType>());
    }
    if (newDisabledAlbumFilters != null) {
      _disabledAlbumFilters.addAll(newDisabledAlbumFilters.whereType<CuratedItemSelectionType>());
    }
    if (newDisabledArtistFilters != null) {
      _disabledArtistFilters.addAll(newDisabledArtistFilters.whereType<CuratedItemSelectionType>());
    }
    
    final countsTextColor = IconTheme.of(context).color;
    final countsSubtitleColor = IconTheme.of(context).color!.withOpacity(0.6);
    final countsBorderColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.2);
    final countsBackgroundColor = Theme.of(context).colorScheme.surface;

    return PaddedCustomScrollview(slivers: <Widget>[
      SliverAppBar(
        title: Text(widget.parent.name ??
            AppLocalizations.of(context)!.unknownName),
        pinned: true,
        centerTitle: false,
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
                  tracksText: (genreCuratedItemSelectionTypeTracks != null) 
                      ? genreCuratedItemSelectionTypeTracks
                          .toLocalisedSectionTitle(context, BaseItemDtoType.track)
                      : loc.tracks,
                  seeAllCallbackFunction: () => openSeeAll(
                    TabContentType.tracks,
                    itemSelectionType: genreCuratedItemSelectionTypeTracks,
                  ),
                  includeFilterRow: true,
                  customFilterOrder: genreCuratedItemSectionFilterOrder,
                  selectedFilter: genreCuratedItemSelectionTypeTracks,
                  disabledFilters: _disabledTrackFilters.toList(),
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
                  albumsText: (genreCuratedItemSelectionTypeAlbums != null) 
                      ? genreCuratedItemSelectionTypeAlbums
                          .toLocalisedSectionTitle(context, BaseItemDtoType.album)
                      : loc.albums,
                  albums: albums,
                  seeAllCallbackFunction: () => openSeeAll(
                    TabContentType.albums, 
                    itemSelectionType: genreCuratedItemSelectionTypeAlbums,
                  ),
                  includeFilterRowFor: BaseItemDtoType.album,
                  customFilterOrder: genreCuratedItemSectionFilterOrder,
                  selectedFilter: genreCuratedItemSelectionTypeAlbums,
                  disabledFilters: _disabledAlbumFilters.toList(),
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
                  albumsText:  (genreCuratedItemSelectionTypeArtists != null) 
                      ? genreCuratedItemSelectionTypeArtists
                          .toLocalisedSectionTitle(context, BaseItemDtoType.artist)
                      : loc.artists,
                  albums: artists,
                  seeAllCallbackFunction: () => openSeeAll(
                    TabContentType.artists,
                    itemSelectionType: genreCuratedItemSelectionTypeArtists,
                  ),
                  genreFilter: widget.parent,
                  includeFilterRowFor: BaseItemDtoType.artist,
                  customFilterOrder: genreCuratedItemSectionFilterOrder,
                  selectedFilter: genreCuratedItemSelectionTypeArtists,
                  disabledFilters: _disabledArtistFilters.toList(),
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