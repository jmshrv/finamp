import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/album_screen_content.dart';
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
      jellyfinApiHelper.getItems(
        parentItem: widget.parent,
        filters: "Artist=${widget.parent.name}",
        sortBy: "PlayCount",
        includeItemTypes: "Audio",
        isGenres: false,
      ),
      jellyfinApiHelper.getItems(
        parentItem: widget.parent,
        filters: "Artist=${widget.parent.name}",
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
            const SliverPadding(padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0)),
            SliverToBoxAdapter(
                child: Text(
              AppLocalizations.of(context)!.topSongs,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            SongsSliverList(
              childrenForList: orderedSongs.take(5).toList(),
              childrenForQueue: orderedSongs,
              showPlayCount: true,
              parent: widget.parent,
            ),
            const SliverPadding(padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0)),
            SliverToBoxAdapter(
                child: Text(
              AppLocalizations.of(context)!.albums,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            AlbumsSliverList(
              childrenForList: albums,
              parent: widget.parent,
            ),
          ]));
        });
  }
}
