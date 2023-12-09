import 'package:finamp/components/ArtistScreen/artist_download_button.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/album_screen_content.dart';
import '../MusicScreen/music_screen_tab_view.dart';
import '../favourite_button.dart';
import 'artist_screen_content_flexible_space_bar.dart';

class ArtistScreenContent extends StatefulWidget {
  const ArtistScreenContent({Key? key, required this.artist}) : super(key: key);

  final BaseItemDto artist;

  @override
  State<ArtistScreenContent> createState() => _ArtistScreenContentState();
}

class _ArtistScreenContentState extends State<ArtistScreenContent> {
  Future<List<BaseItemDto>?>? songs;
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    songs ??= jellyfinApiHelper.getItems(
      parentItem: widget.artist,
      filters: "Artist=${widget.artist.name}",
      sortBy: "PlayCount",
      includeItemTypes: "Audio",
      isGenres: false,
    );

    return FutureBuilder(
        future: songs,
        builder: (context, snapshot) {
          var orderedSongs = snapshot.data?.reversed.toList() ?? [];

          return Scrollbar(
              child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
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
                showArtist: false,
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
            ],
            body: MusicScreenTabView(
                tabContentType: TabContentType.albums,
                parentItem: widget.artist,
                isFavourite: false),
          ));
        });
  }
}
