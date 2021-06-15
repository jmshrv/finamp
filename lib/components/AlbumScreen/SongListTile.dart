import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/AudioServiceHelper.dart';
import '../../services/processArtist.dart';
import '../AlbumImage.dart';
import '../printDuration.dart';
import 'DownloadedIndicator.dart';

enum SongListTileMenuItems {
  AddToQueue,
}

class SongListTile extends StatefulWidget {
  const SongListTile({
    Key? key,
    required this.item,
    required this.children,
    required this.index,
    this.parentId,
    this.isSong = false,
  }) : super(key: key);

  final BaseItemDto item;
  final List<BaseItemDto> children;
  final int index;
  final bool isSong;
  final String? parentId;

  @override
  _SongListTileState createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onLongPressStart: (details) async {
        final selection = await showMenu<SongListTileMenuItems>(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            screenSize.width - details.globalPosition.dx,
            screenSize.height - details.globalPosition.dy,
          ),
          items: [
            PopupMenuItem<SongListTileMenuItems>(
              value: SongListTileMenuItems.AddToQueue,
              child: ListTile(
                leading: Icon(Icons.queue_music),
                title: Text("Add To Queue"),
              ),
            ),
          ],
        );

        switch (selection) {
          case SongListTileMenuItems.AddToQueue:
            await audioServiceHelper.addQueueItem(widget.item);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Added to queue.")));
            break;
          default:
            break;
        }
      },
      child: Dismissible(
        key: Key(widget.index.toString()),
        background: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Icon(Icons.queue_music),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        confirmDismiss: (direction) async {
          await audioServiceHelper.addQueueItem(widget.item);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Added to queue.")));
          return false;
        },
        direction: DismissDirection.startToEnd,
        child: ListTile(
          leading: AlbumImage(
            itemId: widget.item.parentId,
          ),
          title: StreamBuilder<MediaItem?>(
            stream: AudioService.currentMediaItemStream,
            builder: (context, snapshot) {
              return Text(
                widget.item.name ?? "Unknown Name",
                style: TextStyle(
                  color: snapshot.data?.extras!["itemId"] == widget.item.id &&
                          snapshot.data?.extras!["parentId"] == widget.parentId
                      ? Colors.green
                      : null,
                ),
              );
            },
          ),
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
        ),
      ),
    );
  }
}
