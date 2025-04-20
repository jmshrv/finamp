import 'dart:async';

import 'package:collection/collection.dart';
import 'package:finamp/components/ArtistScreen/artist_screen_sections.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/download_button.dart';
import '../favourite_button.dart';
import '../padded_custom_scrollview.dart';
import 'artist_screen_content_flexible_space_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final Future<List<List<BaseItemDto>?>> futures;
    final Future<List<BaseItemDto>?> allTracks;
    final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
    List<BaseItemDto> allChildren = [];

    // Get Items
    if (isOffline) {
      // In Offline Mode
      futures = Future.wait([
        Future.value(
            <BaseItemDto>[]), // Play count tracking is not implemented offline
        // Get Albums for Genre or where artist is Album Artist sorted by Premiere Date
        Future.sync(() async {
          final List<DownloadStub> artistAlbums =
              await _downloadsService.getAllCollections(
                  baseTypeFilter: BaseItemDtoType.album,
                  relatedTo: widget.parent,
                  artistType: ArtistType.albumartist,
                  genreFilter: widget.genreFilter);
          artistAlbums.sort((a, b) => (a.baseItem?.premiereDate ?? "")
              .compareTo(b.baseItem!.premiereDate ?? ""));
          return artistAlbums.map((e) => e.baseItem).nonNulls.toList();
        }),
        // Get Albums where artist is Performing Artist sorted by Premiere Date
        Future.sync(() async {
          final List<DownloadStub> artistAlbums =
              await _downloadsService.getAllCollections(
                  baseTypeFilter: BaseItemDtoType.album,
                  relatedTo: widget.parent,
                  artistType: ArtistType.artist,
                  genreFilter: widget.genreFilter);
          artistAlbums.sort((a, b) => (a.baseItem?.premiereDate ?? "")
              .compareTo(b.baseItem!.premiereDate ?? ""));
          return artistAlbums.map((e) => e.baseItem).nonNulls.toList();
        })
      ]);

      // Get All Tracks for Track Count and Playback
      allTracks = Future.sync(() async {
        // First fetch every album of the album artist or genre
        final List<DownloadStub> albumArtistAlbums =
            await _downloadsService.getAllCollections(
                baseTypeFilter: BaseItemDtoType.album,
                relatedTo: widget.parent,
                artistType: ArtistType.albumartist,
                genreFilter: widget.genreFilter);
        albumArtistAlbums.sort((a, b) => (a.name).compareTo(b.name));
        // Then add the tracks of every album
        final List<BaseItemDto> sortedTracks = [];
        for (var album in albumArtistAlbums) {
          sortedTracks.addAll(await _downloadsService
              .getCollectionTracks(album.baseItem!, playable: true));
        }
        // Fetch every album where the artist is a performing artist
        final List<DownloadStub> performingArtistAlbums =
            await _downloadsService.getAllCollections(
                baseTypeFilter: BaseItemDtoType.album,
                relatedTo: widget.parent,
                artistType: ArtistType.artist,
                genreFilter: widget.genreFilter);
        performingArtistAlbums.sort((a, b) => (a.name).compareTo(b.name));
        // Filter out albums already fetched in the first query
        final List<DownloadStub> filteredPerformingArtistAlbums =
            performingArtistAlbums.where((performingAlbum) {
          return !albumArtistAlbums.any(
              (albumArtistAlbum) => albumArtistAlbum.id == performingAlbum.id);
        }).toList();
        // Again add the tracks of every album,
        // but this time only the tracks where the artist is a performing artist
        final List<BaseItemDto> sortedTracksIncludingAppearsOn = [];
        for (var album in filteredPerformingArtistAlbums) {
          final performingArtistAlbumTracks = await _downloadsService.getCollectionTracks(
            album.baseItem!, playable: true,
          );
          final filteredPerformingArtistTracks = performingArtistAlbumTracks.where((track) {
            return track.artistItems?.any((artist) => artist.id == widget.parent.id) ?? false;
          });
          sortedTracks.addAll(filteredPerformingArtistTracks);
        }
        // Combine the results and return
        final combinedTracks = [
          ...sortedTracks,
          ...sortedTracksIncludingAppearsOn
        ];
        return combinedTracks;
      });
    } else {
      // In Online Mode
      futures = Future.wait([
        // Get Tracks sorted by Play Count
        if (ref.watch(finampSettingsProvider.showArtistsTopTracks))
          jellyfinApiHelper.getItems(
            parentItem: widget.parent,
            genreFilter: widget.genreFilter,
            sortBy: "PlayCount,SortName",
            sortOrder: "Descending",
            limit: 5,
            includeItemTypes: "Audio",
          )
        else
          Future.value(null),
        // Get Albums where artist is Album Artist sorted by Premiere Date
        jellyfinApiHelper.getItems(
            parentItem: widget.parent,
            genreFilter: widget.genreFilter,
            sortBy: "PremiereDate,SortName",
            includeItemTypes: "MusicAlbum",
            artistType: ArtistType.albumartist),
        // Get Albums where artist is Performing Artist sorted by Premiere Date
        jellyfinApiHelper.getItems(
            parentItem: widget.parent,
            genreFilter: widget.genreFilter,
            sortBy: "PremiereDate,SortName",
            includeItemTypes: "MusicAlbum",
            artistType: ArtistType.artist),
        // Now we fetch every performing artist track
        // (this has to happen in Future.wait, because otherwise we will
        // get the correct childrenCount for the Download Status too late)
        jellyfinApiHelper.getItems(
          parentItem: widget.parent,
          genreFilter: widget.genreFilter,
          sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
          includeItemTypes: "Audio",
          artistType: ArtistType.artist,
        )
      ]);

      // Get All Tracks for Track Count and Playback
      allTracks = Future.sync(() async {
        final previousResults = await futures;
        final allPerformingTracksResponse = previousResults[3];

        // Fetch every genre or album artist track
        final allAlbumArtistTracksResponse = await jellyfinApiHelper.getItems(
          parentItem: widget.parent,
          genreFilter: widget.genreFilter,
          sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
          includeItemTypes: "Audio",
          artistType: ArtistType.albumartist,
        );

        // We exclude albumartist tracks from performance artist tracks
        final allAlbumArtistTracks = allAlbumArtistTracksResponse ?? [];
        final allPerformingTracks = allPerformingTracksResponse ?? [];
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
      });
    }

    return FutureBuilder(
        future: futures,
        builder: (context, snapshot) {
          _isLoading = (snapshot.connectionState == ConnectionState.waiting);
          var tracks = snapshot.data?.elementAtOrNull(0) ?? [];
          var albums = snapshot.data?.elementAtOrNull(1) ?? [];
          var albumsAsPerformingArtist =
              snapshot.data?.elementAtOrNull(2) ?? [];
          var allPerformingArtistTracks =
              snapshot.data?.elementAtOrNull(3) ?? [];

          var appearsOnAlbums = albumsAsPerformingArtist
              .where((a) => !albums.any((b) => b.id == a.id))
              .toList();
          var topTracks = tracks
              .takeWhile((s) => (s.userData?.playCount ?? 0) > 0)
              .take(5)
              .toList();

          // Combine Children to get correct ChildrenCount
          // for the Download Status Sync Display for Artists
          allChildren = [...albums, ...allPerformingArtistTracks];

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
                albumCount: albums.length,
                genreFilter: widget.genreFilter,
                resetGenreFilter: widget.resetGenreFilter,
              ),
              actions: [
                FavoriteButton(item: widget.parent),
                if (!_isLoading && widget.genreFilter == null)
                  DownloadButton(
                      item: DownloadStub.fromItem(
                          item: widget.parent,
                          type: DownloadItemType.collection),
                      children: allChildren
                  )
              ],
            ),
            if (!_isLoading &&
                !isOffline &&
                topTracks.isNotEmpty &&
                ref.watch(finampSettingsProvider.showArtistsTopTracks))
              TracksSection(
                  parent: widget.parent,
                  tracks: topTracks,
                  childrenForQueue: Future.value(tracks),
                  tracksText: AppLocalizations.of(context)!.topTracks),
            if (albums.isNotEmpty)
              AlbumSection(
                  parent: widget.parent,
                  albumsText: AppLocalizations.of(context)!.albums,
                  albums: albums),
            if (appearsOnAlbums.isNotEmpty)
              AlbumSection(
                  parent: widget.parent,
                  albumsText: AppLocalizations.of(context)!.appearsOnAlbums,
                  albums: appearsOnAlbums),
            if (!_isLoading && (albums.isEmpty && appearsOnAlbums.isEmpty))
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