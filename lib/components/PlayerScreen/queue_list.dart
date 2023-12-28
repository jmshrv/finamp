import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/AlbumScreen/song_list_tile.dart';
import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/screens/add_to_playlist_screen.dart';
import 'package:finamp/screens/album_screen.dart';
import 'package:finamp/screens/blurred_player_screen_background.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/player_screen_theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../../services/current_album_image_provider.dart';
import '../album_image.dart';
import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../../services/process_artist.dart';
import '../../services/media_state_stream.dart';
import '../../services/music_player_background_task.dart';
import '../../services/queue_service.dart';
import 'queue_list_item.dart';
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
  const QueueList({
    Key? key,
    required this.scrollController,
    required this.previousTracksHeaderKey,
    required this.currentTrackKey,
    required this.nextUpHeaderKey,
  }) : super(key: key);

  final ScrollController scrollController;
  final GlobalKey previousTracksHeaderKey;
  final Key currentTrackKey;
  final GlobalKey nextUpHeaderKey;

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
  BehaviorSubject<bool> isRecentTracksExpanded = BehaviorSubject.seeded(false);

  @override
  void initState() {
    super.initState();

    _queueService.getQueueStream().listen((queueInfo) {
      _source = queueInfo?.source;
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
            title: const Text("unknown"),
            subtitle: const Text("unknown"),
            onTap: () {}),
      ),
      SliverPersistentHeader(
          delegate: QueueSectionHeader(
        source: _source,
        title: const Flexible(
            child: Text("Queue", overflow: TextOverflow.ellipsis)),
        nextUpHeaderKey: widget.nextUpHeaderKey,
      )),
      // Queue
      SliverList.list(
        key: widget.nextUpHeaderKey,
        children: const [],
      ),
    ];
  }

  void scrollToCurrentTrack() {
    if (widget.previousTracksHeaderKey.currentContext != null) {
      Scrollable.ensureVisible(
        widget.previousTracksHeaderKey.currentContext!,
        // duration: const Duration(milliseconds: 200),
        // curve: Curves.decelerate,
      );
    }
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
            onTap: () =>
                isRecentTracksExpanded.add(!isRecentTracksExpanded.value),
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
            return SliverPadding(
              // key: widget.nextUpHeaderKey,
              padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
              sliver: SliverPersistentHeader(
                pinned:
                    false, //TODO use https://stackoverflow.com/a/69372976 to only ever have one of the headers pinned
                delegate: NextUpSectionHeader(
                  controls: true,
                  nextUpHeaderKey: widget.nextUpHeaderKey,
                ), // _source != null ? "Playing from ${_source?.name}" : "Queue",
              ),
            );
          } else {
            return const SliverToBoxAdapter();
          }
        },
      ),
      NextUpTracksList(previousTracksHeaderKey: widget.previousTracksHeaderKey),
      SliverPadding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
        sliver: SliverPersistentHeader(
          pinned: true,
          delegate: QueueSectionHeader(
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
          ),
        ),
      ),
      // Queue
      QueueTracksList(previousTracksHeaderKey: widget.previousTracksHeaderKey),
      const SliverPadding(
        padding: EdgeInsets.only(bottom: 80.0, top: 40.0),
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
      child: Scrollbar(
        controller: widget.scrollController,
        interactive: true,
        child: CustomScrollView(
          controller: widget.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: _contents,
        ),
      ),
    );
  }
}

