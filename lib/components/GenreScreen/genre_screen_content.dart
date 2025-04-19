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
import '../ArtistScreen/artist_screen_content_flexible_space_bar.dart';

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
    final Future<List<BaseItemDto>?> allTracks;
    final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
    var settings = FinampSettingsHelper.finampSettings;

    // Get Items
    if (isOffline) {
      // In Offline Mode
      futures = Future.wait([
        // Top Tracks - Play count tracking is not implemented offline
        Future.value(
            <BaseItemDto>[]),
        // Top Albums - Play count tracking is not implemented offline
        Future.value(
            <BaseItemDto>[]),
        // Top Artists - Play count tracking is not implemented offline
        Future.value(
            <BaseItemDto>[]),
      ]);

      // Get All Tracks for Track Count and Playback
      allTracks = Future.sync(() async {
        // First fetch every album of the album artist or genre
        final List<DownloadStub> allTracks =
          await _downloadsService.getAllTracks(
            // viewFilter: widget.view?.id,
            nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
            onlyFavorites:
                settings.onlyShowFavourites && settings.trackOfflineFavorites,
            genreFilter: widget.parent
          );
        var items = allTracks.map((e) => e.baseItem).nonNulls.toList();
        items = sortItems(items, settings.tabSortBy[TabContentType.tracks],
        settings.tabSortOrder[TabContentType.tracks]);
        return items;
      });
    } else {
      // In Online Mode
      futures = Future.wait([
        // Get Top Tracks
        jellyfinApiHelper.getItems(
          parentItem: widget.parent,
          sortBy: "PlayCount,SortName",
          sortOrder: "Descending",
          limit: 5,
          includeItemTypes: "Audio",
        ),
        // Get Top Albums
        jellyfinApiHelper.getItems(
            parentItem: widget.parent,
            sortBy: "PlayCount,PremiereDate,SortName",
            sortOrder: "Descending",
            limit: 5,
            includeItemTypes: "MusicAlbum"),
        // Get Top Artists (either Album or Performing Artists, depending on setting)
        jellyfinApiHelper.getItems(
            genreFilter: widget.parent,
            sortBy: "PlayCount,SortName",
            sortOrder: "Descending",
            //filters: "IsFavoriteOrLikes",
            limit: 5,
            includeItemTypes: "MusicArtist",
            artistType: settings.artistListType),
      ]);

      // Get All Tracks for Track Count and Playback
      allTracks = Future.sync(() async {
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

          var topTracks = tracks
              .takeWhile((s) => (s.userData?.playCount ?? 0) > 0)
              .take(5)
              .toList();

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
                      children: topAlbums) // This is not right as well!!!
              ],
            ),
            if (!_isLoading)
              TracksSection(
                  parent: widget.parent,
                  tracks: topTracks,
                  childrenForQueue: Future.value(tracks),
                  tracksText: AppLocalizations.of(context)!.topTracks,
                  seeAllCallbackFunction: () => openSeeAll(TabContentType.tracks),
              ),
            if (!_isLoading)
              AlbumSection(
                  parent: widget.parent,
                  albumsText: "Top Albums",
                  albums: topAlbums,
                  seeAllCallbackFunction: () => openSeeAll(TabContentType.albums),
              ),
            if (!_isLoading)
              AlbumSection(
                  parent: widget.parent,
                  albumsText: "Top Artists",
                  albums: topArtists,
                  seeAllCallbackFunction: () => openSeeAll(TabContentType.artists),
                  genreFilter: widget.parent,
              ),
            /*if (!_isLoading && (albums.isEmpty && appearsOnAlbums.isEmpty))
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
              */
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
