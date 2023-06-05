import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../services/finamp_settings_helper.dart';
import '../album_image.dart';
import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../../services/process_artist.dart';
import '../../services/media_state_stream.dart';
import '../../services/music_player_background_task.dart';
import '../../services/queue_service.dart';

class _QueueListStreamState {
  _QueueListStreamState(
    this.mediaState,
    this.queueInfo,
  );

  final MediaState mediaState;
  final QueueInfo queueInfo;
}

class QueueList extends StatefulWidget {
  const QueueList({Key? key, required this.scrollController}) : super(key: key);

  final ScrollController scrollController;

  @override
  State<QueueList> createState() => _QueueListState();
}

class _QueueListState extends State<QueueList> {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();
  List<QueueItem>? _previousTracks;
  QueueItem? _currentTrack;
  List<QueueItem>? _queue;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_QueueListStreamState>(
      // stream: AudioService.queueStream,
      stream: Rx.combineLatest2<MediaState, QueueInfo,
              _QueueListStreamState>(mediaStateStream, _queueService.getQueueStream(),
          (a, b) => _QueueListStreamState(a, b)),
      // stream: _queueService.getQueueStream(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          _previousTracks ??= snapshot.data!.queueInfo.previousTracks;
          _currentTrack = snapshot.data!.queueInfo.currentTrack ?? QueueItem(item: const MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemSourceType.unknown));
          _queue ??= snapshot.data!.queueInfo.queue;

          final GlobalKey currentTrackKey = GlobalKey(debugLabel: "currentTrack");

          void scrollToCurrentTrack() {
            widget.scrollController.animateTo(((_previousTracks?.length ?? 0) * 60 + 20).toDouble(),
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear
            );
            // final targetContext = currentTrackKey.currentContext;
            // if (targetContext != null) {
            //   Scrollable.ensureVisible(targetContext!,
            //     duration: const Duration(milliseconds: 200),
            //     curve: Curves.linear
            //   );
            // }
          }
          // scroll to current track after sheet has been opened
          WidgetsBinding.instance
            .addPostFrameCallback((_) => scrollToCurrentTrack());