Future<dynamic> showQueueBottomSheet(BuildContext context) {
  GlobalKey previousTracksHeaderKey = GlobalKey();
  Key currentTrackKey = UniqueKey();
  GlobalKey nextUpHeaderKey = GlobalKey();

  Vibrate.feedback(FeedbackType.impact);

  return showModalBottomSheet(
    // showDragHandle: true,
    useSafeArea: true,
    enableDrag: true,
    isScrollControlled: true,
    routeSettings: const RouteSettings(name: "/queue"),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
    ),
    clipBehavior: Clip.antiAlias,
    context: context,
    builder: (context) {
      return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final imageTheme =
            ref.watch(playerScreenThemeProvider(Theme.of(context).brightness));

        return AnimatedTheme(
          duration: const Duration(milliseconds: 500),
          data: ThemeData(
            fontFamily: "LexendDeca",
            colorScheme: imageTheme,
            brightness: Theme.of(context).brightness,
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
                        .finampSettings.showCoverAsPlayerBackground)
                      BlurredPlayerScreenBackground(
                          brightnessFactor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? 1.0
                                  : 1.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 40,
                          height: 3.5,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).textTheme.bodySmall!.color!,
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
                                fontFamily: 'Lexend Deca',
                                fontSize: 18,
                                fontWeight: FontWeight.w300)),
                        const SizedBox(height: 20),
                        Expanded(
                          child: QueueList(
                            scrollController: scrollController,
                            previousTracksHeaderKey: previousTracksHeaderKey,
                            currentTrackKey: currentTrackKey,
                            nextUpHeaderKey: nextUpHeaderKey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //TODO fade this out if the current track is visible
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Vibrate.feedback(FeedbackType.impact);
                      scrollToKey(
                          key: previousTracksHeaderKey,
                          duration: const Duration(milliseconds: 500));
                    },
                    backgroundColor:
                        IconTheme.of(context).color!.withOpacity(0.70),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Icon(
                        TablerIcons.focus_2,
                        size: 28.0,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    )),
              );
              // )
              // return QueueList(
              //   scrollController: scrollController,
              // );
            },
          ),
        );
      });
    },
  );
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
              print("$draggingOffset -> $newPositionOffset");
              if (mounted) {
                Vibrate.feedback(FeedbackType.impact);
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
              Vibrate.feedback(FeedbackType.selection);
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
              return QueueListItem(
                key: ValueKey(item.id),
                item: item,
                listIndex: index,
                actualIndex: actualIndex,
                indexOffset: indexOffset,
                subqueue: _previousTracks!,
                allowReorder:
                    _queueService.playbackOrder == FinampPlaybackOrder.linear,
                onTap: () async {
                  Vibrate.feedback(FeedbackType.selection);
                  await _queueService.skipByOffset(indexOffset);
                  scrollToKey(
                      key: widget.previousTracksHeaderKey,
                      duration: const Duration(milliseconds: 500));
                },
                isCurrentTrack: false,
                isPreviousTrack: true,
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
    return StreamBuilder<FinampQueueInfo?>(
      stream: _queueService.getQueueStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _nextUp ??= snapshot.data!.nextUp;

          return SliverPadding(
              padding: const EdgeInsets.only(top: 0.0, left: 4.0, right: 4.0),
              sliver: SliverReorderableList(
                autoScrollerVelocityScalar: 20.0,
                onReorder: (oldIndex, newIndex) {
                  int draggingOffset = oldIndex + 1;
                  int newPositionOffset = newIndex + 1;
                  if (mounted) {
                    Vibrate.feedback(FeedbackType.impact);
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
                  Vibrate.feedback(FeedbackType.selection);
                },
                findChildIndexCallback: (Key key) {
                  key = key as GlobalObjectKey;
                  final ValueKey<String> valueKey =
                      key.value as ValueKey<String>;
                  final index =
                      _nextUp!.indexWhere((item) => item.id == valueKey.value);
                  if (index == -1) return null;
                  return index;
                },
                itemCount: _nextUp?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = _nextUp![index];
                  final actualIndex = index;
                  final indexOffset = index + 1;
                  return QueueListItem(
                    key: ValueKey(item.id),
                    item: item,
                    listIndex: index,
                    actualIndex: actualIndex,
                    indexOffset: indexOffset,
                    subqueue: _nextUp!,
                    onTap: () async {
                      Vibrate.feedback(FeedbackType.selection);
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
    return StreamBuilder<FinampQueueInfo?>(
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
                Vibrate.feedback(FeedbackType.impact);
                setState(() {
                  // temporarily update internal queue
                  FinampQueueItem tmp = _queue!.removeAt(oldIndex);
                  _queue!.insert(
                      newIndex < oldIndex ? newIndex : newIndex - 1, tmp);
                });
              }
            },
            onReorderStart: (p0) {
              Vibrate.feedback(FeedbackType.selection);
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

              return QueueListItem(
                key: ValueKey(item.id),
                item: item,
                listIndex: index,
                actualIndex: actualIndex,
                indexOffset: indexOffset,
                subqueue: _queue!,
                allowReorder:
                    _queueService.playbackOrder == FinampPlaybackOrder.linear,
                onTap: () async {
                  Vibrate.feedback(FeedbackType.selection);
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
  late AudioServiceHelper _audioServiceHelper;
  late JellyfinApiHelper _jellyfinApiHelper;

  @override
  void initState() {
    super.initState();
    _queueService = GetIt.instance<QueueService>();
    _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
    _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
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
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0.0),
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
                                Vibrate.feedback(FeedbackType.success);
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
                                          (playbackPosition!.inMilliseconds /
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
                                            fontFamily: 'Lexend Deca',
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
                                                  fontFamily: 'Lexend Deca',
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
                                                      fontFamily: 'Lexend Deca',
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
                                                  color: (Colors.white)
                                                      .withOpacity(0.8),
                                                  fontSize: 14,
                                                  fontFamily: 'Lexend Deca',
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
                                    child: IconButton(
                                      iconSize: 16,
                                      visualDensity:
                                          const VisualDensity(horizontal: -4),
                                      icon:
                                          jellyfin_models.BaseItemDto.fromJson(
                                                      currentTrack!.item
                                                          .extras?["itemJson"])
                                                  .userData!
                                                  .isFavorite
                                              ? const Icon(
                                                  Icons.favorite,
                                                  size: 28,
                                                  color: Colors.white,
                                                  fill: 1.0,
                                                  weight: 1.5,
                                                )
                                              : const Icon(
                                                  Icons.favorite_outline,
                                                  size: 28,
                                                  color: Colors.white,
                                                  weight: 1.5,
                                                ),
                                      onPressed: () {
                                        Vibrate.feedback(FeedbackType.success);
                                        setState(() {
                                          setFavourite(currentTrack!, context);
                                        });
                                      },
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
                                    onPressed: () =>
                                        showSongMenu(currentTrack!),
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

  void showSongMenu(FinampQueueItem currentTrack) async {
    final item = jellyfin_models.BaseItemDto.fromJson(
        currentTrack.item.extras?["itemJson"]);

    final canGoToAlbum = _isAlbumDownloadedIfOffline(item.parentId);

    // Some options are disabled in offline mode
    final isOffline = FinampSettingsHelper.finampSettings.isOffline;

    final selection = await showMenu<SongListTileMenuItems>(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 50.0,
          MediaQuery.of(context).size.height - 50.0, 0.0, 0.0),
      items: [
        PopupMenuItem<SongListTileMenuItems>(
          value: SongListTileMenuItems.addToQueue,
          child: ListTile(
            leading: const Icon(Icons.queue_music),
            title: Text(AppLocalizations.of(context)!.addToQueue),
          ),
        ),
        PopupMenuItem<SongListTileMenuItems>(
          value: SongListTileMenuItems.playNext,
          child: ListTile(
            leading: const Icon(TablerIcons.hourglass_low),
            title: Text(AppLocalizations.of(context)!.playNext),
          ),
        ),
        PopupMenuItem<SongListTileMenuItems>(
          value: SongListTileMenuItems.addToNextUp,
          child: ListTile(
            leading: const Icon(TablerIcons.hourglass_high),
            title: Text(AppLocalizations.of(context)!.addToNextUp),
          ),
        ),
        PopupMenuItem<SongListTileMenuItems>(
          enabled: !isOffline,
          value: SongListTileMenuItems.addToPlaylist,
          child: ListTile(
            leading: const Icon(Icons.playlist_add),
            title: Text(AppLocalizations.of(context)!.addToPlaylistTitle),
            enabled: !isOffline,
          ),
        ),
        PopupMenuItem<SongListTileMenuItems>(
          enabled: !isOffline,
          value: SongListTileMenuItems.instantMix,
          child: ListTile(
            leading: const Icon(Icons.explore),
            title: Text(AppLocalizations.of(context)!.instantMix),
            enabled: !isOffline,
          ),
        ),
        PopupMenuItem<SongListTileMenuItems>(
          enabled: canGoToAlbum,
          value: SongListTileMenuItems.goToAlbum,
          child: ListTile(
            leading: const Icon(Icons.album),
            title: Text(AppLocalizations.of(context)!.goToAlbum),
            enabled: canGoToAlbum,
          ),
        ),
        item.userData!.isFavorite
            ? PopupMenuItem<SongListTileMenuItems>(
                value: SongListTileMenuItems.removeFavourite,
                child: ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: Text(AppLocalizations.of(context)!.removeFavourite),
                ),
              )
            : PopupMenuItem<SongListTileMenuItems>(
                value: SongListTileMenuItems.addFavourite,
                child: ListTile(
                  leading: const Icon(Icons.favorite),
                  title: Text(AppLocalizations.of(context)!.addFavourite),
                ),
              ),
      ],
    );

    if (!mounted) return;

    switch (selection) {
      case SongListTileMenuItems.addToQueue:
        await _queueService.addToQueue(
            items: [item],
            source: QueueItemSource(
                type: QueueItemSourceType.unknown,
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: AppLocalizations.of(context)!.queue),
                id: currentTrack.source.id));

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.addedToQueue),
        ));
        break;

      case SongListTileMenuItems.playNext:
        await _queueService.addNext(items: [item]);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmPlayNext("track")),
        ));
        break;

      case SongListTileMenuItems.addToNextUp:
        await _queueService.addToNextUp(items: [item]);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(AppLocalizations.of(context)!.confirmAddToNextUp("track")),
        ));
        break;

      case SongListTileMenuItems.addToPlaylist:
        Navigator.of(context)
            .pushNamed(AddToPlaylistScreen.routeName, arguments: item.id);
        break;

      case SongListTileMenuItems.instantMix:
        await _audioServiceHelper.startInstantMixForItem(item);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.startingInstantMix),
        ));
        break;
      case SongListTileMenuItems.goToAlbum:
        late jellyfin_models.BaseItemDto album;
        if (FinampSettingsHelper.finampSettings.isOffline) {
          // If offline, load the album's BaseItemDto from DownloadHelper.
          final downloadsHelper = GetIt.instance<DownloadsHelper>();

          // downloadedParent won't be null here since the menu item already
          // checks if the DownloadedParent exists.
          album = downloadsHelper.getDownloadedParent(item.parentId!)!.item;
        } else {
          // If online, get the album's BaseItemDto from the server.
          try {
            album = await _jellyfinApiHelper.getItemById(item.parentId!);
          } catch (e) {
            errorSnackbar(e, context);
            break;
          }
        }

        if (!mounted) return;

        Navigator.of(context)
            .pushNamed(AlbumScreen.routeName, arguments: album);
        break;
      case SongListTileMenuItems.addFavourite:
      case SongListTileMenuItems.removeFavourite:
        await setFavourite(currentTrack, context);
        break;
      case null:
        break;
    }
  }

}

