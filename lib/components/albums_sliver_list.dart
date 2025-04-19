import 'package:finamp/components/MusicScreen/album_item.dart';
import 'package:flutter/material.dart';

import '../../models/jellyfin_models.dart';
import 'album_list_tile.dart';

class AlbumsSliverList extends StatefulWidget {
  const AlbumsSliverList({
    super.key,
    required this.childrenForList,
    required this.parent,
    this.genreFilter,
  });

  final List<BaseItemDto> childrenForList;
  final BaseItemDto parent;
  final BaseItemDto? genreFilter;

  @override
  State<AlbumsSliverList> createState() => _AlbumsSliverListState();
}

class _AlbumsSliverListState extends State<AlbumsSliverList> {
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
          if (item.isArtist) {
            return AlbumItem(
              key: ValueKey(item.id),
              album: item,
              isPlaylist: false,
              genreFilter: widget.genreFilter,
            );
          } else {
            return AlbumListTile(
              item: item,
              children: widget.childrenForList,
              index: index,
              parentId: widget.parent.id,
              parentName: widget.parent.name,
              // show artists except for this one scenario
              // TODO we could do it here like with the track sliver list
              // showArtists: false,
            );
          }
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}
