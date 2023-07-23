import 'package:audio_service/audio_service.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

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
              // onReorder: (oldIndex, newIndex) async {
              //   final oldOffset = -((_previousTracks?.length ?? 0) - oldIndex);
              //   final newOffset = -((_previousTracks?.length ?? 0) - newIndex);
              //   // setState(() {
              //   //   // _previousTracks?.insert(newIndex, _previousTracks![oldIndex]);
              //   //   // _previousTracks?.removeAt(oldIndex);
              //   //   int? smallerThanNewIndex;
              //   //   if (oldIndex < newIndex) {
              //   //     // When we're moving an item backwards, we need to reduce
              //   //     // newIndex by 1 to account for there being a new item added
              //   //     // before newIndex.
              //   //     smallerThanNewIndex = newIndex - 1;
              //   //   }
              //   //   final item = _previousTracks?.removeAt(oldIndex);
              //   //   _previousTracks?.insert(smallerThanNewIndex ?? newIndex, item!);
              //   // });
              //   await _queueService.reorderByOffset(oldOffset, newOffset);
              // },
              itemBuilder: (context, index) {
                final item = _previousTracks![index];
                final actualIndex = index;
                final indexOffset = -((_previousTracks?.length ?? 0) - index);
                return Card(
                  key: ValueKey("${_queue![actualIndex].item.id}$actualIndex"),
                  child: DragTarget<QueueItem>(
                    builder: (
                      BuildContext context,
                      List<QueueItem?> candidateData,
                      List<dynamic> rejectedData,
                    ) {
                      return QueueListItem(
                        item: item,
                        actualIndex: actualIndex,
                        indexOffset: indexOffset,
                        subqueue: _previousTracks!,
                        isCurrentTrack: _currentTrack == item,
                      );
                    },
                    onWillAccept: (data) {
                      return true;
                    },
                    onAccept: (data) async {

                      int oldOffset = 0;
                      int newOffset = 0;

                      int oldListIndex = 0;
                      const newListIndex = 0;
                      int oldItemIndex = -1;
                      int newItemIndex = index;

                      // lookup current index of the item belonging to the data
                      if (_nextUp != null && _nextUp!.isNotEmpty) {
                        oldItemIndex = _nextUp!.indexOf(data);
                        oldListIndex = 1;
                      }
                      if (oldItemIndex == -1) {
                        oldItemIndex = _nextUp!.length + _queue!.indexOf(data);
                        oldListIndex = 2;
                      }
                      if (oldItemIndex == -1) {
                        oldItemIndex = _previousTracks!.indexOf(data);
                        oldListIndex = 0;
                      }

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

                      // new index
                      if (newListIndex == 0) {
                        // previous tracks
                        newOffset = -((_previousTracks?.length ?? 0) - newItemIndex);
                      } else if (
                        newListIndex == 1 &&
                        oldListIndex == 2 // tracks can't be moved *to* next up, only *within* next up or *out of* next up
                      ) {
                        // next up
                        newOffset = newItemIndex + 1;
                      } else if (newListIndex == 2) {
                        // queue
                        newOffset = newItemIndex + _nextUp!.length + 1;
                      } else {
                        newOffset = oldOffset;
                      }
                      
                      if (oldOffset != newOffset) {
                        // setState(() {
                        //   var movedItem = _contents[oldListIndex].children!.removeAt(oldItemIndex);
                        //   _contents[newListIndex].children!.insert(newItemIndex, movedItem);
                        // });
                        await _queueService.reorderByOffset(oldOffset, newOffset);
                      }
                      
                      // setState(() {
                      //   _queue?.insert(index, data);
                      // });
                    },
                  )
                );
              },
            ),
            SliverList.list(
              children: [
                DragTarget<QueueItem>(
                builder: (
                  BuildContext context,
                  List<QueueItem?> candidateData,
                  List<dynamic> rejectedData,
                ) {
                  return Container(height: 60.0);
                },
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (data) async {
                  int oldOffset = 0;
                  int newOffset = 0;

                  int oldListIndex = 0;
                  const newListIndex = 2;
                  int oldItemIndex = -1;
                  int newItemIndex = 0;

                  // lookup current index of the item belonging to the data
                  if (_nextUp != null && _nextUp!.isNotEmpty) {
                    oldItemIndex = _nextUp!.indexOf(data);
                    oldListIndex = 1;
                  }
                  if (oldItemIndex == -1) {
                    oldItemIndex = _nextUp!.length + _queue!.indexOf(data);
                    oldListIndex = 2;
                  }
                  if (oldItemIndex == -1) {
                    oldItemIndex = _previousTracks!.indexOf(data);
                    oldListIndex = 0;
                  }

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

                  // new index
                  if (newListIndex == 0) {
                    // previous tracks
                    newOffset = -((_previousTracks?.length ?? 0) - newItemIndex);
                  } else if (
                    newListIndex == 1 &&
                    oldListIndex == 2 // tracks can't be moved *to* next up, only *within* next up or *out of* next up
                  ) {
                    // next up
                    newOffset = newItemIndex + 1;
                  } else if (newListIndex == 2) {
                    // queue
                    newOffset = newItemIndex + _nextUp!.length + 1;
                  } else {
                    newOffset = oldOffset;
                  }
                  
                  if (oldOffset != newOffset) {
                    // setState(() {
                    //   var movedItem = _contents[oldListIndex].children!.removeAt(oldItemIndex);
                    //   _contents[newListIndex].children!.insert(newItemIndex, movedItem);
                    // });
                    await _queueService.reorderByOffset(oldOffset, newOffset);
                  }
                  // setState(() {
                  //   _queue?.insert(index, data);
                  // });
                },
              )]
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
            SliverList.list(
              children: [
                DragTarget<QueueItem>(
                builder: (
                  BuildContext context,
                  List<QueueItem?> candidateData,
                  List<dynamic> rejectedData,
                ) {
                  return Container(height: 20.0);
                },
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (data) async {
                  int oldOffset = 0;
                  int newOffset = 0;

                  int oldListIndex = 0;
                  const newListIndex = 2;
                  int oldItemIndex = -1;
                  int newItemIndex = 0;

                  // lookup current index of the item belonging to the data
                  if (_nextUp != null && _nextUp!.isNotEmpty) {
                    oldItemIndex = _nextUp!.indexOf(data);
                    oldListIndex = 1;
                  }
                  if (oldItemIndex == -1) {
                    oldItemIndex = _nextUp!.length + _queue!.indexOf(data);
                    oldListIndex = 2;
                  }
                  if (oldItemIndex == -1) {
                    oldItemIndex = _previousTracks!.indexOf(data);
                    oldListIndex = 0;
                  }

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

                  // new index
                  if (newListIndex == 0) {
                    // previous tracks
                    newOffset = -((_previousTracks?.length ?? 0) - newItemIndex) + 1;
                  } else if (
                    newListIndex == 1 &&
                    oldListIndex == 2 // tracks can't be moved *to* next up, only *within* next up or *out of* next up
                  ) {
                    // next up
                    newOffset = newItemIndex;
                  } else if (newListIndex == 2) {
                    // queue
                    newOffset = newItemIndex + _nextUp!.length;
                  } else {
                    newOffset = oldOffset;
                  }
                  
                  if (oldOffset != newOffset) {
                    // setState(() {
                    //   var movedItem = _contents[oldListIndex].children!.removeAt(oldItemIndex);
                    //   _contents[newListIndex].children!.insert(newItemIndex, movedItem);
                    // });
                    await _queueService.reorderByOffset(oldOffset, newOffset);
                  }
                  // setState(() {
                  //   _queue?.insert(index, data);
                  // });
                },
              )]
            ),
            // Queue
            SliverList.builder(
              itemCount: _queue?.length ?? 0,
              // onReorder: (oldIndex, newIndex) async {
              //   final oldOffset = oldIndex + 1;
              //   final newOffset = newIndex + 1;
              //   setState(() {
              //     // _queue?.insert(newIndex, _queue![oldIndex]);
              //     // _queue?.removeAt(oldIndex);
              //     int? smallerThanNewIndex;
              //     if (oldIndex < newIndex) {
              //       // When we're moving an item backwards, we need to reduce
              //       // newIndex by 1 to account for there being a new item added
              //       // before newIndex.
              //       smallerThanNewIndex = newIndex - 1;
              //     }
              //     final item = _queue?.removeAt(oldIndex);
              //     _queue?.insert(smallerThanNewIndex ?? newIndex, item!);
              //   });
              //   await _queueService.reorderByOffset(oldOffset, newOffset);
              // },
              itemBuilder: (context, index) {
                final item = _queue![index];
                final actualIndex = index;
                final indexOffset = index + 1;
                return Card(
                    key: ValueKey("${_queue![actualIndex].item.id}$actualIndex"),
                    child: DragTarget<QueueItem>(
                      builder: (
                        BuildContext context,
                        List<QueueItem?> candidateData,
                        List<dynamic> rejectedData,
                      ) {
                        if (candidateData.isNotEmpty && candidateData.first != null && candidateData.first != item) {
                          return Column(
                            children: [
                              QueueListItemGhost(
                                item: candidateData.first!,
                                isCurrentTrack: _currentTrack == item,
                              ),
                              QueueListItem(
                                item: item,
                                actualIndex: actualIndex,
                                indexOffset: indexOffset,
                                subqueue: _queue!,
                                isCurrentTrack: _currentTrack == item,
                              ),
                            ],
                          );
                        } else {
                          return QueueListItem(
                            item: item,
                            actualIndex: actualIndex,
                            indexOffset: indexOffset,
                            subqueue: _queue!,
                            isCurrentTrack: _currentTrack == item,
                          );
                        }
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                      onAccept: (data) async {
                        int oldOffset = 0;
                        int newOffset = 0;

                        int oldListIndex = 0;
                        const newListIndex = 2;
                        int oldItemIndex = -1;
                        int newItemIndex = index;

                        // lookup current index of the item belonging to the data
                        if (_nextUp != null && _nextUp!.isNotEmpty) {
                          oldItemIndex = _nextUp!.indexOf(data);
                          oldListIndex = 1;
                        }
                        if (oldItemIndex == -1) {
                          oldItemIndex = _nextUp!.length + _queue!.indexOf(data);
                          oldListIndex = 2;
                        }
                        if (oldItemIndex == -1) {
                          oldItemIndex = _previousTracks!.indexOf(data);
                          oldListIndex = 0;
                        }
                        if (oldItemIndex == -1) {
                          // item probably became current track
                          return;
                        }

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

                        // new index
                        if (newListIndex == 0) {
                          // previous tracks
                          newOffset = -((_previousTracks?.length ?? 0) - newItemIndex) + 1;
                        } else if (
                          newListIndex == 1 &&
                          oldListIndex == 2 // tracks can't be moved *to* next up, only *within* next up or *out of* next up
                        ) {
                          // next up
                          newOffset = newItemIndex + 1;
                        } else if (newListIndex == 2) {
                          // queue
                          newOffset = newItemIndex + _nextUp!.length + 1;
                        } else {
                          newOffset = oldOffset;
                        }
                        
                        if (oldOffset != newOffset) {
                          // setState(() {
                          //   var movedItem = _contents[oldListIndex].children!.removeAt(oldItemIndex);
                          //   _contents[newListIndex].children!.insert(newItemIndex, movedItem);
                          // });
                          await _queueService.reorderByOffset(oldOffset, newOffset);
                        }
                        // setState(() {
                        //   _queue?.insert(index, data);
                        // });
                      },
                    )
                  );
              },
            ),
          ];

          return CustomScrollView(
            controller: widget.scrollController,
            slivers: _contents,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
      int newListIndex) async {
    int oldOffset = 0;
    int newOffset = 0;

    // old index
    if (oldListIndex == 0) {
      // previous tracks
      oldOffset = -((_previousTracks?.length ?? 0) - oldItemIndex);
    } else if (oldListIndex == 2) {
      // next up
      oldOffset = oldItemIndex + 1;
    } else if (oldListIndex == _contents.length - 1) {
      // queue
      oldOffset = oldItemIndex + _nextUp!.length + 1;
    }

    // new index
    if (newListIndex == 0) {
      // previous tracks
      newOffset = -((_previousTracks?.length ?? 0) - newItemIndex);
    } else if (newListIndex == 2 &&
            oldListIndex ==
                2 // tracks can't be moved *to* next up, only *within* next up or *out of* next up
        ) {
      // next up
      newOffset = newItemIndex + 1;
    } else if (newListIndex == _contents.length - 1) {
      // queue
      newOffset = newItemIndex + _nextUp!.length + 1;
    } else {
      newOffset = oldOffset;
    }

    if (oldOffset != newOffset) {
      // setState(() {
      //   var movedItem = _contents[oldListIndex].children!.removeAt(oldItemIndex);
      //   _contents[newListIndex].children!.insert(newItemIndex, movedItem);
      // });
      await _queueService.reorderByOffset(oldOffset, newOffset);
    }
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    return false;
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
