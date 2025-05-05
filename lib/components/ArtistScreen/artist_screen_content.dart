import 'dart:async';

import 'package:finamp/components/ArtistScreen/artist_screen_sections.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/l10n/app_localizations.dart';
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
import '../favourite_button.dart';
import '../padded_custom_scrollview.dart';
import 'artist_screen_content_flexible_space_bar.dart';

part 'artist_screen_content.g.dart';

// Get the Top Tracks of an artist
@riverpod
Future<List<BaseItemDto>> getArtistTopTracks(
  Ref ref,
  BaseItemDto parent,
  BaseItemDto? genreFilter,
) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
  // Get Items
  if (isOffline) {
    // In Offline Mode:
    // As the offline PlayCount might not be accurate, we currently
    // just hide the section. Therefore we return an empty list
    return <BaseItemDto>[];
    // However, if we want to implement it later, it could look like this:
    // We already fetch all tracks for the playback, 
    // and as in offline mode this is much faster, 
    // we just sort them and only return the first 5 items.
    /*final List<BaseItemDto> allArtistTracks = await ref.watch(
      getAllTracksProvider(parent, genreFilter).future,
    );
    var items = sortItems(allArtistTracks, SortBy.playCount, SortOrder.descending);
    items = items.take(5).toList();
    return items;*/
  } else {
    // In Online Mode:
    // Get Top 5 Tracks sorted by Play Count
      final List<BaseItemDto>? topTracks = 
        (ref.watch(finampSettingsProvider.showArtistsTopTracks))
        ? await jellyfinApiHelper.getItems(
            parentItem: parent,
            genreFilter: genreFilter,
            sortBy: "PlayCount,SortName",
            sortOrder: "Descending",
            limit: 5,
            includeItemTypes: "Audio",
          )
        : [];
    return topTracks?? [];
  }
}

// Get Albums where the artist is an album artist
@riverpod
Future<List<BaseItemDto>> getArtistAlbums(
  Ref ref,
  BaseItemDto parent,
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
          baseTypeFilter: BaseItemDtoType.album,
          relatedTo: parent,
          artistType: ArtistType.albumartist,
          genreFilter: genreFilter);
    fetchArtistAlbums.sort((a, b) => (a.baseItem?.premiereDate ?? "")
        .compareTo(b.baseItem!.premiereDate ?? ""));
    final List<BaseItemDto> artistAlbums = fetchArtistAlbums.map((e) => e.baseItem).nonNulls.toList();
    return artistAlbums;
  } else {
    // In Online Mode:
    // Get Albums where artist is Album Artist sorted by Premiere Date
    final List<BaseItemDto>? artistAlbums = 
      await jellyfinApiHelper.getItems(
          parentItem: parent,
          genreFilter: genreFilter,
          sortBy: "PremiereDate,SortName",
          includeItemTypes: "MusicAlbum",
          artistType: ArtistType.albumartist);
    return artistAlbums?? [];
  }
}

// Get Albums with tracks in it on which the artist is a performing artist
// (note that this also might include albums where the artist is album artist as well,
// so we have to filter this list later for the appears on section to exclude those)
@riverpod
Future<List<BaseItemDto>> getPerformingArtistAlbums(
  Ref ref,
  BaseItemDto parent,
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
          baseTypeFilter: BaseItemDtoType.album,
          relatedTo: parent,
          artistType: ArtistType.artist,
          genreFilter: genreFilter);
    fetchPerformingArtistAlbums.sort((a, b) => (a.baseItem?.premiereDate ?? "")
        .compareTo(b.baseItem!.premiereDate ?? ""));
    final List<BaseItemDto> performingArtistAlbums = fetchPerformingArtistAlbums.map((e) => e.baseItem).nonNulls.toList();
    return performingArtistAlbums;
  } else {
    // In Online Mode:
    // Get Albums where artist is Performing Artist sorted by Premiere Date
    final List<BaseItemDto>? performingArtistAlbums = 
      await jellyfinApiHelper.getItems(
        parentItem: parent,
        genreFilter: genreFilter,
        sortBy: "PremiereDate,SortName",
        includeItemTypes: "MusicAlbum",
        artistType: ArtistType.artist,
      );
    return performingArtistAlbums?? [];
  }
}

