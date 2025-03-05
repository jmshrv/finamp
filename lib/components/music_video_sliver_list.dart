import 'package:finamp/components/music_video_list_tile.dart';
import 'package:flutter/material.dart';

import '../../models/jellyfin_models.dart';

class MusicVideosSliverList extends StatefulWidget {
  const MusicVideosSliverList({
    super.key,
    required this.childrenForList,
    required this.parent,
  });

  final List<BaseItemDto> childrenForList;
  final BaseItemDto parent;

  @override
  State<MusicVideosSliverList> createState() => _MusicVideosSliverListState();
}

class _MusicVideosSliverListState extends State<MusicVideosSliverList> {
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

          return MusicVideoListTile(
            item: item,
            // children: widget.childrenForList,
            // index: index,
            // parentId: widget.parent.id,
            // parentName: widget.parent.name,
            // show artists except for this one scenario
            // TODO we could do it here like with the track sliver list
            // showArtists: false,
          );
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}