Future<void> setFavourite(FinampQueueItem track, BuildContext context) async {
    final queueService = GetIt.instance<QueueService>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    
    try {
      // We switch the widget state before actually doing the request to
      // make the app feel faster (without, there is a delay from the
      // user adding the favourite and the icon showing)
      jellyfin_models.BaseItemDto item =
          jellyfin_models.BaseItemDto.fromJson(track.item.extras!["itemJson"]);

      // setState(() {
        item.userData!.isFavorite = !item.userData!.isFavorite;
      // });

      // Since we flipped the favourite state already, we can use the flipped
      // state to decide which API call to make
      final newUserData = item.userData!.isFavorite
          ? await jellyfinApiHelper.addFavourite(item.id)
          : await jellyfinApiHelper.removeFavourite(item.id);

      item.userData = newUserData;

      // if (!mounted) return;
      // setState(() {
        //!!! update the QueueItem with the new BaseItemDto, then trigger a rebuild of the widget with the current snapshot (**which includes the modified QueueItem**)
        track.item.extras!["itemJson"] = item.toJson();
      // });

      queueService.refreshQueueStream();
    } catch (e) {
      errorSnackbar(e, context);
    }
  }

class PlaybackBehaviorInfo {
  final FinampPlaybackOrder order;
  final FinampLoopMode loop;

