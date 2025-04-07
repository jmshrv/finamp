import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/album_screen_content.dart';
import '../AlbumScreen/download_button.dart';
import '../albums_sliver_list.dart';
import '../favourite_button.dart';
import '../padded_custom_scrollview.dart';
import 'artist_screen_content_flexible_space_bar.dart';


/// ToDo for proper Albums and Appears On Section + reasonable playback queue: 
/// - Offline: Include both albumartist and performingartist tracks in allTracks but DISTINCT (see downloads_service.dart)
/// - Online: Modify allTracks to include both albumartist and performingartist tracks DISTINCT
class ArtistScreenContent extends StatefulWidget {
  const ArtistScreenContent({super.key, required this.parent});

  final BaseItemDto parent;

  @override
  State<ArtistScreenContent> createState() => _ArtistScreenContentState();
}

class _ArtistScreenContentState extends State<ArtistScreenContent> {
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsService = GetIt.instance<DownloadsService>();
  bool _showTopTracks = true;
  bool _showAlbums = true;
  bool _showAppearsOnAlbums = true;
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
    final bool isOffline = FinampSettingsHelper.finampSettings.isOffline;
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
                  artistType: (widget.parent.type == "MusicGenre") ? null : ArtistType.albumartist);
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
                  artistType: (widget.parent.type == "MusicGenre") ? null : ArtistType.artist);
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
                artistType: (widget.parent.type == "MusicGenre") ? null : ArtistType.albumartist);
        albumArtistAlbums.sort((a, b) => (a.name).compareTo(b.name));
        // Then add the tracks of every album
        final List<BaseItemDto> sortedTracks = [];
        for (var album in albumArtistAlbums) {
          sortedTracks.addAll(await _downloadsService
              .getCollectionTracks(album.baseItem!, playable: true));
        }
        // Genre is already ready
        if (widget.parent.type == "MusicGenre") return sortedTracks;
        // Fetch every album where the artist is a performing artist
        final List<DownloadStub> performingArtistAlbums =
            await _downloadsService.getAllCollections(
                baseTypeFilter: BaseItemDtoType.album,
                relatedTo: widget.parent,
                artistType: (widget.parent.type == "MusicGenre") ? null : ArtistType.artist);
        performingArtistAlbums.sort((a, b) => (a.name).compareTo(b.name));
        // Filter out albums already fetched in the first query
        final List<DownloadStub> filteredPerformingArtistAlbums = performingArtistAlbums.where((performingAlbum) {
          return !albumArtistAlbums.any((albumArtistAlbum) => albumArtistAlbum.id == performingAlbum.id);
        }).toList();
        // Again add the tracks of every album
        final List<BaseItemDto> sortedTracksIncludingAppearsOn = [];
        for (var album in filteredPerformingArtistAlbums) {
          sortedTracks.addAll(await _downloadsService
              .getCollectionTracks(album.baseItem!, playable: true));
        }
        // Combine the results and return
        final combinedTracks = [...sortedTracks, ...sortedTracksIncludingAppearsOn];
        return combinedTracks;
      });
    } else {
      // In Online Mode
      futures = Future.wait([
        // Get Tracks sorted by Play Count
        if (FinampSettingsHelper.finampSettings.showArtistsTopTracks)
          jellyfinApiHelper.getItems(
            parentItem: widget.parent,
            filters: "Artist=${widget.parent.name}",
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
          filters: "Artist=${widget.parent.name}",
          sortBy: "PremiereDate,SortName",
          includeItemTypes: "MusicAlbum",
          artistType: (widget.parent.type == "MusicGenre") ? null : ArtistType.albumartist
        ),
        // Get Albums where artist is Performing Artist sorted by Premiere Date
        jellyfinApiHelper.getItems(
          parentItem: widget.parent,
          filters: "Artist=${widget.parent.name}",
          sortBy: "PremiereDate,SortName",
          includeItemTypes: "MusicAlbum",
          artistType: (widget.parent.type == "MusicGenre") ? null : ArtistType.artist
        ),
        // Now we fetch every performing artist track
        // (this has to happen in Future.wait, because otherwise we will
        // get the correct childrenCount for the Download Status too late)
        if (widget.parent.type != "MusicGenre")
          jellyfinApiHelper.getItems(
            parentItem: widget.parent,
            filters: "Artist=${widget.parent.name}",
            sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
            includeItemTypes: "Audio",
            artistType: (widget.parent.type == "MusicGenre") ? null : ArtistType.artist,
          )
        else
          Future.value(null)
      ]);

      // Get All Tracks for Track Count and Playback
      allTracks = Future.sync(() async {
        final previousResults = await futures;
        final allPerformingTracksResponse = previousResults[3];

        // Fetch every genre or album artist track
        final allAlbumArtistTracksResponse = await jellyfinApiHelper.getItems(
          parentItem: widget.parent,
          filters: "Artist=${widget.parent.name}",
          sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
          includeItemTypes: "Audio",
          artistType: (widget.parent.type == "MusicGenre") ? null : ArtistType.albumartist,
        );

        // Genre is already ready
        if (widget.parent.type == "MusicGenre") return allAlbumArtistTracksResponse;

        // We exclude albumartist tracks from performance artist tracks
        final allAlbumArtistTracks = allAlbumArtistTracksResponse ?? [];
        final allPerformingTracks = allPerformingTracksResponse ?? [];
        final albumArtistTrackIds = allAlbumArtistTracks.map((item) => item.id).toSet();
        final filteredPerformingTracks = allPerformingTracks
            .where((performingTrack) => !albumArtistTrackIds.contains(performingTrack.id))
            .toList();
        
        // combine and return
        final combinedTracks = [...allAlbumArtistTracks, ...filteredPerformingTracks];
        return combinedTracks;
      });
    }

    return FutureBuilder(
        future: futures,
        builder: (context, snapshot) {
          _isLoading = (_isLoading) ? (snapshot.connectionState == ConnectionState.waiting) : false;
          var tracks = snapshot.data?.elementAtOrNull(0) ?? [];
          var albums = snapshot.data?.elementAtOrNull(1) ?? [];
          var albumsAsPerformingArtist = snapshot.data?.elementAtOrNull(2) ?? [];
          var allPerformingArtistTracks = snapshot.data?.elementAtOrNull(3) ?? [];

          var appearsOnAlbums = albumsAsPerformingArtist.where((a) =>
              !albums.any((b) => b.id == a.id)).toList();
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
              // As genres don't have the buttons, we only add the 125 for them
              // TODO: This height is affected by platform density.
              expandedHeight: widget.parent.type != "MusicGenre"
                  ? kToolbarHeight + 125 + 96
                  : kToolbarHeight + 125 + 16,
              pinned: true,
              flexibleSpace: ArtistScreenContentFlexibleSpaceBar(
                parentItem: widget.parent,
                isGenre: widget.parent.type == "MusicGenre",
                allTracks: allTracks,
                albumCount: albums.length,
              ),
              actions: [
                // this screen is also used for genres, which can't be favorited
                if (widget.parent.type != "MusicGenre")
                  FavoriteButton(item: widget.parent),
                if (!_isLoading)
                  DownloadButton(
                      item: DownloadStub.fromItem(
                          item: widget.parent, type: DownloadItemType.collection),
                      children: (widget.parent.type == "MusicGenre") ? albums : allChildren)
              ],
            ),
            if (!_isLoading && !isOffline &&
              FinampSettingsHelper.finampSettings.showArtistsTopTracks)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                      6, widget.parent.type == "MusicGenre" ? 12 : 0, 6, 0),
              sliver: SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showTopTracks = !_showTopTracks;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: _showTopTracks ? 0 : -math.pi / 2,
                          child: const Icon(Icons.arrow_drop_down, size: 24),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.topTracks,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (!_isLoading && !isOffline &&
                FinampSettingsHelper.finampSettings.showArtistsTopTracks &&
                _showTopTracks)
            TracksSliverList(
              childrenForList: topTracks,
              childrenForQueue: Future.value(tracks),
              showPlayCount: true,
              isOnArtistScreen: true,
              parent: widget.parent,
            ),

            if (albums.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
              sliver: SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAlbums = !_showAlbums;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: _showAlbums ? 0 : -math.pi / 2,
                          child: const Icon(Icons.arrow_drop_down, size: 24),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.albums,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_showAlbums && albums.isNotEmpty)
            AlbumsSliverList(
              childrenForList: albums,
              parent: widget.parent,
            ),
            if (appearsOnAlbums.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
              sliver: SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAppearsOnAlbums = !_showAppearsOnAlbums;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: _showAppearsOnAlbums ? 0 : -math.pi / 2,
                          child: const Icon(Icons.arrow_drop_down, size: 24),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.appearsOnAlbums,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_showAppearsOnAlbums && appearsOnAlbums.isNotEmpty)
            AlbumsSliverList(
              childrenForList: appearsOnAlbums,
              parent: widget.parent,
            ),
            if (!_isLoading && (albums.isEmpty && appearsOnAlbums.isEmpty))
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 0), // Keeping horizontal and vertical padding the same
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12), // Updated inner padding
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.emptyFilteredListTitle,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            )
          ]);
        }
    );
  }
}