// Fetch every performing artist track 
// (note that this intentionally also includes tracks
// where the artist is also an album artist)
@riverpod
Future<List<BaseItemDto>> getPerformingArtistTracks(
  Ref ref,
  BaseItemDto parent,
  BaseItemDto? genreFilter,
) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final bool isOffline = ref.watch(finampSettingsProvider.isOffline);

  // Get Items
  if (isOffline) {
    // In Offline Mode:
    final List<BaseItemDto> performingArtistTracks = [];
    // Fetch every album where the artist is a performing artist
    final List<BaseItemDto> allPerformingArtistAlbums = await ref.watch(
      getPerformingArtistAlbumsProvider(parent, genreFilter).future,
    );
    // Loop through the albums and add the tracks
    for (var album in allPerformingArtistAlbums) {
      final performingArtistAlbumTracks = await downloadsService.getCollectionTracks(
        album, playable: true,
      );
      // Now we remove every track where the artist is NOT an performing artist...
      final filteredPerformingArtistTracks = performingArtistAlbumTracks.where((track) {
        return track.artistItems?.any((artist) => artist.id == parent.id) ?? false;
      });
      // and add the tracks to the list
      performingArtistTracks.addAll(filteredPerformingArtistTracks);
    }
    return performingArtistTracks;
  } else {
    // In Online Mode:
    final List<BaseItemDto>? allPerformingArtistTracks = 
      await jellyfinApiHelper.getItems(
        parentItem: parent,
        genreFilter: genreFilter,
        sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
        includeItemTypes: "Audio",
        artistType: ArtistType.artist,
      );
    return allPerformingArtistTracks ?? [];
  }
}

