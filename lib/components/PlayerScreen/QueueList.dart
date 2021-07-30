import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../AlbumImage.dart';
import '../../services/connectIfDisconnected.dart';
import '../../services/processArtist.dart';

class _QueueListStreamState {
  _QueueListStreamState({
    required this.queue,
    required this.shuffleIndicies,
  });

  final List<MediaItem>? queue;
  final dynamic shuffleIndicies;
}

class QueueList extends StatefulWidget {
  const QueueList({Key? key, this.scrollController}) : super(key: key);

  final ScrollController? scrollController;

  @override
  _QueueListState createState() => _QueueListState();
}

class _QueueListState extends State<QueueList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_QueueListStreamState>(
      // stream: AudioService.queueStream,
      stream:
          Rx.combineLatest2<List<MediaItem>?, dynamic, _QueueListStreamState>(
              AudioService.queueStream,
              // We turn this future into a stream because using rxdart is
              // easier than having nested StreamBuilders/FutureBuilders
              AudioService.customAction("getShuffleIndices").asStream(),
              (a, b) => _QueueListStreamState(queue: a, shuffleIndicies: b)),
      builder: (context, snapshot) {
        connectIfDisconnected();
        if (snapshot.hasData) {
          return ListView.builder(
            controller: widget.scrollController,
            itemCount: snapshot.data!.queue?.length ?? 0,
            itemBuilder: (context, index) {
              final actualIndex = AudioService.playbackState.shuffleMode ==
                      AudioServiceShuffleMode.all
                  ? snapshot.data!.shuffleIndicies![index]
                  : index;
              return Dismissible(
                onDismissed: (direction) {
                  snapshot.data?.queue?.removeAt(actualIndex);
                  AudioService.customAction("removeQueueItem", actualIndex);
                },
                key: Key(snapshot.data!.queue![actualIndex].id),
                child: ListTile(
                  leading: AlbumImage(
                    itemId:
                        snapshot.data?.queue?[actualIndex].extras?["parentId"],
                  ),
                  title: Text(
                      snapshot.data!.queue?[actualIndex].title ??
                          "Unknown Name",
                      style: AudioService.currentMediaItem ==
                              snapshot.data!.queue?[actualIndex]
                          ? TextStyle(color: Theme.of(context).accentColor)
                          : null),
                  subtitle: Text(
                      processArtist(snapshot.data!.queue?[actualIndex].artist)),
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
