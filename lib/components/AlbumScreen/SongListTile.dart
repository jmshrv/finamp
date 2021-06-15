import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/AudioServiceHelper.dart';
import '../../services/processArtist.dart';
import '../AlbumImage.dart';
import '../printDuration.dart';
import 'DownloadedIndicator.dart';

class SongListTile extends StatefulWidget {
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
  _SongListTileState createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AlbumImage(
        itemId: widget.item.parentId,
      ),
      title: Text(widget.item.name ?? "Unknown Name"),
      subtitle: Text(widget.isSong
          ? processArtist(widget.item.albumArtist)
          : printDuration(
              Duration(
                  microseconds: (widget.item.runTimeTicks == null
                      ? 0
                      : widget.item.runTimeTicks! ~/ 10)),
            )),
      trailing: DownloadedIndicator(item: widget.item),
      onTap: () {
        audioServiceHelper.replaceQueueWithItem(
          itemList: widget.children,
          initialIndex: widget.index,
        );
      },
    );
  }
}
