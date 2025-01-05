import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class ArtistScreenContent extends StatefulWidget {
  const ArtistScreenContent({super.key, required this.parent});

  final BaseItemDto parent;

  @override
  State<ArtistScreenContent> createState() => _ArtistScreenContentState();
}

class _ArtistScreenContentState extends State<ArtistScreenContent> {
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
    final Future<List<List<BaseItemDto>?>> futures;
    final Future<List<BaseItemDto>?> allSongs;
    final bool isOffline = FinampSettingsHelper.finampSettings.isOffline;
    if (isOffline) {
      futures = Future.wait([
        Future.value(
            <BaseItemDto>[]), // Play count tracking is not implemented offline
        Future.sync(() async {
          final List<DownloadStub> artistAlbums =
              await _downloadsService.getAllCollections(
                  baseTypeFilter: BaseItemDtoType.album,
                  relatedTo: widget.parent);
          artistAlbums.sort((a, b) => (a.baseItem?.premiereDate ?? "")
              .compareTo(b.baseItem!.premiereDate ?? ""));
          return artistAlbums.map((e) => e.baseItem).whereNotNull().toList();
        }),
      ]);
      allSongs = Future.sync(() async {
        final List<DownloadStub> artistAlbums =
            await _downloadsService.getAllCollections(
                baseTypeFilter: BaseItemDtoType.album,
                relatedTo: widget.parent);
        artistAlbums.sort((a, b) => (a.name).compareTo(b.name));

        final List<BaseItemDto> sortedSongs = [];
        for (var album in artistAlbums) {
          sortedSongs.addAll(await _downloadsService
              .getCollectionSongs(album.baseItem!, playable: true));
        }
        return sortedSongs;
      });
    } else {
      futures = Future.wait([
        // Get Songs sorted by Play Count
        if (FinampSettingsHelper.finampSettings.showArtistsTopSongs)
          jellyfinApiHelper.getItems(
            parentItem: widget.parent,
            filters: "Artist=${widget.parent.name}",
            sortBy: "PlayCount,SortName",
            sortOrder: "Descending",
            includeItemTypes: "Audio",
          )
        else
          Future.value(null),
        // Get Albums sorted by Premiere Date
        jellyfinApiHelper.getItems(
          parentItem: widget.parent,
          filters: "Artist=${widget.parent.name}",
          sortBy: "PremiereDate,SortName",
          includeItemTypes: "MusicAlbum",
        ),
      ]);
      allSongs = jellyfinApiHelper.getItems(
        parentItem: widget.parent,
        filters: "Artist=${widget.parent.name}",
        sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
        includeItemTypes: "Audio",
      );
    }

    return FutureBuilder(
        future: futures,
        builder: (context, snapshot) {
          var songs = snapshot.data?.elementAtOrNull(0) ?? [];
          var albums = snapshot.data?.elementAtOrNull(1) ?? [];
          var topTracks = songs
              .takeWhile((s) => (s.userData?.playCount ?? 0) > 0)
              .take(5)
              .toList();

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
                allSongs: allSongs,
                albumCount: albums.length,
              ),
              actions: [
                // this screen is also used for genres, which can't be favorited
                if (widget.parent.type != "MusicGenre")
                  FavoriteButton(item: widget.parent),
                DownloadButton(
                    item: DownloadStub.fromItem(
                        item: widget.parent, type: DownloadItemType.collection),
                    children: albums.length)
              ],
            ),
            if (!isOffline &&
                FinampSettingsHelper.finampSettings.showArtistsTopSongs)
              SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      6, widget.parent.type == "MusicGenre" ? 12 : 0, 6, 0),
                  sliver: SliverToBoxAdapter(
                      child: Text(
                    AppLocalizations.of(context)!.topSongs,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ))),
            if (!isOffline &&
                FinampSettingsHelper.finampSettings.showArtistsTopSongs)
              SongsSliverList(
                childrenForList: topTracks,
                childrenForQueue: Future.value(songs),
                showPlayCount: true,
                isOnArtistScreen: true,
                parent: widget.parent,
              ),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                sliver: SliverToBoxAdapter(
                    child: Text(
                  AppLocalizations.of(context)!.albums,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ))),
            AlbumsSliverList(
              childrenForList: albums,
              parent: widget.parent,
            )
          ]);
        });
  }
}
