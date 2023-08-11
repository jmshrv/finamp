import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

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
    this.playbackPosition,
    this.queueInfo,
  );

  final MediaState mediaState;
  final Duration playbackPosition;
  final QueueInfo queueInfo;
}

class QueueList extends StatefulWidget {
  const QueueList(
      {Key? key, required this.scrollController, required this.nextUpHeaderKey})
      : super(key: key);

  final ScrollController scrollController;
  final GlobalKey nextUpHeaderKey;

  @override
  State<QueueList> createState() => _QueueListState();

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
}

void scrollToKey({
  required GlobalKey key,
  Duration? duration,
}) {
  if (duration == null) {
    Scrollable.ensureVisible(
      key.currentContext!,
    );
  } else {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: duration,
      curve: Curves.easeOut,
    );
  }
}

class _QueueListState extends State<QueueList> {
  final _queueService = GetIt.instance<QueueService>();

  QueueItemSource? _source;

  late List<Widget> _contents;

  @override
  void initState() {
    super.initState();

    _queueService.getQueueStream().listen((queueInfo) {
      _source = queueInfo.source;
    });

    _source = _queueService.getQueue().source;

    _contents = <Widget>[
      // const SliverPadding(padding: EdgeInsets.only(top: 0)),
      // Previous Tracks
      SliverList.list(
        children: const [],
      ),
      // Current Track
      SliverAppBar(
          key: UniqueKey(),
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
              title: Text("Unknown song"),
              subtitle: Text("Unknown artist"),
              onTap: () {})),
      SliverPersistentHeader(
          delegate: SectionHeaderDelegate(
        title: const Text("Queue"),
        nextUpHeaderKey: widget.nextUpHeaderKey,
      )),
      // Queue
      SliverList.list(
        key: widget.nextUpHeaderKey,
        children: const [],
      ),
    ];

    // call function after 2 seconds
    Future.delayed(const Duration(milliseconds: 50), () {
      // setState(() {});
      // widget.scrollDown();
      scrollToCurrentTrack();
    });
  }

  void scrollToCurrentTrack() {
    // dynamic box = currentTrackKey.currentContext!.findRenderObject();
    // Offset position = box; //this is global position
    // double y = position.dy;

    // widget.scrollController.animateTo(
    //   y,
    //   // scrollController.position.maxScrollExtent,
    //   duration: Duration(seconds: 2),
    //   curve: Curves.fastOutSlowIn,
    // );
    if (widget.nextUpHeaderKey.currentContext != null) {
      Scrollable.ensureVisible(
        widget.nextUpHeaderKey.currentContext!,
        // duration: const Duration(milliseconds: 200),
        // curve: Curves.decelerate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _contents = <Widget>[
      // const SliverPadding(padding: EdgeInsets.only(top: 0)),
      // Previous Tracks
      const PreviousTracksList(),
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
        sliver: SliverPersistentHeader(
          delegate: SectionHeaderDelegate(
            title: const Text("Recently Played"),
            height: 30.0,
            nextUpHeaderKey: widget.nextUpHeaderKey,
          ),
        ),
      ),
      CurrentTrack(
        key: UniqueKey(),
      ),
      // next up
      SliverToBoxAdapter(
        key: widget.nextUpHeaderKey,
      ),
      StreamBuilder(
        stream: _queueService.getQueueStream(),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.nextUp.isNotEmpty) {
            return SliverPadding(
              // key: widget.nextUpHeaderKey,
              padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
              sliver: SliverPersistentHeader(
                delegate: SectionHeaderDelegate(
                  title: const Text("Next Up"),
                  height: 30.0,
                  nextUpHeaderKey: widget.nextUpHeaderKey,
                ), // _source != null ? "Playing from ${_source?.name}" : "Queue",
              ),
            );
          } else {
            return const SliverToBoxAdapter();
          }
        },
      ),
      const NextUpTracksList(),
      SliverPadding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
        sliver: SliverPersistentHeader(
          delegate: SectionHeaderDelegate(
            title: Row(
              children: [
                const Text("Playing from "),
                Text(_source?.name ?? "Unknown",
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            // _source != null ? "Playing from ${_source?.name}" : "Queue",
            controls: true,
            nextUpHeaderKey: widget.nextUpHeaderKey,
          ),
        ),
      ),
      // Queue
      const QueueTracksList(),
    ];

    return CustomScrollView(
      controller: widget.scrollController,
      slivers: _contents,
    );
  }
}

