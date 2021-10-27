import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

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
    List<List<BaseItemDto>> childrenPerDisc = [];
    // if not in playlist, try splitting up tracks by disc numbers
    // if first track has a disc number, let's assume the rest has it too
    if (parent.type != "Playlist" && children[0].parentIndexNumber != null) {
      int? lastDiscNumber;
      for (var child in children) {
        if (child.parentIndexNumber != null && child.parentIndexNumber != lastDiscNumber) {
          lastDiscNumber = child.parentIndexNumber;
          childrenPerDisc.add([]);
        }
        childrenPerDisc.last.add(child);
      }
    }

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
          if (childrenPerDisc.length > 1) // show headers only for multi disc albums
            for (var childrenOfThisDisc in childrenPerDisc)
              SliverStickyHeader(
                header: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  color: Colors.black, // TODO: get SliverAppBar background color
                  child: Text(
                      "Disc " + childrenOfThisDisc[0].parentIndexNumber.toString(),
                      style: const TextStyle(fontSize: 20.0)
                  ),
                ),
                sliver: _SongsSliverList(
                    childrenForList: childrenOfThisDisc,
                    childrenForQueue: children,
                    parentId: parent.id
                ),
              )
          else _SongsSliverList(
              childrenForList: children,
              childrenForQueue: children,
              parentId: parent.id
          ),
        ],
      ),
    );
  }
}

class _SongsSliverList extends StatelessWidget {
  const _SongsSliverList({
    Key? key,
    required this.childrenForList,
    required this.childrenForQueue,
    required this.parentId,
  }) : super(key: key);

  final List<BaseItemDto> childrenForList;
  final List<BaseItemDto> childrenForQueue;
  final String? parentId;

  @override
  Widget build(BuildContext context) {
    // When user selects song from disc other than first, index number is
    // incorrect and song with the same index on first disc is played instead.
    // Adding this offset ensures playback starts for nth song on correct disc.
    int indexOffset = childrenForQueue.indexOf(childrenForList[0]);

    return SliverList(
      delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
        final BaseItemDto item = childrenForList[index];
        return SongListTile(
          item: item,
          children: childrenForQueue,
          index: index + indexOffset,
          parentId: parentId,
        );
      }, childCount: childrenForList.length),
    );
  }
}
