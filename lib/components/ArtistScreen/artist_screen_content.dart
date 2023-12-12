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
  const ArtistScreenContent({Key? key, required this.artist}) : super(key: key);

  final BaseItemDto artist;

  @override
  State<ArtistScreenContent> createState() => _ArtistScreenContentState();
}

class _ArtistScreenContentState extends State<ArtistScreenContent> {
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    final futures = Future.wait([
      jellyfinApiHelper.getItems(
        parentItem: widget.artist,
        filters: "Artist=${widget.artist.name}",
        sortBy: "PlayCount",
        includeItemTypes: "Audio",
        isGenres: false,
      ),
      jellyfinApiHelper.getItems(
        parentItem: widget.artist,
        filters: "Artist=${widget.artist.name}",
        sortBy: "ProductionYear",
        includeItemTypes: "MusicAlbum",
        isGenres: false,
      )
    ]);

    return FutureBuilder(
        future: futures,
        builder: (context, snapshot) {
          var songs = snapshot.data?.elementAt(0) ?? [];
          var albums = snapshot.data?.elementAt(1) ?? [];

          var orderedSongs = songs.reversed.toList();
          return Scrollbar(
              child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              title: Text(widget.artist.name ??
                  AppLocalizations.of(context)!.unknownName),
              // 125 + 186 is the total height of the widget we use as a
              // FlexibleSpaceBar. We add the toolbar height since the widget
              // should appear below the appbar.
              // TODO: This height is affected by platform density.
              expandedHeight: kToolbarHeight + 125 + 126,
              pinned: true,
              flexibleSpace: ArtistScreenContentFlexibleSpaceBar(
                parentItem: widget.artist,
                isGenre: widget.artist.type == "MusicGenre",
                items: orderedSongs,
              ),
              actions: [
                // this screen is also used for genres, which can't be favorited
                if (widget.artist.type != "MusicGenre")
                  FavoriteButton(item: widget.artist),
                ArtistDownloadButton(artist: widget.artist)
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
              childrenForList: orderedSongs.take(5).toList(),
              childrenForQueue: orderedSongs,
              showPlayCount: true,
              parent: widget.artist,
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
              parent: widget.artist,
            ),
          ]));
        });
  }
}
