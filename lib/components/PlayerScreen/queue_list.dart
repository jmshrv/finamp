import 'package:audio_service/audio_service.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import '../../services/finamp_settings_helper.dart';
import '../album_image.dart';
import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../../services/process_artist.dart';
import '../../services/media_state_stream.dart';
import '../../services/music_player_background_task.dart';
import '../../services/queue_service.dart';
import 'queue_list_item.dart';

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
  List<QueueItem>? _nextUp;
  List<QueueItem>? _queue;
  QueueItemSource? _source;

  late List<Widget> _contents;

  int offsetBeforeDrag = -1;
  int offsetAfterDrag = -1;

  @override
  void initState() {
    super.initState();

    _contents = <Widget>[
      // const SliverPadding(padding: EdgeInsets.only(top: 0)),
      // Previous Tracks
      SliverList.list(
        children: const [],
      ),
      // Current Track
      SliverAppBar(
        pinned: true,
        collapsedHeight: 70.0,
        expandedHeight: 70.0,
        leading: const Padding(
          padding: EdgeInsets.zero,
        ),
        flexibleSpace: ListTile(
          leading: const AlbumImage(
            item: null,
          ),
          title: Text(
              "Unknown song"),
          subtitle: Text("Unknown artist"),
          onTap: () {}
        )
      ),
      SliverPersistentHeader(
        delegate: SectionHeaderDelegate("Queue")
      ),
      // Queue
      SliverList.list(
        children: const [],
      ),
    ];
  }

  int _offsetOfKey(Key key) {
    int oldOffset = 0;

    int oldListIndex = -1;
    int oldItemIndex = -1;

    // lookup current index of the item belonging to the data
    if (_nextUp != null && _nextUp!.isNotEmpty) {
      oldItemIndex = _nextUp!.indexWhere((e) => ValueKey(e.id) == key);
      oldListIndex = 1;
    }
    if (oldItemIndex == -1) {
      oldItemIndex = _nextUp!.length + _queue!.indexWhere((e) => ValueKey(e.id) == key);
      oldListIndex = 2;
    }
    if (oldItemIndex == -1) {
      oldItemIndex = _previousTracks!.indexWhere((e) => ValueKey(e.id) == key);
      oldListIndex = 0;
    }
    print("oldItemIndex: $oldItemIndex");
    print("oldListIndex: $oldListIndex");

    // old index
    if (oldListIndex == 0) {
      // previous tracks
      oldOffset = -((_previousTracks?.length ?? 0) - oldItemIndex);
    } else if (oldListIndex == 1) {
      // next up
      oldOffset = oldItemIndex + 1;
    } else if (oldListIndex == 2) {
      // queue
      oldOffset = oldItemIndex + _nextUp!.length + 1;
    }

    return oldOffset;

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_QueueListStreamState>(
      // stream: AudioService.queueStream,
      stream: Rx.combineLatest2<MediaState, QueueInfo, _QueueListStreamState>(
          mediaStateStream,
          _queueService.getQueueStream(),
          (a, b) => _QueueListStreamState(a, b)),
      // stream: _queueService.getQueueStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _previousTracks ??= snapshot.data!.queueInfo.previousTracks;
          _currentTrack = snapshot.data!.queueInfo.currentTrack ??
              QueueItem(
                  item: const MediaItem(
                      id: "",
                      title: "No track playing",
                      album: "No album",
                      artist: "No artist"),
                  source: QueueItemSource(
                      id: "", name: "", type: QueueItemSourceType.unknown));
          _nextUp ??= snapshot.data!.queueInfo.nextUp;
          _queue ??= snapshot.data!.queueInfo.queue;
          _source ??= snapshot.data!.queueInfo.source;

          final GlobalKey currentTrackKey =
              GlobalKey(debugLabel: "currentTrack");

          void scrollToCurrentTrack() {
            widget.scrollController.animateTo(
                ((_previousTracks?.length ?? 0) * 60 + 20).toDouble(),
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
            // final targetContext = currentTrackKey.currentContext;
            // if (targetContext != null) {
            //   Scrollable.ensureVisible(targetContext!,
            //     duration: const Duration(milliseconds: 200),
            //     curve: Curves.linear
            //   );
            // }
          }
          // scroll to current track after sheet has been opened
          //TODO fix this
          // WidgetsBinding.instance
          //   .addPostFrameCallback((_) => scrollToCurrentTrack());

          _contents = <Widget>[
            // const SliverPadding(padding: EdgeInsets.only(top: 0)),
            // Previous Tracks
            SliverPersistentHeader(
              delegate: SectionHeaderDelegate("Previous Tracks"),
            ),
            SliverList.builder(
              itemCount: _previousTracks?.length ?? 0,
              itemBuilder: (context, index) {
                final item = _previousTracks![index];
                final actualIndex = index;
                final indexOffset = -((_previousTracks?.length ?? 0) - index);
                return ReorderableItem(
                  // key: ValueKey("${_queue![actualIndex].item.id}$actualIndex"),
                  key: ValueKey(_previousTracks![actualIndex].id),
                  childBuilder: (
                      BuildContext context,
                      ReorderableItemState state
                    ) {
                      return QueueListItem(
                        item: item,
                        actualIndex: actualIndex,
                        indexOffset: indexOffset,
                        subqueue: _previousTracks!,
                        isCurrentTrack: _currentTrack == item,
                      );
                    }
                );
              },
            ),
            // Current Track
             SliverPersistentHeader(
              delegate: SectionHeaderDelegate("Current Track"),
            ),
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
                              .extras?["itemJson"] == null
                          ? null
                          : jellyfin_models.BaseItemDto.fromJson(_currentTrack!.item.extras?["itemJson"]),
                ),
                title: Text(
                    _currentTrack!.item.title ?? AppLocalizations.of(context)!.unknownName,
                    style: _currentTrack == _currentTrack!
                            ? TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)
                            : null),
                subtitle: Text(processArtist(
                    _currentTrack!.item.artist,
                    context)),
                onTap: () async =>
                    snapshot.data!.mediaState.playbackState.playing ? await _audioHandler.pause() : await _audioHandler.play(),
              ),
            ),
            SliverPersistentHeader(
              delegate: SectionHeaderDelegate(
                _source?.name != null
                ? "Playing from ${_source?.name}"
                : "Queue",
                true,
              ),
            ),
            // Queue
            SliverList.builder(
              itemCount: _queue?.length ?? 0,
              itemBuilder: (context, index) {
                final item = _queue![index];
                final actualIndex = index;
                final indexOffset = index + 1;
                return ReorderableItem(
                    key: ValueKey(_queue![actualIndex].id),
                    childBuilder: (
                        BuildContext context,
                        ReorderableItemState state
                      ) {
                        // if (candidateData.isNotEmpty && candidateData.first != null && candidateData.first != item) {
                        //   return Column(
                        //     children: [
                        //       QueueListItemGhost(
                        //         item: candidateData.first!,
                        //         isCurrentTrack: _currentTrack == item,
                        //       ),
                        //       QueueListItem(
                        //         item: item,
                        //         actualIndex: actualIndex,
                        //         indexOffset: indexOffset,
                        //         subqueue: _queue!,
                        //         isCurrentTrack: _currentTrack == item,
                        //       ),
                        //     ],
                        //   );
                        // } else {
                          return Container(
                            child: SafeArea(
                                top: false,
                                bottom: false,
                                child: Opacity(
                                  // hide content for placeholder
                                  opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
                                  child: IntrinsicHeight(
                                    child: QueueListItem(
                                      item: item,
                                      actualIndex: actualIndex,
                                      indexOffset: indexOffset,
                                      subqueue: _queue!,
                                      isCurrentTrack: _currentTrack == item,
                                    ),
                                  ),
                                ),
                            ),
                          );
                        // }
                      },
                  );
              },
            ),
          ];

          // return CustomScrollView(
          //   controller: widget.scrollController,
          //   slivers: _contents,
          // );
          return ReorderableList(
            onReorder: (Key draggedItem, Key newPosition) {
              int draggingOffset = _offsetOfKey(draggedItem);
              int newPositionOffset = _offsetOfKey(newPosition);
              offsetBeforeDrag = draggingOffset;
              offsetAfterDrag = newPositionOffset;
              print("$draggingOffset -> $newPositionOffset");
              // setState(() {
              //   //FIXME this is a slow operation, ideally we should just swap the items in the list
              //   // problem with that is that we're using a streambuilder, so we can't just change the list
              //   _queueService.reorderByOffset(indexBeforeDrag, indexAfterDrag);
              // });

              int indexBeforeDrag = 0;
              int indexAfterDrag = 0;
              List<QueueItem>? listToUseBefore = _queue;
              List<QueueItem>? listToUseAfter = _queue;
              
              if (offsetBeforeDrag > 0) {
                if (_nextUp!.length > 0 && offsetBeforeDrag <= _nextUp!.length) {
                  indexBeforeDrag = offsetBeforeDrag - 1;
                  listToUseBefore = _nextUp;
                } else {
                  indexBeforeDrag = offsetBeforeDrag - _nextUp!.length - 1;
                  listToUseBefore = _queue;
                }
              } else if (offsetBeforeDrag < 0) {
                indexBeforeDrag = _previousTracks!.length + offsetBeforeDrag;
                listToUseBefore = _previousTracks;
              } else {
                // the current track can't be reordered
                return false;
              }

              if (offsetAfterDrag > 0) {
                if (_nextUp!.length > 0 && offsetAfterDrag <= _nextUp!.length) {
                  indexAfterDrag = offsetAfterDrag - 1;
                  listToUseAfter = _nextUp;
                } else {
                  indexAfterDrag = offsetAfterDrag - _nextUp!.length - 1;
                  listToUseAfter = _queue;
                }
              } else if (offsetAfterDrag < 0) {
                indexAfterDrag = _previousTracks!.length + offsetAfterDrag;
                listToUseAfter = _previousTracks;
              } else {
                // the current track can't be reordered
                return false;
              }

              print("indexBeforeDrag: $indexBeforeDrag");
              print("indexAfterDrag: $indexAfterDrag");

              setState(() {
                final draggedQueueItem = listToUseBefore!.removeAt(indexBeforeDrag);
                listToUseAfter!.insert(indexAfterDrag, draggedQueueItem);
              });

              return true;
            },
            // onReorderDone: (Key item) {
            //   // int newPositionIndex = _indexOfKey(item);
            //   // debugPrint("Reordering finished for ${draggedItem.title}}");
            //   _queueService.reorderByOffset(indexBeforeDrag, indexAfterDrag);
            // },
            child: CustomScrollView(
              controller: widget.scrollController,
              slivers: _contents,
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

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final bool controls;
  final double height;

  SectionHeaderDelegate(this.title, [this.controls = false, this.height = 50]);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          child: Text(title),
        ),
        if (controls)
          Row(
            children: [
              IconButton(
                icon: const Icon(TablerIcons.arrows_shuffle),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(TablerIcons.repeat),
                onPressed: () {},
              ),
            ],
          )
      ],
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
