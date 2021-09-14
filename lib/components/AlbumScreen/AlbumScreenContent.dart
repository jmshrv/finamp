import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/JellyfinModels.dart';
import '../../services/FinampSettingsHelper.dart';
import 'AlbumScreenContentFlexibleSpaceBar.dart';
import 'DownloadButton.dart';
import 'SongListTile.dart';
import 'PlaylistNameEditButton.dart';

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
            actions: [
              if (parent.type == "Playlist" &&
                  !FinampSettingsHelper.finampSettings.isOffline)
                PlaylistNameEditButton(playlist: parent),
              DownloadButton(parent: parent, items: children)
            ],
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              final BaseItemDto item = children[index];
              return Column(
                children: [
                  if (item.parentIndexNumber != null
                    && (index == 0
                        || children[index - 1].parentIndexNumber != item.parentIndexNumber)
                    && parent.type != "Playlist")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0
                      ),
                      child: Text(
                        "Disc " + item.parentIndexNumber.toString(),
                        style: const TextStyle(fontSize: 16.0)
                      ),
                    ),
                  SongListTile(
                    item: item,
                    children: children,
                    index: index,
                    parentId: parent.id,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              );
            }, childCount: children.length),
          ),
        ],
      ),
    );
  }
}
