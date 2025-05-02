import 'dart:async';

import 'package:collection/collection.dart';
import 'package:finamp/components/ArtistScreen/artist_screen_sections.dart';
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

@riverpod
Future<(List<BaseItemDto>, List<BaseItemDto>, List<BaseItemDto>, List<BaseItemDto>)> getArtistItems(
  Ref ref,
  BaseItemDto parent,
  BaseItemDto? genreFilter,
) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final bool isOffline = ref.watch(finampSettingsProvider.isOffline);

  // Get Items
  if (isOffline) {
    // In Offline Mode
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
    return (<BaseItemDto>[], artistAlbums, performingArtistAlbums, <BaseItemDto>[]);
  } else {
    // In Online Mode
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
      // Get Albums where artist is Album Artist sorted by Premiere Date
      final List<BaseItemDto>? artistAlbums = 
        await jellyfinApiHelper.getItems(
          parentItem: parent,
          genreFilter: genreFilter,
          sortBy: "PremiereDate,SortName",
          includeItemTypes: "MusicAlbum",
          artistType: ArtistType.albumartist);
      // Get Albums where artist is Performing Artist sorted by Premiere Date
      final List<BaseItemDto>? performingArtistAlbums = 
        await jellyfinApiHelper.getItems(
          parentItem: parent,
          genreFilter: genreFilter,
          sortBy: "PremiereDate,SortName",
          includeItemTypes: "MusicAlbum",
          artistType: ArtistType.artist,
        );
      // Now we fetch every performing artist track
      // (this has to happen here, because otherwise we will
      // get the correct childrenCount for the Download Status too late)
      final List<BaseItemDto>? allPerformingArtistTracks = 
        await jellyfinApiHelper.getItems(
          parentItem: parent,
          genreFilter: genreFilter,
          sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
          includeItemTypes: "Audio",
          artistType: ArtistType.artist,
        );
    return (topTracks?? [], artistAlbums?? [], performingArtistAlbums?? [], allPerformingArtistTracks ?? []);
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

  if (isOffline) {
    // First fetch every album of the album artist
    final List<DownloadStub> albumArtistAlbums =
        await downloadsService.getAllCollections(
          baseTypeFilter: BaseItemDtoType.album,
          relatedTo: parent,
          artistType: ArtistType.albumartist,
          genreFilter: genreFilter,
        );
    albumArtistAlbums.sort((a, b) => a.name.compareTo(b.name));
    // Then add the tracks of every album
    final List<BaseItemDto> sortedTracks = [];
    for (var album in albumArtistAlbums) {
      sortedTracks.addAll(await downloadsService.getCollectionTracks(
        album.baseItem!,
        playable: true,
      ));
    }
    // Fetch every album where the artist is a performing artist
    final List<DownloadStub> performingArtistAlbums =
        await downloadsService.getAllCollections(
          baseTypeFilter: BaseItemDtoType.album,
          relatedTo: parent,
          artistType: ArtistType.artist,
          genreFilter: genreFilter,
        );
    performingArtistAlbums.sort((a, b) => a.name.compareTo(b.name));
    // Filter out albums already fetched in the albumArtistAlbums query
    final List<DownloadStub> filteredPerformingArtistAlbums =
        performingArtistAlbums.where((performingAlbum) {
      return !albumArtistAlbums.any((albumArtistAlbum) =>
          albumArtistAlbum.id == performingAlbum.id);
    }).toList();
    // Again add the tracks of every album,
    // but this time only the tracks where the artist is a performing artist
    final List<BaseItemDto> sortedTracksIncludingAppearsOn = [];
    for (var album in filteredPerformingArtistAlbums) {
      final performingArtistAlbumTracks = await downloadsService.getCollectionTracks(
        album.baseItem!, playable: true,
      );
      final filteredPerformingArtistTracks = performingArtistAlbumTracks.where((track) {
        return track.artistItems?.any((artist) => artist.id == parent.id) ?? false;
      });
      sortedTracks.addAll(filteredPerformingArtistTracks);
    }
    // Combine the results and return
    final combinedTracks = [
      ...sortedTracks,
      ...sortedTracksIncludingAppearsOn
    ];
    return combinedTracks;
  } else {
    // Online Mode
    // Get all performing artist tracks from other provider
    final artistItemsTuple = await ref.watch(
      getArtistItemsProvider(parent, genreFilter).future,
    );
    final List<BaseItemDto> allPerformingArtistTracks = artistItemsTuple.$4;
    // Fetch every album artist track
    final allAlbumArtistTracksResponse = await jellyfinApiHelper.getItems(
      parentItem: parent,
      genreFilter: genreFilter,
      sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
      includeItemTypes: "Audio",
      artistType: ArtistType.albumartist,
    );
    // We now remove albumartist tracks from performance artist tracks to avoid duplicates
    final allAlbumArtistTracks = allAlbumArtistTracksResponse ?? [];
    final allPerformingTracks = allPerformingArtistTracks ?? [];
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
    final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
    List<BaseItemDto> allChildren = [];

    final artistItems = ref.watch(
        getArtistItemsProvider(widget.parent, widget.genreFilter),
      ).valueOrNull;
    final allTracks = ref.watch(
        getAllTracksProvider(widget.parent, widget.genreFilter).future,
      );

    final isLoading = artistItems == null;
    final topTracks = artistItems?.$1 ?? [];
    final albumArtistAlbums = artistItems?.$2 ?? [];
    final performingArtistAlbums = artistItems?.$3 ?? [];
    final allPerformingArtistTracks = artistItems?.$4 ?? [];

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
          !isOffline &&
          topTracks.isNotEmpty &&
          ref.watch(finampSettingsProvider.showArtistsTopTracks))
        TracksSection(
            parent: widget.parent,
            tracks: filteredTopTracks,
            childrenForQueue: Future.value(filteredTopTracks),
            tracksText: AppLocalizations.of(context)!.topTracks),
      if (albumArtistAlbums.isNotEmpty)
        AlbumSection(
            parent: widget.parent,
            albumsText: AppLocalizations.of(context)!.albums,
            albums: albumArtistAlbums),
      if (appearsOnAlbums.isNotEmpty)
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