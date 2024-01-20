import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/album_screen_content.dart';
import '../MusicScreen/music_screen_tab_view.dart';

import '../favourite_button.dart';
import 'artist_download_button.dart';
import 'artist_screen_content_flexible_space_bar.dart';
import '../albums_sliver_list.dart';

class ArtistScreenContent extends StatefulWidget {
  const ArtistScreenContent({Key? key, required this.parent}) : super(key: key);

  final BaseItemDto parent;

  @override
  State<ArtistScreenContent> createState() => _ArtistScreenContentState();
}

class _ArtistScreenContentState extends State<ArtistScreenContent> {
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    final futures = Future.wait([
      // Get Songs sorted by Play Count
      jellyfinApiHelper.getItems(
        parentItem: widget.parent,
        filters: "Artist=${widget.parent.name}",
        sortBy: "PlayCount",
        sortOrder: "Descending",
        includeItemTypes: "Audio",
        isGenres: false,
        limit: 5,
      ),
      // Get Albums sorted by Production Year
      jellyfinApiHelper.getItems(
        parentItem: widget.parent,
        filters: "Artist=${widget.parent.name}",
        sortBy: "ProductionYear",
        includeItemTypes: "MusicAlbum",
        isGenres: false,
      )
    ]);

    // Get all songs
    final allSongs = jellyfinApiHelper.getItems(
      parentItem: widget.parent,
      filters: "Artist=${widget.parent.name}",
      sortBy: "Album,ParentIndexNumber,IndexNumber,SortName",
      includeItemTypes: "Audio",
      isGenres: false,
    );

    return FutureBuilder(
        future: futures,
        builder: (context, snapshot) {
          var songs = snapshot.data?.elementAtOrNull(0) ?? [];
          var albums = snapshot.data?.elementAtOrNull(1) ?? [];

          return Scrollbar(
              child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              title: Text(widget.parent.name ??
                  AppLocalizations.of(context)!.unknownName),
              // 125 + 116 is the total height of the widget we use as a
              // FlexibleSpaceBar. We add the toolbar height since the widget
              // should appear below the appbar.
              // As genres don't have the buttons, we only add the 125 for them
              // TODO: This height is affected by platform density.
              expandedHeight: widget.parent.type != "MusicGenre"
                  ? kToolbarHeight + 125 + 116
                  : kToolbarHeight + 125,
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
                ArtistDownloadButton(artist: widget.parent)
              ],
            ),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(6, 15, 6, 0),
                sliver: SliverToBoxAdapter(
                    child: Text(
                  AppLocalizations.of(context)!.topSongs,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ))),
            SongsSliverList(
              childrenForList: songs,
              childrenForQueue: allSongs.then((songs) => List.from(songs ?? [])
                ..sort(
                  (a, b) =>
                      b.userData?.playCount
                          .compareTo(a.userData?.playCount ?? 0) ??
                      0,
                )),
              showPlayCount: true,
              isOnArtistScreen: true,
              parent: widget.parent,
            ),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(6, 15, 6, 0),
                sliver: SliverToBoxAdapter(
                    child: Text(
                  AppLocalizations.of(context)!.albums,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ))),
            AlbumsSliverList(
              childrenForList: albums,
              parent: widget.parent,
            ),
          ]));
        });
  }
}