Future<dynamic> showQueueBottomSheet(BuildContext context) {
  GlobalKey nextUpHeaderKey = GlobalKey();

  return showModalBottomSheet(
    // showDragHandle: true,
    useSafeArea: true,
    enableDrag: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
    ),
    context: context,
    builder: (context) {
      return DraggableScrollableSheet(
        snap: false,
        snapAnimationDuration: const Duration(milliseconds: 200),
        initialChildSize: 0.92,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 3.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3.5),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Queue",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend Deca',
                        fontSize: 18,
                        fontWeight: FontWeight.w300)),
                const SizedBox(height: 20),
                Expanded(
                  child: QueueList(
                    scrollController: scrollController,
                    nextUpHeaderKey: nextUpHeaderKey,
                  ),
                ),
              ],
            ),
            //TODO fade this out if the key is visible
            floatingActionButton: FloatingActionButton(
                onPressed: () => scrollToKey(
                    key: nextUpHeaderKey,
                    duration: const Duration(milliseconds: 500)),
                backgroundColor: const Color.fromRGBO(188, 136, 86, 0.60),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    TablerIcons.focus_2,
                    size: 28.0,
                  ),
                )),
          );
          // )
          // return QueueList(
          //   scrollController: scrollController,
          // );
        },
      );
    },
  );
}

class PreviousTracksList extends StatefulWidget {
  const PreviousTracksList({
    Key? key,
  }) : super(key: key);

  @override
  State<PreviousTracksList> createState() => _PreviousTracksListState();
}

class _PreviousTracksListState extends State<PreviousTracksList>
    with TickerProviderStateMixin {
  final _queueService = GetIt.instance<QueueService>();
  List<QueueItem>? _previousTracks;

  @override
  Widget build(context) {
    return StreamBuilder<QueueInfo>(
      // stream: AudioService.queueStream,
      // stream: Rx.combineLatest2<MediaState, QueueInfo, _QueueListStreamState>(
      //     mediaStateStream,
      //     _queueService.getQueueStream(),
      //     (a, b) => _QueueListStreamState(a, b)),
      stream: _queueService.getQueueStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _previousTracks ??= snapshot.data!.previousTracks;

          return SliverReorderableList(
            onReorder: (oldIndex, newIndex) {
              int draggingOffset = -(_previousTracks!.length - oldIndex);
              int newPositionOffset = -(_previousTracks!.length - newIndex);
              print("$draggingOffset -> $newPositionOffset");
              if (mounted) {
                setState(() {
                  // temporarily update internal queue
                  QueueItem tmp = _previousTracks!.removeAt(oldIndex);
                  _previousTracks!.insert(
                      newIndex < oldIndex ? newIndex : newIndex - 1, tmp);
                  // update external queue to commit changes, results in a rebuild
                  _queueService.reorderByOffset(
                      draggingOffset, newPositionOffset);
                });
              }
            },
            itemCount: _previousTracks?.length ?? 0,
            itemBuilder: (context, index) {
              final item = _previousTracks![index];
              final actualIndex = index;
              final indexOffset = -((_previousTracks?.length ?? 0) - index);
              return QueueListItem(
                key: ValueKey(_previousTracks![actualIndex].id),
                item: item,
                listIndex: index,
                actualIndex: actualIndex,
                indexOffset: indexOffset,
                subqueue: _previousTracks!,
                allowReorder:
                    _queueService.playbackOrder == PlaybackOrder.linear,
                onTap: () async {
                  await _queueService.skipByOffset(indexOffset);
                },
                isCurrentTrack: false,
              );
            },
          );
        } else {
          return SliverList(delegate: SliverChildListDelegate([]));
        }
      },
    );
  }
}

class NextUpTracksList extends StatefulWidget {
  const NextUpTracksList({
    Key? key,
  }) : super(key: key);

  @override
  State<NextUpTracksList> createState() => _NextUpTracksListState();
}

class _NextUpTracksListState extends State<NextUpTracksList> {
  final _queueService = GetIt.instance<QueueService>();
  List<QueueItem>? _nextUp;

  @override
  Widget build(context) {
    return StreamBuilder<QueueInfo>(
      // stream: AudioService.queueStream,
      stream: _queueService.getQueueStream(),
      // stream: _queueService.getQueueStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _nextUp ??= snapshot.data!.nextUp;

          return SliverPadding(
              padding: const EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0),
              sliver: SliverReorderableList(
                onReorder: (oldIndex, newIndex) {
                  int draggingOffset = oldIndex + 1;
                  int newPositionOffset = newIndex + 1;
                  print("$draggingOffset -> $newPositionOffset");
                  if (mounted) {
                    setState(() {
                      // temporarily update internal queue
                      QueueItem tmp = _nextUp!.removeAt(oldIndex);
                      _nextUp!.insert(
                          newIndex < oldIndex ? newIndex : newIndex - 1, tmp);
                      // update external queue to commit changes, results in a rebuild
                      _queueService.reorderByOffset(
                          draggingOffset, newPositionOffset);
                    });
                  }
                },
                itemCount: _nextUp?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = _nextUp![index];
                  final actualIndex = index;
                  final indexOffset = index + 1;
                  return QueueListItem(
                    key: ValueKey(_nextUp![actualIndex].id),
                    item: item,
                    listIndex: index,
                    actualIndex: actualIndex,
                    indexOffset: indexOffset,
                    subqueue: _nextUp!,
                    onTap: () async {
                      await _queueService.skipByOffset(indexOffset);
                    },
                    isCurrentTrack: false,
                  );
                },
              ));
        } else {
          return SliverList(delegate: SliverChildListDelegate([]));
        }
      },
    );
  }
}