  PlaybackBehaviorInfo(this.order, this.loop);
}

class QueueSectionHeader extends SliverPersistentHeaderDelegate {
  final Widget title;
  final QueueItemSource? source;
  final bool controls;
  final double height;
  final GlobalKey nextUpHeaderKey;

  QueueSectionHeader({
    required this.title,
    required this.source,
    required this.nextUpHeaderKey,
    this.controls = false,
    this.height = 30.0,
  });

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    final queueService = GetIt.instance<QueueService>();

    return StreamBuilder(
      stream: Rx.combineLatest2(
          queueService.getPlaybackOrderStream(),
          queueService.getLoopModeStream(),
          (a, b) => PlaybackBehaviorInfo(a, b)),
      builder: (context, snapshot) {
        PlaybackBehaviorInfo? info = snapshot.data;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                    child: title,
                    onTap: () {
                      if (source != null) {
                        navigateToSource(context, source!);
                      }
                    }),
              ),
              if (controls)
                Row(
                  children: [
                    IconButton(
                        padding: const EdgeInsets.only(bottom: 2.0),
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
                            : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white).withOpacity(0.85),
                        onPressed: () {
                          queueService.togglePlaybackOrder();
                          Vibrate.feedback(FeedbackType.success);
                          Future.delayed(
                              const Duration(milliseconds: 300),
                              () => scrollToKey(
                                  key: nextUpHeaderKey,
                                  duration: const Duration(milliseconds: 500)));
                          // scrollToKey(key: nextUpHeaderKey, duration: const Duration(milliseconds: 1000));
                        }),
                    IconButton(
                        padding: const EdgeInsets.only(bottom: 2.0),
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
                            : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white).withOpacity(0.85),
                        onPressed: () {
                          queueService.toggleLoopMode();
                          Vibrate.feedback(FeedbackType.success);
                        }),
                  ],
                )
              // Expanded(
              //     child: Flex(
              //         direction: Axis.horizontal,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         clipBehavior: Clip.hardEdge,
              //         children: [
              //       ,
              //     ])),

              // )
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

class NextUpSectionHeader extends SliverPersistentHeaderDelegate {
  final bool controls;
  final double height;
  final GlobalKey nextUpHeaderKey;

  NextUpSectionHeader({
    required this.nextUpHeaderKey,
    this.controls = false,
    this.height = 30.0,
  });

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    final _queueService = GetIt.instance<QueueService>();

    return Container(
      // color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
            GestureDetector(
              onTap: () {
                _queueService.clearNextUp();
                Vibrate.feedback(FeedbackType.success);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(AppLocalizations.of(context)!.clearNextUp),
                  ),
                  const Icon(
                    TablerIcons.x,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ],
              ),
            ),
        ],
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
              Vibrate.feedback(FeedbackType.selection);
            }
          } catch (e) {
            Vibrate.feedback(FeedbackType.error);
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

/// If offline, check if an album is downloaded. Always returns true if online.
/// Returns false if albumId is null.
bool _isAlbumDownloadedIfOffline(String? albumId) {
  if (albumId == null) {
    return false;
  } else if (FinampSettingsHelper.finampSettings.isOffline) {
    final downloadsHelper = GetIt.instance<DownloadsHelper>();
    return downloadsHelper.isAlbumDownloaded(albumId);
  } else {
    return true;
  }
}