          return CustomScrollView(
            controller: widget.scrollController,
            slivers: <Widget>[
              // const SliverPadding(padding: EdgeInsets.only(top: 0)),
              // Previous Tracks
              SliverReorderableList(
                itemCount: _previousTracks?.length ?? 0,
                onReorder: (oldIndex, newIndex) async {
                  final oldOffset = -((_previousTracks?.length ?? 0) - oldIndex);
                  final newOffset = -((_previousTracks?.length ?? 0) - newIndex);
                  // setState(() {
                  //   // _previousTracks?.insert(newIndex, _previousTracks![oldIndex]);
                  //   // _previousTracks?.removeAt(oldIndex);
                  //   int? smallerThanNewIndex;
                  //   if (oldIndex < newIndex) {
                  //     // When we're moving an item backwards, we need to reduce
                  //     // newIndex by 1 to account for there being a new item added
                  //     // before newIndex.
                  //     smallerThanNewIndex = newIndex - 1;
                  //   }
                  //   final item = _previousTracks?.removeAt(oldIndex);
                  //   _previousTracks?.insert(smallerThanNewIndex ?? newIndex, item!);
                  // });
                  await _queueService.reorderByOffset(oldOffset, newOffset);
                },
                itemBuilder: (context, index) {
                  final actualIndex = index;
                  final indexOffset = -((_previousTracks?.length ?? 0) - index);
                  return ReorderableDelayedDragStartListener(
                    index: index,
                    key: ValueKey("${_previousTracks![actualIndex].item.id}$actualIndex-drag"),
                    child: Dismissible(
                      key: ValueKey(_previousTracks![actualIndex].item.id + actualIndex.toString()),
                      direction:
                          FinampSettingsHelper.finampSettings.disableGesture
                              ? DismissDirection.none
                              : DismissDirection.horizontal,
                      onDismissed: (direction) async {
                        await _queueService.removeAtOffset(indexOffset);
                      },
                      child: Card(
                        child: ListTile(
                          leading: AlbumImage(
                            item: _previousTracks?[actualIndex].item
                                        .extras?["itemJson"] ==
                                    null
                                ? null
                                : jellyfin_models.BaseItemDto.fromJson(_previousTracks?[actualIndex].item.extras?["itemJson"]),
                          ),
                          title: Text(
                              _previousTracks?[actualIndex].item.title ??
                                  AppLocalizations.of(context)!.unknownName,
                              style: _currentTrack ==
                                      _previousTracks?[actualIndex]
                                  ? TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.secondary)
                                  : null),
                          subtitle: Text(processArtist(
                              _previousTracks?[actualIndex].item.artist,
                              context)),
                          onTap: () async =>
                              await _queueService.skipByOffset(indexOffset),
                        ),
                      )
                    )
                  );
                },
              ),
              // Current Track
              SliverAppBar(
                key: currentTrackKey,
                pinned: true,
                collapsedHeight: 70.0,
                expandedHeight: 70.0,
                leading: const Padding(
                  padding: EdgeInsets.zero,
                ),
                flexibleSpace: ListTile(
                    leading: AlbumImage(
                      item: _currentTrack!.item
                                  .extras?["itemJson"] ==
                              null
                          ? null
                          : jellyfin_models.BaseItemDto.fromJson(_currentTrack!.item.extras?["itemJson"]),
                    ),
                    title: Text(
                        _currentTrack?.item.title ??
                            AppLocalizations.of(context)!.unknownName,
                        style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)
                    ),
                    subtitle: Text(processArtist(
                        _currentTrack!.item.artist,
                        context)),
                    onTap: () async =>
                        snapshot.data!.mediaState.playbackState.playing ? await _audioHandler.pause() : await _audioHandler.play(),
                )
              ),
              // Queue
              SliverReorderableList(
                itemCount: _queue?.length ?? 0,
                onReorder: (oldIndex, newIndex) async {
                  final oldOffset = oldIndex + 1;
                  final newOffset = newIndex + 1;
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
                  await _queueService.reorderByOffset(oldOffset, newOffset);
                },
                itemBuilder: (context, index) {
                  final actualIndex = index;
                  final indexOffset = index + 1;
                  return ReorderableDelayedDragStartListener(
                    key: ValueKey("${_queue![actualIndex].item.id}$actualIndex-drag"),
                    index: index,
                    child: Dismissible(
                      key: ValueKey(_queue![actualIndex].item.id + actualIndex.toString()),
                      direction:
                          FinampSettingsHelper.finampSettings.disableGesture
                              ? DismissDirection.none
                              : DismissDirection.horizontal,
                      onDismissed: (direction) async {
                        await _queueService.removeAtOffset(indexOffset);
                      },
                      child: Card(
                        child: ListTile(
                          leading: AlbumImage(
                            item: _queue?[actualIndex].item
                                        .extras?["itemJson"] ==
                                    null
                                ? null
                                : jellyfin_models.BaseItemDto.fromJson(_queue?[actualIndex].item.extras?["itemJson"]),
                          ),
                          title: Text(
                              _queue?[actualIndex].item.title ??
                                  AppLocalizations.of(context)!.unknownName,
                              style: _currentTrack ==
                                      _queue?[actualIndex]
                                  ? TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.secondary)
                                  : null),
                          subtitle: Text(processArtist(
                              _queue?[actualIndex].item.artist,
                              context)),
                          onTap: () async =>
                              await _queueService.skipByOffset(indexOffset),
                        ),
                      )
                    )
                  );
                },
              ),
            ],
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

Future<dynamic> showQueueBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    showDragHandle: true,
    useSafeArea: true,
    enableDrag: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
    ),
    context: context,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return QueueList(
            scrollController: scrollController,
          );
        },
      );
    },
  );
}