class QueueTracksList extends StatefulWidget {
  const QueueTracksList({
    Key? key,
  }) : super(key: key);

  @override
  State<QueueTracksList> createState() => _QueueTracksListState();
}

class _QueueTracksListState extends State<QueueTracksList> {
  final _queueService = GetIt.instance<QueueService>();
  List<QueueItem>? _queue;
  List<QueueItem>? _nextUp;

  @override
  Widget build(context) {
    return StreamBuilder<QueueInfo>(
      // stream: AudioService.queueStream,
      stream: _queueService.getQueueStream(),
      // stream: _queueService.getQueueStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _queue ??= snapshot.data!.queue;
          _nextUp ??= snapshot.data!.nextUp;

          return SliverReorderableList(
            onReorder: (oldIndex, newIndex) {
              int draggingOffset = oldIndex + (_nextUp?.length ?? 0) + 1;
              int newPositionOffset = newIndex + (_nextUp?.length ?? 0) + 1;
              print("$draggingOffset -> $newPositionOffset");
              if (mounted) {
                setState(() {
                  // temporarily update internal queue
                  QueueItem tmp = _queue!.removeAt(oldIndex);
                  _queue!.insert(
                      newIndex < oldIndex ? newIndex : newIndex - 1, tmp);
                  // update external queue to commit changes, results in a rebuild
                  _queueService.reorderByOffset(
                      draggingOffset, newPositionOffset);
                });
              }
            },
            itemCount: _queue?.length ?? 0,
            itemBuilder: (context, index) {
              final item = _queue![index];
              final actualIndex = index;
              final indexOffset = index + 1;
              return QueueListItem(
                key: ValueKey(_queue![actualIndex].id),
                item: item,
                listIndex: index,
                actualIndex: actualIndex,
                indexOffset: indexOffset,
                subqueue: _queue!,
                allowReorder:
                    _queueService.playbackOrder == PlaybackOrder.linear,
                onTap: () async {
                  await _queueService.skipByOffset(indexOffset);
                },
                isCurrentTrack: false,
              );
            },
          );
        } else {
          return SliverList(delegate: SliverChildListDelegate([]));
        }
      },
    );
  }
}