// Get all Tracks for playback
@riverpod
Future<List<BaseItemDto>> getAllTracks(
  Ref ref,
  BaseItemDto parent,
  BaseItemDto? genreFilter,
) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final isOffline = ref.watch(finampSettingsProvider.isOffline);
  // Get Items
  if (isOffline) {
    // In Offline Mode:
    // First fetch every album of the album artist
    final List<BaseItemDto> allAlbumArtistAlbums = await ref.watch(
      getArtistAlbumsProvider(parent, genreFilter).future,
    );
    // Then add the tracks of every album
    final List<BaseItemDto> sortedTracks = [];
    for (var album in allAlbumArtistAlbums) {
      sortedTracks.addAll(await downloadsService.getCollectionTracks(
        album,
        playable: true,
      ));
    }
    // Fetch every performing artist track
    final List<BaseItemDto> allPerformingArtistTracks = await ref.watch(
      getPerformingArtistTracksProvider(parent, genreFilter).future,
    );
    // Filter out the tracks already added through album artist albums
    final existingIds = sortedTracks.map((t) => t.id).toSet();
    final List<BaseItemDto> allPerformingArtistTracksFiltered = allPerformingArtistTracks
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
      parentItem: parent,
      genreFilter: genreFilter,
      sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
      includeItemTypes: "Audio",
      artistType: ArtistType.albumartist,
    );
    // Get all performing artist tracks
    final List<BaseItemDto> allPerformingArtistTracks = await ref.watch(
      getPerformingArtistTracksProvider(parent, genreFilter).future,
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

class ArtistScreenContent extends ConsumerStatefulWidget {
  const ArtistScreenContent({
    super.key,
    required this.parent,
    this.genreFilter,
    required this.resetGenreFilter,
  });

  final BaseItemDto parent;
  final BaseItemDto? genreFilter;
  final VoidCallback resetGenreFilter;

  @override
  ConsumerState<ArtistScreenContent> createState() =>
      _ArtistScreenContentState();
}

class _ArtistScreenContentState extends ConsumerState<ArtistScreenContent> {
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsService = GetIt.instance<DownloadsService>();

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

  @override
  Widget build(BuildContext context) {
    List<BaseItemDto> allChildren = [];

    final topTracksAsync = ref.watch(
        getArtistTopTracksProvider(widget.parent, widget.genreFilter));
    final albumArtistAlbumsAsync = ref.watch(
        getArtistAlbumsProvider(widget.parent, widget.genreFilter));
    final performingArtistAlbumsAsync = ref.watch(
        getPerformingArtistAlbumsProvider(widget.parent, widget.genreFilter));
    final allPerformingArtistTracksAsync = ref.watch(
        getPerformingArtistTracksProvider(widget.parent, widget.genreFilter));
        final allTracks = ref.watch(
        getAllTracksProvider(widget.parent, widget.genreFilter).future,
      );

    final isLoading = [
      topTracksAsync,
      albumArtistAlbumsAsync,
      performingArtistAlbumsAsync,
    ].any((e) => e.isLoading || e.hasError);

    final topTracks = topTracksAsync.valueOrNull ?? [];
    final albumArtistAlbums = albumArtistAlbumsAsync.valueOrNull ?? [];
    final performingArtistAlbums = performingArtistAlbumsAsync.valueOrNull ?? [];
    final allPerformingArtistTracks = allPerformingArtistTracksAsync.valueOrNull ?? [];

    var appearsOnAlbums = performingArtistAlbums
        .where((a) => !albumArtistAlbums.any((b) => b.id == a.id))
        .toList();
    var filteredTopTracks = topTracks
        .takeWhile((s) => (s.userData?.playCount ?? 0) > 0)
        .take(5)
        .toList();

    // Combine Children to get correct ChildrenCount
    // for the Download Status Sync Display for Artists
    allChildren = [...albumArtistAlbums, ...allPerformingArtistTracks];

    return PaddedCustomScrollview(slivers: <Widget>[
      SliverAppBar(
        title: Text(widget.parent.name ??
            AppLocalizations.of(context)!.unknownName),
        // 125 + 116 is the total height of the widget we use as a
        // FlexibleSpaceBar. We add the toolbar height since the widget
        // should appear below the appbar.
        expandedHeight: kToolbarHeight + 125 + 96,
        pinned: true,
        flexibleSpace: ArtistScreenContentFlexibleSpaceBar(
          parentItem: widget.parent,
          isGenre: false,
          allTracks: allTracks,
          albumCount: albumArtistAlbums.length,
          genreFilter: widget.genreFilter,
          resetGenreFilter: widget.resetGenreFilter,
        ),
        actions: [
          FavoriteButton(item: widget.parent),
          if (!isLoading && widget.genreFilter == null)
            DownloadButton(
                item: DownloadStub.fromItem(
                    item: widget.parent,
                    type: DownloadItemType.collection),
                children: allChildren
            )
        ],
      ),
      if (!isLoading &&
          filteredTopTracks.isNotEmpty &&
          ref.watch(finampSettingsProvider.showArtistsTopTracks))
        TracksSection(
            parent: widget.parent,
            tracks: filteredTopTracks,
            childrenForQueue: Future.value(filteredTopTracks),
            tracksText: AppLocalizations.of(context)!.topTracks),
      if (!isLoading && albumArtistAlbums.isNotEmpty)
        AlbumSection(
            parent: widget.parent,
            albumsText: AppLocalizations.of(context)!.albums,
            albums: albumArtistAlbums),
      if (!isLoading && appearsOnAlbums.isNotEmpty)
        AlbumSection(
            parent: widget.parent,
            albumsText: AppLocalizations.of(context)!.appearsOnAlbums,
            albums: appearsOnAlbums),
      if (!isLoading && (albumArtistAlbums.isEmpty && appearsOnAlbums.isEmpty))
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(6, 12, 6,
              0),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 2, vertical: 12),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.emptyFilteredListTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
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