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

  late List<DragAndDropListInterface> _contents;

  @override
  void initState() {
    super.initState();

    _contents = [
      DragAndDropListExpansion(
        listKey: const ObjectKey(0),
        title: const Text("Previous Tracks"),
        leading: const Icon(TablerIcons.history),
        disableTopAndBottomBorders: true,
        canDrag: false,
        children: [],
      ),
      DragAndDropList(
        header: const ListTile(
          leading: Icon(TablerIcons.music),
          title: Text("Current Track"),
        ),
        canDrag: false,
        children: [],
      ),
      DragAndDropList(
        header: const ListTile(
          leading: Icon(TablerIcons.layout_list),
          title: Text("Next Up"),
        ),
        canDrag: false,
        children: [],
      ),
      DragAndDropList(
        header: const ListTile(
          leading: Icon(TablerIcons.layout_list),
          title: Text("Queue"),
        ),
        canDrag: false,
        children: [],
      ),
    ];
  }

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
          _nextUp ??= snapshot.data!.queueInfo.nextUp;
          _queue ??= snapshot.data!.queueInfo.queue;
          _source ??= snapshot.data!.queueInfo.source;

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
          //TODO fix this
          // WidgetsBinding.instance
          //   .addPostFrameCallback((_) => scrollToCurrentTrack());

          _contents = [
            //TODO save this as a variable so that a pseudo footer can be added that will call `toggleExpanded()` on the list
            DragAndDropListExpansion(
              listKey: const ObjectKey(0),
              title: const Text("Previous Tracks"),
              // subtitle: Text('Subtitle ${innerList.name}'),
              // trailing: Text("Previous Tracks"),
              leading: const Icon(TablerIcons.history),
              disableTopAndBottomBorders: true,
              canDrag: false,
              children: _previousTracks?.asMap().entries.map((e) {
                final index = e.key;
                final item = e.value;
                final actualIndex = index;
                final indexOffset = -((_previousTracks?.length ?? 0) - index);

                return DragAndDropItem(child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    minVerticalPadding: 0.0,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                    tileColor: _currentTrack == item
                        ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                        : null,
                    leading: AlbumImage(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7.0),
                        bottomLeft: Radius.circular(7.0),
                      ),
                      item: item.item
                                  .extras?["itemJson"] == null
                              ? null
                              : jellyfin_models.BaseItemDto.fromJson(item.item.extras?["itemJson"]),
                    ),
                    title: Text(
                        item.item.title ?? AppLocalizations.of(context)!.unknownName,
                        style: _currentTrack == item
                            ? TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)
                            : null),
                    subtitle: Text(processArtist(
                        item.item.artist,
                        context)),
                    trailing: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 32.0),
                      width: 95.0,
                      height: 50.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,  
                        children: [
                          Text(
                            "${item.item.duration?.inMinutes.toString().padLeft(2, '0')}:${((item.item.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                          // IconButton(
                          //   icon: const Icon(TablerIcons.dots_vertical),
                          //   iconSize: 28.0,
                          //   onPressed: () async => {},
                          // ),
                          IconButton(
                            icon: const Icon(TablerIcons.x),
                            iconSize: 28.0,
                            onPressed: () async => await _queueService.removeAtOffset(indexOffset),
                          ),
                        ],
                      ),  
                    ),
                    onTap: () async =>
                        await _queueService.skipByOffset(indexOffset),
                  )
                ));
              }).toList() ?? [],
            ),
            DragAndDropList(
              header: const ListTile(
                leading: Icon(TablerIcons.music),
                title: Text("Current Track"),
              ),
              canDrag: false,
              children: [
                DragAndDropItem(
                  canDrag: false,
                  child: Card(
                    key: currentTrackKey,
                    child: ListTile(
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
                  )
                )
              ]
            ),
            if (_nextUp!.isNotEmpty) 
              DragAndDropList(
                header: const ListTile(
                  leading: Icon(TablerIcons.layout_list),
                  title: Text("Next Up"),
                ),
                canDrag: false,
                children: _nextUp?.asMap().entries.map((e) {
                  final index = e.key;
                  final item = e.value;
                  // final actualIndex = index;
                  // final indexOffset = -((_previousTracks?.length ?? 0) - index);
                  final actualIndex = index;
                  final indexOffset = index + 1;

                  return DragAndDropItem(child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      minVerticalPadding: 0.0,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      tileColor: _currentTrack == item
                          ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                          : null,
                      leading: AlbumImage(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(7.0),
                          bottomLeft: Radius.circular(7.0),
                        ),
                        item: item.item
                                    .extras?["itemJson"] == null
                                ? null
                                : jellyfin_models.BaseItemDto.fromJson(item.item.extras?["itemJson"]),
                      ),
                      title: Text(
                          item.item.title ?? AppLocalizations.of(context)!.unknownName,
                          style: _currentTrack == item
                              ? TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)
                              : null),
                      subtitle: Text(processArtist(
                          item.item.artist,
                          context)),
                      trailing: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(right: 32.0),
                        width: 95.0,
                        height: 50.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,  
                          children: [
                            Text(
                              "${item.item.duration?.inMinutes.toString().padLeft(2, '0')}:${((item.item.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                            // IconButton(
                            //   icon: const Icon(TablerIcons.dots_vertical),
                            //   iconSize: 28.0,
                            //   onPressed: () async => {},
                            // ),
                            IconButton(
                              icon: const Icon(TablerIcons.x),
                              iconSize: 28.0,
                              onPressed: () async => await _queueService.removeAtOffset(indexOffset),
                            ),
                          ],
                        ),  
                      ),
                      onTap: () async =>
                          await _queueService.skipByOffset(indexOffset),
                    )
                  ));
                }).toList() ?? [],
              ),
            DragAndDropList(
              contentsWhenEmpty: const Text("Queue is empty"),
              header: ListTile(
                leading: const Icon(TablerIcons.layout_list),
                title: Text(_source?.name != null ? "Playing from ${_source?.name}" : "Queue"),
              ),
              canDrag: false,
              children: _queue?.asMap().entries.map((e) {
                final index = e.key;
                final item = e.value;
                // final actualIndex = index;
                // final indexOffset = -((_previousTracks?.length ?? 0) - index);
                final actualIndex = index + _nextUp!.length;
                final indexOffset = index + _nextUp!.length + 1;

                return DragAndDropItem(child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    minVerticalPadding: 0.0,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                    tileColor: _currentTrack == item
                        ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                        : null,
                    leading: AlbumImage(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7.0),
                        bottomLeft: Radius.circular(7.0),
                      ),
                      item: item.item
                                  .extras?["itemJson"] == null
                              ? null
                              : jellyfin_models.BaseItemDto.fromJson(item.item.extras?["itemJson"]),
                    ),
                    title: Text(
                        item.item.title ?? AppLocalizations.of(context)!.unknownName,
                        style: _currentTrack == item
                            ? TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)
                            : null),
                    subtitle: Text(processArtist(
                        item.item.artist,
                        context)),
                    trailing: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 32.0),
                      width: 95.0,
                      height: 50.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,  
                        children: [
                          Text(
                            "${item.item.duration?.inMinutes.toString().padLeft(2, '0')}:${((item.item.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                          // IconButton(
                          //   icon: const Icon(TablerIcons.dots_vertical),
                          //   iconSize: 28.0,
                          //   onPressed: () async => {},
                          // ),
                          IconButton(
                            icon: const Icon(TablerIcons.x),
                            iconSize: 28.0,
                            onPressed: () async => await _queueService.removeAtOffset(indexOffset),
                          ),
                        ],
                      ),  
                    ),
                    onTap: () async =>
                        await _queueService.skipByOffset(indexOffset),
                  ),
                ));
              }).toList() ?? [],
            ),
          ];

          return CustomScrollView(
            controller: widget.scrollController,
            slivers: <Widget>[
              // const SliverPadding(padding: EdgeInsets.only(top: 0)),
              DragAndDropLists(
                listPadding: const EdgeInsets.only(top: 0.0),
                
                children: _contents,
                onItemReorder: _onItemReorder,
                onListReorder: _onListReorder,
                itemOnWillAccept: (draggingItem, targetItem) {
                  //TODO this isn't working properly
                  if (targetItem.child.key == currentTrackKey) {
                    return false;
                  }
                  return true;
                },
                itemDragOnLongPress: true,
                sliverList: true,
                scrollController: widget.scrollController,
                itemDragHandle: DragHandle(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(
                      TablerIcons.grip_horizontal,
                      color: IconTheme.of(context).color,
                      size: 28.0,
                    ),
                  ),
                ),
                // mandatory, not actually needed because lists can't be dragged
                listGhost: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 100.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: const Icon(Icons.add_box),
                    ),
                  ),
                ),
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

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) async {

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
    } else if (
      newListIndex == 2 &&
      oldListIndex == 2 // tracks can't be moved *to* next up, only *within* next up or *out of* next up
    ) {
      // next up
      newOffset = newItemIndex + 1;
    } else if (newListIndex == _contents.length -1) {
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
