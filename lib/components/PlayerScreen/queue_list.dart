import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_button.dart';
import 'package:finamp/components/AlbumScreen/song_menu.dart';
import 'package:finamp/components/AlbumScreen/track_list_tile.dart';
import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:finamp/components/print_duration.dart';
import 'package:finamp/main.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/screens/blurred_player_screen_background.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../../services/current_album_image_provider.dart';
import '../../services/media_state_stream.dart';
import '../../services/music_player_background_task.dart';
import '../../services/process_artist.dart';
import '../../services/queue_service.dart';
import '../album_image.dart';
import '../padded_custom_scrollview.dart';
import '../themed_bottom_sheet.dart';
import 'queue_source_helper.dart';

class _QueueListStreamState {
  _QueueListStreamState(
    this.mediaState,
    this.queueInfo,
  );

  final MediaState mediaState;
  final FinampQueueInfo? queueInfo;
}

class QueueList extends StatefulWidget {
  static const routeName = "/queue";

  const QueueList({
    Key? key,
    required this.scrollController,
    required this.previousTracksHeaderKey,
    required this.currentTrackKey,
    required this.nextUpHeaderKey,
    required this.queueHeaderKey,
    required this.jumpToCurrentKey,
  }) : super(key: key);

  final ScrollController scrollController;
  final GlobalKey previousTracksHeaderKey;
  final Key currentTrackKey;
  final GlobalKey nextUpHeaderKey;
  final GlobalKey queueHeaderKey;
  final GlobalKey<JumpToCurrentButtonState> jumpToCurrentKey;

  @override
  State<QueueList> createState() => _QueueListState();

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
}

void scrollToKey({
  required GlobalKey key,
  required Duration duration,
}) {
  var queueList =
      key.currentContext?.findAncestorStateOfType<_QueueListState>();
  if (queueList != null && queueList.widget.previousTracksHeaderKey == key) {
    Future.delayed(Duration(milliseconds: duration.inMilliseconds + 10), () {
      queueList._currentTrackScroll = queueList.widget.scrollController.offset;
    });
  }
  Scrollable.ensureVisible(
    key.currentContext!,
    duration: duration,
    curve: Curves.easeInOutCubic,
  );
}

class _QueueListState extends State<QueueList> {
  final _queueService = GetIt.instance<QueueService>();

  QueueItemSource? _source;

  double _currentTrackScroll = 0;

  late List<Widget> _contents;
  BehaviorSubject<bool> isRecentTracksExpanded = BehaviorSubject.seeded(false);

  @override
  void initState() {
    super.initState();

    _queueService.getQueueStream().listen((queueInfo) {
      _source = queueInfo?.source;
    });

    _source = _queueService.getQueue().source;

    _contents = <Widget>[];

    widget.scrollController.addListener(() {
      final screenSize = MediaQuery.of(context).size;
      double offset = widget.scrollController.offset - _currentTrackScroll;
      int jumpDirection = 0;
      if (offset > screenSize.height * 0.5) {
        jumpDirection = -1;
      } else if (offset < -screenSize.height) {
        jumpDirection = 1;
      }
      widget.jumpToCurrentKey.currentState?.showJumpToTop = jumpDirection;
    });
  }

