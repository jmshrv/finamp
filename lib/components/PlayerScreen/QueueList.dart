import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../AlbumImage.dart';
import '../../services/connectIfDisconnected.dart';
import '../../services/processArtist.dart';

class QueueList extends StatefulWidget {
  const QueueList({Key key, this.scrollController}) : super(key: key);

  final ScrollController scrollController;

  @override
  _QueueListState createState() => _QueueListState();
}

class _QueueListState extends State<QueueList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MediaItem>>(
      stream: AudioService.queueStream,
      builder: (context, snapshot) {
        connectIfDisconnected();
        if (snapshot.hasData) {
          final List<MediaItem> queue = snapshot.data;
          return ListView.builder(
            controller: widget.scrollController,
            itemCount: queue.length,
            itemBuilder: (context, index) {
              return Dismissible(
                onDismissed: (direction) {
                  queue.removeAt(index);
                  AudioService.customAction("removeQueueItem", index);
                },
                key: Key(queue[index].id),
                child: ListTile(
                  leading: AlbumImage(
                    itemId: queue[index].id,
                  ),
                  title: Text(queue[index].title,
                      style: AudioService.currentMediaItem == queue[index]
                          ? TextStyle(color: Colors.lightGreen)
                          : null),
                  subtitle: Text(processArtist(queue[index].artist)),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
