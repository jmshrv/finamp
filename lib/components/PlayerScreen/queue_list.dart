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
  List<QueueItem>? _queue;

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
                  child: ListTile(
                    leading: AlbumImage(
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
                    onTap: () async =>
                        await _queueService.skipByOffset(indexOffset),
                  ),
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
            DragAndDropList(
              header: const ListTile(
                leading: Icon(TablerIcons.layout_list),
                title: Text("Queue"),
              ),
              canDrag: false,
              children: _queue?.asMap().entries.map((e) {
                final index = e.key;
                final item = e.value;
                // final actualIndex = index;
                // final indexOffset = -((_previousTracks?.length ?? 0) - index);
                final actualIndex = index;
                final indexOffset = index + 1;

                return DragAndDropItem(child: Card(
                  child: ListTile(
                    leading: AlbumImage(
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
                children: _contents,
                onItemReorder: _onItemReorder,
                onListReorder: _onListReorder,
                itemOnWillAccept: (draggingItem, targetItem) {
                  if (targetItem.child.key == currentTrackKey) {
                    return false;
                  }
                  return true;
                },
                itemDragOnLongPress: true,
                sliverList: true,
                scrollController: widget.scrollController,
                itemDragHandle: const DragHandle(
                  child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      TablerIcons.menu,
                      color: Colors.grey,
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

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {

    setState(() {
      var movedItem = _contents[oldListIndex].children!.removeAt(oldItemIndex);
      _contents[newListIndex].children!.insert(newItemIndex, movedItem);
    });

    int oldOffset = 0;
    int newOffset = 0;

    if (oldListIndex == newListIndex) {
      if (oldListIndex == 0) {
        // previous tracks
        oldOffset = -((_previousTracks?.length ?? 0) - oldItemIndex);
        newOffset = -((_previousTracks?.length ?? 0) - newItemIndex);
      } else if (oldListIndex == _contents.length - 1) {
        // queue
        oldOffset = oldItemIndex + 1;
        newOffset = newItemIndex + 1;
      }
    } else {
      if (oldListIndex == 0) {
        // previous tracks to queue
        oldOffset = -((_previousTracks?.length ?? 0) - oldItemIndex);
        newOffset = newItemIndex + 1;
      } else if (oldListIndex == _contents.length - 1) {
        // queue to previous tracks
        oldOffset = oldItemIndex + 1;
        newOffset = -((_previousTracks?.length ?? 0) - newItemIndex);
      }
    }

    _queueService.reorderByOffset(oldOffset, newOffset);

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
