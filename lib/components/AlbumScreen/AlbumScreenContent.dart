import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/AudioServiceHelper.dart';
import '../AlbumImage.dart';
import '../printDuration.dart';
import 'DownloadedIndicator.dart';
import 'AlbumScreenContentFlexibleSpaceBar.dart';
import 'DownloadButton.dart';

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
    AudioServiceHelper audioServiceHelper =
        GetIt.instance<AudioServiceHelper>();

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
              return ListTile(
                leading: AlbumImage(
                  itemId: parent.id,
                ),
                title: Text(item.name ?? "Unknown Name"),
                subtitle: Text(printDuration(
                  Duration(
                      microseconds: (item.runTimeTicks == null
                          ? 0
                          : item.runTimeTicks! ~/ 10)),
                )),
                trailing: DownloadedIndicator(item: item),
                onTap: () {
                  audioServiceHelper.replaceQueueWithItem(
                    itemList: children,
                    startAtIndex: index,
                  );
                },
              );
            }, childCount: children.length),
          ),
        ],
      ),
    );
  }
}
