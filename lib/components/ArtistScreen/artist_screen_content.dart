import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/album_screen_content.dart';
import '../AlbumScreen/song_list_tile.dart';
import '../MusicScreen/music_screen_tab_view.dart';

class ArtistScreenContent extends StatefulWidget {
  const ArtistScreenContent({Key? key, required this.parent}) : super(key: key);

  final BaseItemDto parent;

  @override
  State<ArtistScreenContent> createState() => _ArtistScreenContentState();
}

class _ArtistScreenContentState extends State<ArtistScreenContent> {
  Future<List<BaseItemDto>?>? songs;
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    songs ??= jellyfinApiHelper.getItems(
      parentItem: widget.parent,
      filters: "Artist=${widget.parent.name}",
      sortBy: "PlayCount",
      includeItemTypes: "Audio",
      isGenres: false,
    );

    return FutureBuilder(
        future: songs,
        builder: (context, snapshot) {
          var orderedSongs = snapshot.data?.map((_) => _).toList() ?? [];
          orderedSongs.sort(
              (a, b) => b.userData!.playCount.compareTo(a.userData!.playCount));

          return Scrollbar(
              child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              const SliverPadding(padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0)),
              const SliverToBoxAdapter(
                  child: Text(
                "Top Songs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
              SongsSliverList(
                childrenForList: orderedSongs.take(5).toList(),
                parent: widget.parent,
              ),
              const SliverPadding(padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0)),
              const SliverToBoxAdapter(
                  child: Text(
                "Albums",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
            ],
            body: MusicScreenTabView(
                tabContentType: TabContentType.albums,
                parentItem: widget.parent,
                isFavourite: false),
          ));
        });
  }
}

class SongsSliverList extends StatefulWidget {
  const SongsSliverList({
    Key? key,
    required this.childrenForList,
    required this.parent,
    this.onDelete,
  }) : super(key: key);

  final List<BaseItemDto> childrenForList;
  final BaseItemDto parent;
  final BaseItemDtoCallback? onDelete;

  @override
  State<SongsSliverList> createState() => _SongsSliverListState();
}

class _SongsSliverListState extends State<SongsSliverList> {
  final GlobalKey<SliverAnimatedListState> sliverListKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final BaseItemDto item = widget.childrenForList[index];

          BaseItemDto removeItem() {
            late BaseItemDto item;

            setState(() {
              item = widget.childrenForList.removeAt(index);
            });

            return item;
          }

          return SongListTile(
            item: item,
            children: widget.childrenForList,
            index: index,
            parentId: widget.parent.id,
            parentName: widget.parent.name,
            onDelete: () {
              final item = removeItem();
              if (widget.onDelete != null) {
                widget.onDelete!(item);
              }
            },
            isInPlaylist: widget.parent.type == "Playlist",
            // show artists except for this one scenario
            showArtists: false,
            showPlayCount: true,
          );
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}
