import 'package:flutter/material.dart';

import '../../models/JellyfinModels.dart';
import 'AlbumScreenContentFlexibleSpaceBar.dart';
import 'DownloadButton.dart';
import 'SongListTile.dart';

class AlbumScreenContent extends StatelessWidget {
  const AlbumScreenContent({
    Key? key,
    required this.parent,
    required this.children,
  }) : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> children;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(parent.name ?? "Unknown Name"),
            // 125 + 64 is the total height of the widget we use as a
            // FlexibleSpaceBar. We add the toolbar height since the widget
            // should appear below the appbar.
            // TODO: This height is affected by platform density.
            expandedHeight: kToolbarHeight + 125 + 64,
            pinned: true,
            flexibleSpace: AlbumScreenContentFlexibleSpaceBar(
              album: parent,
              items: children,
            ),
            actions: [DownloadButton(parent: parent, items: children)],
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              final BaseItemDto item = children[index];
              return SongListTile(
                item: item,
                children: children,
                index: index,
              );
            }, childCount: children.length),
          ),
        ],
      ),
    );
  }
}