  @override
  Widget build(BuildContext context) {
    _contents = <Widget>[
      // Previous Tracks
      StreamBuilder<bool>(
          stream: isRecentTracksExpanded,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return PreviousTracksList(
                  previousTracksHeaderKey: widget.previousTracksHeaderKey);
            } else {
              return const SliverToBoxAdapter();
            }
          }),
      SliverPersistentHeader(
          key: widget.previousTracksHeaderKey,
          delegate: PreviousTracksSectionHeader(
            isRecentTracksExpanded: isRecentTracksExpanded,
            previousTracksHeaderKey: widget.previousTracksHeaderKey,
            onTap: () {
              final oldBottomOffset =
                  widget.scrollController.position.extentAfter;
              late StreamSubscription subscription;
              subscription = isRecentTracksExpanded.stream.listen((expanded) {
                final previousTracks = _queueService.getQueue().previousTracks;
                // a random delay isn't a great solution, but I'm not sure how to do this properly
                Future.delayed(Duration(milliseconds: expanded ? 5 : 50), () {
                  _currentTrackScroll = expanded
                      ? 0
                      : widget.scrollController.position.maxScrollExtent -
                          oldBottomOffset;
                  widget.scrollController.jumpTo(
                      widget.scrollController.position.maxScrollExtent -
                          oldBottomOffset -
                          (previousTracks.isNotEmpty ? 100.0 : 0.0));
                });
                subscription.cancel();
              });
              isRecentTracksExpanded.add(!isRecentTracksExpanded.value);
            },
          )),
      CurrentTrack(
        // key: UniqueKey(),
        key: widget.currentTrackKey,
      ),
      // next up
      StreamBuilder(
        key: widget.nextUpHeaderKey,
        stream: _queueService.getQueueStream(),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.nextUp.isNotEmpty) {
            return SliverStickyHeader(
              header: NextUpSectionHeader(
                controls: true,
                nextUpHeaderKey: widget.nextUpHeaderKey,
              ),
              sliver: NextUpTracksList(
                  previousTracksHeaderKey: widget.previousTracksHeaderKey),
            );
          } else {
            return const SliverToBoxAdapter();
          }
        },
      ),
      // Queue
      SliverStickyHeader(
        header: QueueSectionHeader(
          source: _source,
          title: Row(
            children: [
              Text(
                "${AppLocalizations.of(context)!.playingFrom} ",
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
              Flexible(
                child: Text(
                  _source?.name.getLocalized(context) ??
                      AppLocalizations.of(context)!.unknownName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          controls: true,
          nextUpHeaderKey: widget.nextUpHeaderKey,
          queueHeaderKey: widget.queueHeaderKey,
          scrollController: widget.scrollController,
        ),
        sliver: QueueTracksList(
            previousTracksHeaderKey: widget.previousTracksHeaderKey),
      )
    ];

    return ScrollbarTheme(
      data: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary.withOpacity(0.7)),
          trackColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          radius: const Radius.circular(6.0),
          thickness: MaterialStateProperty.all(12.0),
          // thumbVisibility: MaterialStateProperty.all(true),
          trackVisibility: MaterialStateProperty.all(false)),
      child: PaddedCustomScrollview(
        controller: widget.scrollController,
        scrollBehavior: const FinampScrollBehavior(interactive: true),
        physics: const BouncingScrollPhysics(),
        slivers: _contents,
        // Additional padding to allow for the jump to current track button
        bottomPadding: 90.0,
      ),
    );
  }
}