class CurrentTrack extends StatelessWidget {
  const CurrentTrack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(context) {
    final queueService = GetIt.instance<QueueService>();
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    QueueItem? currentTrack;
    MediaState? mediaState;
    Duration? playbackPosition;

    return StreamBuilder<_QueueListStreamState>(
      stream: Rx.combineLatest3<MediaState, Duration, QueueInfo,
              _QueueListStreamState>(
          mediaStateStream,
          AudioService.position
              .startWith(audioHandler.playbackState.value.position),
          queueService.getQueueStream(),
          (a, b, c) => _QueueListStreamState(a, b, c)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          currentTrack = snapshot.data!.queueInfo.currentTrack;
          mediaState = snapshot.data!.mediaState;
          playbackPosition = snapshot.data!.playbackPosition;

          return SliverAppBar(
            // key: currentTrackKey,
            pinned: true,
            collapsedHeight: 70.0,
            expandedHeight: 70.0,
            elevation: 10.0,
            leading: const Padding(
              padding: EdgeInsets.zero,
            ),
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0.0),
            flexibleSpace: Container(
              color: const Color.fromRGBO(0, 0, 0, 1.0),
              // width: 328,
              height: 70.0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration: const ShapeDecoration(
                  color: Color.fromRGBO(188, 136, 86, 0.20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AlbumImage(
                          item: currentTrack!.item.extras?["itemJson"] == null
                              ? null
                              : jellyfin_models.BaseItemDto.fromJson(
                                  currentTrack!.item.extras?["itemJson"]),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        Container(
                            width: 70,
                            height: 70,
                            decoration: const ShapeDecoration(
                              shape: Border(),
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                            ),
                            child: IconButton(
                              onPressed: () {
                                audioHandler.togglePlayback();
                              },
                              icon: mediaState!.playbackState.playing
                                  ? const Icon(
                                      TablerIcons.player_pause,
                                      size: 32,
                                    )
                                  : const Icon(
                                      TablerIcons.player_play,
                                      size: 32,
                                    ),
                            )),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            // child: RepaintBoundary(
                            child: Container(
                              width: 320 *
                                  (playbackPosition!.inMilliseconds /
                                      (mediaState?.mediaItem?.duration ??
                                              const Duration(seconds: 0))
                                          .inMilliseconds),
                              height: 70.0,
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(188, 136, 86, 0.75),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            // ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 70,
                                width: 130,
                                padding:
                                    const EdgeInsets.only(left: 12, right: 4),
                                // child: Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentTrack?.item.title ?? 'Unknown',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Lexend Deca',
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      processArtist(
                                          currentTrack!.item.artist, context),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.85),
                                          fontSize: 13,
                                          fontFamily: 'Lexend Deca',
                                          fontWeight: FontWeight.w300,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                                // ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // '0:00',
                                        playbackPosition!.inHours >= 1.0
                                            ? "${playbackPosition?.inHours.toString()}:${((playbackPosition?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((playbackPosition?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}"
                                            : "${playbackPosition?.inMinutes.toString()}:${((playbackPosition?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                          fontFamily: 'Lexend Deca',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '/',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                          fontFamily: 'Lexend Deca',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        // '3:44',
                                        (mediaState?.mediaItem?.duration
                                                        ?.inHours ??
                                                    0.0) >=
                                                1.0
                                            ? "${mediaState?.mediaItem?.duration?.inHours.toString()}:${((mediaState?.mediaItem?.duration?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((mediaState?.mediaItem?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}"
                                            : "${mediaState?.mediaItem?.duration?.inMinutes.toString()}:${((mediaState?.mediaItem?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                          fontFamily: 'Lexend Deca',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    // visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      TablerIcons.heart,
                                      size: 32,
                                      color: Colors.white,
                                      weight:
                                          1.5, //TODO weight not working, stroke is too thick for most icons
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    // visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      TablerIcons.dots_vertical,
                                      size: 32,
                                      color: Colors.white,
                                      weight: 1.5,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SliverList(delegate: SliverChildListDelegate([]));
        }
      },
    );
  }
}

class PlaybackBehaviorInfo {
  final PlaybackOrder order;
  final LoopMode loop;

  PlaybackBehaviorInfo(this.order, this.loop);
}

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget title;
  final bool controls;
  final double height;
  final GlobalKey nextUpHeaderKey;

  SectionHeaderDelegate({
    required this.title,
    required this.nextUpHeaderKey,
    this.controls = false,
    this.height = 30.0,
  });

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    final _queueService = GetIt.instance<QueueService>();

    return StreamBuilder(
      stream: Rx.combineLatest2(
          _queueService.getPlaybackOrderStream(),
          _queueService.getLoopModeStream(),
          (a, b) => PlaybackBehaviorInfo(a, b)),
      builder: (context, snapshot) {
        PlaybackBehaviorInfo? info = snapshot.data as PlaybackBehaviorInfo?;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    title,
                  ])),
              if (controls)
                IconButton(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    iconSize: 28.0,
                    icon: info?.order == PlaybackOrder.shuffled
                        ? (const Icon(
                            TablerIcons.arrows_shuffle,
                          ))
                        : (const Icon(
                            TablerIcons.arrows_right,
                          )),
                    color: info?.order == PlaybackOrder.shuffled
                        ? Colors.orange
                        : Colors.white,
                    onPressed: () {
                      _queueService.togglePlaybackOrder();
                      //TODO why is the current track scrolled out of view **after** the queue is updated?
                      Future.delayed(
                          const Duration(milliseconds: 300),
                          () => scrollToKey(
                              key: nextUpHeaderKey,
                              duration: const Duration(milliseconds: 500)));
                      // scrollToKey(key: nextUpHeaderKey, duration: const Duration(milliseconds: 1000));
                    }),
              if (controls)
                IconButton(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  iconSize: 28.0,
                  icon: info?.loop != LoopMode.none
                      ? (info?.loop == LoopMode.one
                          ? (const Icon(
                              TablerIcons.repeat_once,
                            ))
                          : (const Icon(
                              TablerIcons.repeat,
                            )))
                      : (const Icon(
                          TablerIcons.repeat_off,
                        )),
                  color: info?.loop != LoopMode.none
                      ? Colors.orange
                      : Colors.white,
                  onPressed: () => _queueService.toggleLoopMode(),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
