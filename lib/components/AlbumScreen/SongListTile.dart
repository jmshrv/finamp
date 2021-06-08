import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/AudioServiceHelper.dart';
import '../../services/processArtist.dart';
import '../AlbumImage.dart';
import '../printDuration.dart';
import 'DownloadedIndicator.dart';

class SongListTile extends StatelessWidget {
  const SongListTile({
    Key? key,
    required this.item,
    required this.children,
    required this.index,
    this.isSong = false,
  }) : super(key: key);

  final BaseItemDto item;
  final List<BaseItemDto> children;
  final int index;
  final bool isSong;

  @override
  Widget build(BuildContext context) {
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    return ListTile(
      leading: AlbumImage(
        itemId: item.parentId,
      ),
      title: Text(item.name ?? "Unknown Name"),
      subtitle: Text(isSong
          ? processArtist(item.albumArtist)
          : printDuration(
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
  }
}
