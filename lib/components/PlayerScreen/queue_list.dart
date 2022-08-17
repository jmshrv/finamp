import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../album_image.dart';
import '../../models/jellyfin_models.dart';
import '../../services/process_artist.dart';
import '../../services/media_state_stream.dart';
import '../../services/music_player_background_task.dart';

class _QueueListStreamState {
  _QueueListStreamState(
    this.queue,
    this.mediaState,
  );

  final List<MediaItem>? queue;
  final MediaState mediaState;
}

class QueueList extends StatefulWidget {
  const QueueList({Key? key, required this.scrollController}) : super(key: key);

  final ScrollController scrollController;

  @override
  State<QueueList> createState() => _QueueListState();
}

class _QueueListState extends State<QueueList> {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  List<MediaItem>? _queue;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_QueueListStreamState>(
      // stream: AudioService.queueStream,
      stream: Rx.combineLatest2<List<MediaItem>?, MediaState,
              _QueueListStreamState>(_audioHandler.queue, mediaStateStream,
          (a, b) => _QueueListStreamState(a, b)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _queue ??= snapshot.data!.queue;
          return PrimaryScrollController(
            controller: widget.scrollController,
            child: ReorderableListView.builder(
              itemCount: snapshot.data!.queue?.length ?? 0,
              onReorder: (oldIndex, newIndex) async {
                setState(() {
                  // _queue?.insert(newIndex, _queue![oldIndex]);
                  // _queue?.removeAt(oldIndex);
                  int? smallerThanNewIndex;
                  if (oldIndex < newIndex) {
                    // When we're moving an item backwards, we need to reduce
                    // newIndex by 1 to account for there being a new item added
                    // before newIndex.
                    smallerThanNewIndex = newIndex - 1;
                  }
                  final item = _queue?.removeAt(oldIndex);
                  _queue?.insert(smallerThanNewIndex ?? newIndex, item!);
                });
                await _audioHandler.reorderQueue(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final actualIndex =
                    _audioHandler.playbackState.valueOrNull?.shuffleMode ==
                            AudioServiceShuffleMode.all
                        ? _audioHandler.shuffleIndices![index]
                        : index;
                return Dismissible(
                  key: ValueKey(snapshot.data!.queue![actualIndex].id),
                  onDismissed: (direction) async {
                    await _audioHandler.removeQueueItemAt(actualIndex);
                  },
                  child: ListTile(
                    leading: AlbumImage(
                      item: _queue?[actualIndex].extras?["ItemJson"] == null
                          ? null
                          : BaseItemDto.fromJson(
                              _queue?[actualIndex].extras?["ItemJson"]),
                    ),
                    title: Text(
                        snapshot.data!.queue?[actualIndex].title ??
                            AppLocalizations.of(context)!.unknownName,
                        style: snapshot.data!.mediaState.mediaItem ==
                                snapshot.data!.queue?[actualIndex]
                            ? TextStyle(
                                color: Theme.of(context).colorScheme.secondary)
                            : null),
                    subtitle: Text(processArtist(
                        snapshot.data!.queue?[actualIndex].artist)),
                    onTap: () async =>
                        await _audioHandler.skipToIndex(actualIndex),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