Future<dynamic> showQueueBottomSheet(BuildContext context) {
  GlobalKey previousTracksHeaderKey = GlobalKey();
  Key currentTrackKey = UniqueKey();
  GlobalKey nextUpHeaderKey = GlobalKey();
  GlobalKey queueHeaderKey = GlobalKey();
  GlobalKey<JumpToCurrentButtonState> jumpToCurrentKey = GlobalKey();

  FeedbackHelper.feedback(FeedbackType.impact);

  return showModalBottomSheet(
    // showDragHandle: true,
    useSafeArea: true,
    enableDrag: true,
    isScrollControlled: true,
    routeSettings: const RouteSettings(name: QueueList.routeName),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
    ),
    clipBehavior: Clip.antiAlias,
    context: context,
    builder: (context) {
      return ProviderScope(
          overrides: [
            themeDataProvider.overrideWith((ref) {
              return ref.watch(playerScreenThemeDataProvider) ??
                  FinampTheme.defaultTheme();
            })
          ],
          child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final imageTheme = ref.watch(playerScreenThemeProvider);
            return AnimatedTheme(
              duration: const Duration(milliseconds: 500),
              data: ThemeData(
                colorScheme: imageTheme,
                iconTheme: Theme.of(context).iconTheme.copyWith(
                      color: imageTheme.primary,
                    ),
              ),
              child: DraggableScrollableSheet(
                snap: false,
                snapAnimationDuration: const Duration(milliseconds: 200),
                initialChildSize: 0.92,
                // maxChildSize: 0.92,
                expand: false,
                builder: (context, scrollController) {
                  return Scaffold(
                    body: Stack(
                      children: [
                        if (FinampSettingsHelper
                            .finampSettings.useCoverAsBackground)
                          BlurredPlayerScreenBackground(
                              opacityFactor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? 1.0
                                  : 0.85),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              width: 40,
                              height: 3.5,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color!,
                                borderRadius: BorderRadius.circular(3.5),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(AppLocalizations.of(context)!.queue,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 20),
                            Expanded(
                              child: QueueList(
                                scrollController: scrollController,
                                previousTracksHeaderKey:
                                    previousTracksHeaderKey,
                                currentTrackKey: currentTrackKey,
                                nextUpHeaderKey: nextUpHeaderKey,
                                queueHeaderKey: queueHeaderKey,
                                jumpToCurrentKey: jumpToCurrentKey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    floatingActionButton: JumpToCurrentButton(
                      key: jumpToCurrentKey,
                      previousTracksHeaderKey: previousTracksHeaderKey,
                    ),
                  );
                },
              ),
            );
          }));
    },
  );
}

class JumpToCurrentButton extends StatefulWidget {
  const JumpToCurrentButton({super.key, required this.previousTracksHeaderKey});

  final GlobalKey previousTracksHeaderKey;

  @override
  State<JumpToCurrentButton> createState() => JumpToCurrentButtonState();
}

class JumpToCurrentButtonState extends State<JumpToCurrentButton> {
  int _jumpToCurrentTrackDirection = 0;
  set showJumpToTop(int direction) {
    if (direction != _jumpToCurrentTrackDirection) {
      setState(() {
        _jumpToCurrentTrackDirection = direction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _jumpToCurrentTrackDirection != 0
        ? FloatingActionButton.extended(
            onPressed: () {
              FeedbackHelper.feedback(FeedbackType.impact);
              scrollToKey(
                  key: widget.previousTracksHeaderKey,
                  duration: const Duration(milliseconds: 500));
            },
            backgroundColor: IconTheme.of(context).color!.withOpacity(0.70),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            icon: Icon(
              _jumpToCurrentTrackDirection < 0
                  ? TablerIcons.arrow_bar_to_up
                  : TablerIcons.arrow_bar_to_down,
              size: 28.0,
              color: Colors.white.withOpacity(0.9),
            ),
            label: Text(
              AppLocalizations.of(context)!.scrollToCurrentTrack,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class PreviousTracksList extends StatefulWidget {
  final GlobalKey previousTracksHeaderKey;

  const PreviousTracksList({
    Key? key,
    required this.previousTracksHeaderKey,
  }) : super(key: key);

  @override
  State<PreviousTracksList> createState() => _PreviousTracksListState();
}

class _PreviousTracksListState extends State<PreviousTracksList>
    with TickerProviderStateMixin {
  final _queueService = GetIt.instance<QueueService>();
  List<FinampQueueItem>? _previousTracks;

  @override
  Widget build(context) {
    return StreamBuilder<FinampQueueInfo?>(
      stream: _queueService.getQueueStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _previousTracks ??= snapshot.data!.previousTracks;

          return SliverReorderableList(
            autoScrollerVelocityScalar: 20.0,
            onReorder: (oldIndex, newIndex) {
              int draggingOffset = -(_previousTracks!.length - oldIndex);
              int newPositionOffset = -(_previousTracks!.length - newIndex);
              if (mounted) {
                FeedbackHelper.feedback(FeedbackType.impact);
                setState(() {
                  // temporarily update internal queue
                  FinampQueueItem tmp = _previousTracks!.removeAt(oldIndex);
                  _previousTracks!.insert(
                      newIndex < oldIndex ? newIndex : newIndex - 1, tmp);
                  // update external queue to commit changes, results in a rebuild
                  _queueService.reorderByOffset(
                      draggingOffset, newPositionOffset);
                });
              }
            },
            onReorderStart: (p0) {
              FeedbackHelper.feedback(FeedbackType.selection);
            },
            findChildIndexCallback: (Key key) {
              key = key as GlobalObjectKey;
              final ValueKey<String> valueKey = key.value as ValueKey<String>;
              // search from the back as this is probably more efficient for previous tracks
              final index = _previousTracks!
                  .lastIndexWhere((item) => item.id == valueKey.value);
              if (index == -1) return null;
              return index;
            },
            itemCount: _previousTracks?.length ?? 0,
            itemBuilder: (context, index) {
              final item = _previousTracks![index];
              final actualIndex = index;
              final indexOffset = -((_previousTracks?.length ?? 0) - index);
              return QueueListTile(
                key: ValueKey(item.id),
                item: item.baseItem!,
                listIndex: Future.value(index),
                actualIndex: actualIndex,
                indexOffset: indexOffset,
                isInPlaylist: queueItemInPlaylist(item),
                parentItem: item.source.item,
                allowReorder:
                    _queueService.playbackOrder == FinampPlaybackOrder.linear,
                onTap: (bool playable) async {
                  FeedbackHelper.feedback(FeedbackType.selection);
                  await _queueService.skipByOffset(indexOffset);
                  scrollToKey(
                      key: widget.previousTracksHeaderKey,
                      duration: const Duration(milliseconds: 500));
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
  final GlobalKey previousTracksHeaderKey;

  const NextUpTracksList({
    Key? key,
    required this.previousTracksHeaderKey,
  }) : super(key: key);

  @override
  State<NextUpTracksList> createState() => _NextUpTracksListState();
}

class _NextUpTracksListState extends State<NextUpTracksList> {
  final _queueService = GetIt.instance<QueueService>();
  List<FinampQueueItem>? _nextUp;

  @override
  Widget build(context) {
    return MenuMask(
      height: 131.0,
      child: StreamBuilder<FinampQueueInfo?>(
        stream: _queueService.getQueueStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _nextUp ??= snapshot.data!.nextUp;

            return SliverPadding(
                padding: const EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0),
                sliver: SliverReorderableList(
                  autoScrollerVelocityScalar: 20.0,
                  onReorder: (oldIndex, newIndex) {
                    int draggingOffset = oldIndex + 1;
                    int newPositionOffset = newIndex + 1;
                    if (mounted) {
                      FeedbackHelper.feedback(FeedbackType.impact);
                      setState(() {
                        // temporarily update internal queue
                        FinampQueueItem tmp = _nextUp!.removeAt(oldIndex);
                        _nextUp!.insert(
                            newIndex < oldIndex ? newIndex : newIndex - 1, tmp);
                        // update external queue to commit changes, results in a rebuild
                        _queueService.reorderByOffset(
                            draggingOffset, newPositionOffset);
                      });
                    }
                  },
                  onReorderStart: (p0) {
                    FeedbackHelper.feedback(FeedbackType.selection);
                  },
                  findChildIndexCallback: (Key key) {
                    key = key as GlobalObjectKey;
                    final ValueKey<String> valueKey =
                        key.value as ValueKey<String>;
                    final index = _nextUp!
                        .indexWhere((item) => item.id == valueKey.value);
                    if (index == -1) return null;
                    return index;
                  },
                  itemCount: _nextUp?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = _nextUp![index];
                    final actualIndex = index;
                    final indexOffset = index + 1;
                    return QueueListTile(
                      key: ValueKey(item.id),
                      item: item.baseItem!,
                      listIndex: Future.value(index),
                      actualIndex: actualIndex,
                      indexOffset: indexOffset,
                      isInPlaylist: queueItemInPlaylist(item),
                      parentItem: item.source.item,
                      allowReorder: _queueService.playbackOrder ==
                          FinampPlaybackOrder.linear,
                      onTap: (bool playable) async {
                        FeedbackHelper.feedback(FeedbackType.selection);
                        await _queueService.skipByOffset(indexOffset);
                        scrollToKey(
                            key: widget.previousTracksHeaderKey,
                            duration: const Duration(milliseconds: 500));
                      },
                      isCurrentTrack: false,
                    );
                  },
                ));
          } else {
            return SliverList(delegate: SliverChildListDelegate([]));
          }
        },
      ),
    );
  }
}

class QueueTracksList extends StatefulWidget {
  final GlobalKey previousTracksHeaderKey;

  const QueueTracksList({
    Key? key,
    required this.previousTracksHeaderKey,
  }) : super(key: key);

  @override
  State<QueueTracksList> createState() => _QueueTracksListState();
}

class _QueueTracksListState extends State<QueueTracksList> {
  final _queueService = GetIt.instance<QueueService>();
  List<FinampQueueItem>? _queue;
  List<FinampQueueItem>? _nextUp;

  @override
  Widget build(context) {
    return MenuMask(
      height: 131.0,
      child: StreamBuilder<FinampQueueInfo?>(
        stream: _queueService.getQueueStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _queue ??= snapshot.data!.queue;
            _nextUp ??= snapshot.data!.nextUp;

            return SliverReorderableList(
              autoScrollerVelocityScalar: 20.0,
              onReorder: (oldIndex, newIndex) {
                int draggingOffset = oldIndex + (_nextUp?.length ?? 0) + 1;
                int newPositionOffset = newIndex + (_nextUp?.length ?? 0) + 1;
                print("$draggingOffset -> $newPositionOffset");
                if (mounted) {
                  // update external queue to commit changes, but don't await it
                  _queueService.reorderByOffset(
                      draggingOffset, newPositionOffset);
                  FeedbackHelper.feedback(FeedbackType.impact);
                  setState(() {
                    // temporarily update internal queue
                    FinampQueueItem tmp = _queue!.removeAt(oldIndex);
                    _queue!.insert(
                        newIndex < oldIndex ? newIndex : newIndex - 1, tmp);
                  });
                }
              },
              onReorderStart: (p0) {
                FeedbackHelper.feedback(FeedbackType.selection);
              },
              itemCount: _queue?.length ?? 0,
              findChildIndexCallback: (Key key) {
                key = key as GlobalObjectKey;
                final ValueKey<String> valueKey = key.value as ValueKey<String>;
                final index =
                    _queue!.indexWhere((item) => item.id == valueKey.value);
                if (index == -1) return null;
                return index;
              },
              itemBuilder: (context, index) {
                final item = _queue![index];
                final actualIndex = index;
                final indexOffset = index + _nextUp!.length + 1;

                return QueueListTile(
                  key: ValueKey(item.id),
                  item: item.baseItem!,
                  listIndex: Future.value(index),
                  actualIndex: actualIndex,
                  indexOffset: indexOffset,
                  isInPlaylist: queueItemInPlaylist(item),
                  parentItem: item.source.item,
                  allowReorder:
                      _queueService.playbackOrder == FinampPlaybackOrder.linear,
                  onTap: (bool playable) async {
                    FeedbackHelper.feedback(FeedbackType.selection);
                    await _queueService.skipByOffset(indexOffset);
                    scrollToKey(
                        key: widget.previousTracksHeaderKey,
                        duration: const Duration(milliseconds: 500));
                  },
                  isCurrentTrack: false,
                );
              },
            );
          } else {
            return SliverList(delegate: SliverChildListDelegate([]));
          }
        },
      ),
    );
  }
}

class CurrentTrack extends StatefulWidget {
  const CurrentTrack({
    Key? key,
  }) : super(key: key);

  @override
  State<CurrentTrack> createState() => _CurrentTrackState();
}

class _CurrentTrackState extends State<CurrentTrack> {
  late QueueService _queueService;
  late MusicPlayerBackgroundTask _audioHandler;

  @override
  void initState() {
    super.initState();
    _queueService = GetIt.instance<QueueService>();
    _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  }

  @override
  Widget build(context) {
    FinampQueueItem? currentTrack;
    MediaState? mediaState;
    Duration? playbackPosition;

    return StreamBuilder<_QueueListStreamState>(
      stream: Rx.combineLatest2<MediaState, FinampQueueInfo?,
              _QueueListStreamState>(
          mediaStateStream,
          _queueService.getQueueStream(),
          (a, b) => _QueueListStreamState(a, b)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          currentTrack = snapshot.data!.queueInfo?.currentTrack;
          mediaState = snapshot.data!.mediaState;

          final currentTrackBaseItem = jellyfin_models.BaseItemDto.fromJson(
              currentTrack!.item.extras?["itemJson"]);

          const horizontalPadding = 8.0;
          const albumImageSize = 70.0;

          return SliverAppBar(
            pinned: true,
            collapsedHeight: 70.0,
            expandedHeight: 70.0,
            elevation: 10.0,
            leading: const Padding(
              padding: EdgeInsets.zero,
            ),
            forceMaterialTransparency: true,
            flexibleSpace: Container(
              // width: 58,
              height: albumImageSize,
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Color.alphaBlend(
                      Theme.of(context).brightness == Brightness.dark
                          ? IconTheme.of(context).color!.withOpacity(0.35)
                          : IconTheme.of(context).color!.withOpacity(0.65),
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
                          borderRadius: BorderRadius.zero,
                          imageListenable: currentAlbumImageProvider,
                        ),
                        Container(
                            width: albumImageSize,
                            height: albumImageSize,
                            decoration: const ShapeDecoration(
                              shape: Border(),
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                            ),
                            child: IconButton(
                              onPressed: () {
                                FeedbackHelper.feedback(FeedbackType.success);
                                _audioHandler.togglePlayback();
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
                              color: Colors.white,
                            )),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: StreamBuilder<Duration>(
                                stream: AudioService.position.startWith(
                                    _audioHandler.playbackState.value.position),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    playbackPosition = snapshot.data;
                                    final screenSize =
                                        MediaQuery.of(context).size;
                                    return Container(
                                      // rather hacky workaround, using LayoutBuilder would be nice but I couldn't get it to work...
                                      width: (screenSize.width -
                                              2 * horizontalPadding -
                                              albumImageSize) *
                                          ((playbackPosition?.inMilliseconds ??
                                                  0) /
                                              (mediaState?.mediaItem
                                                          ?.duration ??
                                                      const Duration(
                                                          seconds: 0))
                                                  .inMilliseconds),
                                      height: 70.0,
                                      decoration: ShapeDecoration(
                                        color: IconTheme.of(context)
                                            .color!
                                            .withOpacity(0.75),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: albumImageSize,
                                  padding:
                                      const EdgeInsets.only(left: 12, right: 4),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentTrack?.item.title ??
                                            AppLocalizations.of(context)!
                                                .unknownName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              processArtist(
                                                  currentTrack!.item.artist,
                                                  context),
                                              style: TextStyle(
                                                  color: (Colors.white)
                                                      .withOpacity(0.85),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              StreamBuilder<Duration>(
                                                  stream: AudioService.position
                                                      .startWith(_audioHandler
                                                          .playbackState
                                                          .value
                                                          .position),
                                                  builder: (context, snapshot) {
                                                    final TextStyle style =
                                                        TextStyle(
                                                      color: (Colors.white)
                                                          .withOpacity(0.8),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    );
                                                    if (snapshot.hasData) {
                                                      playbackPosition =
                                                          snapshot.data;
                                                      return Text(
                                                        // '0:00',
                                                        playbackPosition!
                                                                    .inHours >=
                                                                1.0
                                                            ? "${playbackPosition?.inHours.toString()}:${((playbackPosition?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((playbackPosition?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}"
                                                            : "${playbackPosition?.inMinutes.toString()}:${((playbackPosition?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                                                        style: style,
                                                      );
                                                    } else {
                                                      return Text(
                                                        "0:00",
                                                        style: style,
                                                      );
                                                    }
                                                  }),
                                              const SizedBox(width: 2),
                                              Text(
                                                '/',
                                                style: TextStyle(
                                                  color: (Colors.white)
                                                      .withOpacity(0.8),
                                                  fontSize: 14,
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
                                                  color: (Colors.white)
                                                      .withOpacity(0.8),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: AddToPlaylistButton(
                                      item: currentTrackBaseItem,
                                      queueItem: currentTrack,
                                      color: Colors.white,
                                      size: 28,
                                      visualDensity:
                                          const VisualDensity(horizontal: -4),
                                    ),
                                  ),
                                  IconButton(
                                      iconSize: 28,
                                      visualDensity:
                                          const VisualDensity(horizontal: -4),
                                      // visualDensity: VisualDensity.compact,
                                      icon: const Icon(
                                        TablerIcons.dots_vertical,
                                        size: 28,
                                        color: Colors.white,
                                        weight: 1.5,
                                      ),
                                      onPressed: () {
                                        Feedback.forLongPress(context);
                                        showModalSongMenu(
                                          context: context,
                                          usePlayerTheme: true,
                                          item: currentTrackBaseItem,
                                          isInPlaylist:
                                              queueItemInPlaylist(currentTrack),
                                          parentItem: currentTrack?.source.item,
                                          confirmPlaylistRemoval: true,
                                        );
                                      })
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
  final FinampPlaybackOrder order;
  final FinampLoopMode loop;
  final double speed;

  PlaybackBehaviorInfo(this.order, this.loop, this.speed);
}

class QueueSectionHeader extends StatelessWidget {
  final Widget title;
  final QueueItemSource? source;
  final bool controls;
  final GlobalKey nextUpHeaderKey;
  final GlobalKey queueHeaderKey;
  final ScrollController scrollController;

  const QueueSectionHeader({
    super.key,
    required this.title,
    required this.source,
    required this.nextUpHeaderKey,
    required this.queueHeaderKey,
    required this.scrollController,
    this.controls = false,
  });

  @override
  Widget build(context) {
    final queueService = GetIt.instance<QueueService>();

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 12.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      StreamBuilder(
                          stream: queueService.getQueueStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var remaining = snapshot.data!.remainingDuration;
                              var remainText = printDuration(remaining,
                                  leadingZeroes: false);
                              final remainingLabelFullHours =
                                  (remaining.inHours);
                              final remainingLabelFullMinutes =
                                  (remaining.inMinutes) % 60;
                              final remainingLabelSeconds =
                                  (remaining.inSeconds) % 60;
                              final remainingLabelString =
                                  "${remainingLabelFullHours > 0 ? "$remainingLabelFullHours ${AppLocalizations.of(context)!.hours} " : ""}${remainingLabelFullMinutes > 0 ? "$remainingLabelFullMinutes ${AppLocalizations.of(context)!.minutes} " : ""}$remainingLabelSeconds ${AppLocalizations.of(context)!.seconds}";
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, right: 8.0),
                                  child: Text(
                                      "${snapshot.data!.currentTrackIndex} / ${snapshot.data!.trackCount}  (${AppLocalizations.of(context)!.remainingDuration(remainText)})",
                                      semanticsLabel:
                                          "${AppLocalizations.of(context)!.trackCountTooltip(snapshot.data!.currentTrackIndex, snapshot.data!.trackCount)} (${AppLocalizations.of(context)!.remainingDuration(remainingLabelString)})"));
                            }
                            return const SizedBox.shrink();
                          }),
                    ],
                  ),
                ),
                onTap: () {
                  if (source != null) {
                    navigateToSource(context, source!);
                  }
                }),
          ),
          if (controls)
            StreamBuilder(
              stream: Rx.combineLatest3(
                  queueService.getPlaybackOrderStream(),
                  queueService.getLoopModeStream(),
                  queueService.getPlaybackSpeedStream(),
                  (a, b, c) => PlaybackBehaviorInfo(a, b, c)),
              builder: (context, snapshot) {
                PlaybackBehaviorInfo? info = snapshot.data;
                return Row(
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 28.0,
                        icon: info?.order == FinampPlaybackOrder.shuffled
                            ? (const Icon(
                                TablerIcons.arrows_shuffle,
                              ))
                            : (const Icon(
                                TablerIcons.arrows_right,
                              )),
                        color: info?.order == FinampPlaybackOrder.shuffled
                            ? IconTheme.of(context).color!
                            : (Theme.of(context).textTheme.bodyMedium?.color ??
                                    Colors.white)
                                .withOpacity(0.85),
                        onPressed: () {
                          queueService.togglePlaybackOrder();
                          FeedbackHelper.feedback(FeedbackType.success);
                          Future.delayed(
                              const Duration(milliseconds: 200),
                              () => scrollToKey(
                                  key: nextUpHeaderKey,
                                  duration: const Duration(milliseconds: 500)));
                          // scrollToKey(key: nextUpHeaderKey, duration: const Duration(milliseconds: 1000));
                        }),
                    IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 28.0,
                        icon: info?.loop != FinampLoopMode.none
                            ? (info?.loop == FinampLoopMode.one
                                ? (const Icon(
                                    TablerIcons.repeat_once,
                                  ))
                                : (const Icon(
                                    TablerIcons.repeat,
                                  )))
                            : (const Icon(
                                TablerIcons.repeat_off,
                              )),
                        color: info?.loop != FinampLoopMode.none
                            ? IconTheme.of(context).color!
                            : (Theme.of(context).textTheme.bodyMedium?.color ??
                                    Colors.white)
                                .withOpacity(0.85),
                        onPressed: () {
                          queueService.toggleLoopMode();
                          FeedbackHelper.feedback(FeedbackType.success);
                        }),
                  ],
                );
              },
            )
        ],
      ),
    );
  }
}

class NextUpSectionHeader extends StatelessWidget {
  final bool controls;
  final GlobalKey nextUpHeaderKey;

  const NextUpSectionHeader({
    super.key,
    required this.nextUpHeaderKey,
    this.controls = false,
  });

  @override
  Widget build(context) {
    final queueService = GetIt.instance<QueueService>();

    return Container(
      // color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Text(AppLocalizations.of(context)!.nextUp),
              ])),
          if (controls)
            SimpleButton(
              text: AppLocalizations.of(context)!.clearNextUp,
              icon: TablerIcons.x,
              iconPosition: IconPosition.end,
              iconSize: 32.0,
              iconColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              onPressed: () {
                queueService.clearNextUp();
                FeedbackHelper.feedback(FeedbackType.success);
              },
            )
        ],
      ),
    );
  }
}

class PreviousTracksSectionHeader extends SliverPersistentHeaderDelegate {
  // final bool controls;
  final double height;
  final VoidCallback? onTap;
  final GlobalKey previousTracksHeaderKey;
  final BehaviorSubject<bool> isRecentTracksExpanded;

  PreviousTracksSectionHeader({
    required this.previousTracksHeaderKey,
    required this.isRecentTracksExpanded,
    // this.controls = false,
    this.onTap,
    this.height = 50.0,
  });

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      // color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.only(
          left: 14.0, right: 14.0, bottom: 12.0, top: 8.0),
      child: GestureDetector(
        onTap: () {
          try {
            if (onTap != null) {
              onTap!();
              FeedbackHelper.feedback(FeedbackType.selection);
            }
          } catch (e) {
            FeedbackHelper.feedback(FeedbackType.error);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(AppLocalizations.of(context)!.previousTracks),
            ),
            const SizedBox(width: 4.0),
            StreamBuilder<bool>(
                stream: isRecentTracksExpanded,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return Icon(
                      TablerIcons.chevron_up,
                      size: 28.0,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    );
                  } else {
                    return Icon(
                      TablerIcons.chevron_down,
                      size: 28.0,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
