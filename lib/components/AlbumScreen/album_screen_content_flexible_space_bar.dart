import 'dart:math';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../album_image.dart';
import 'item_info.dart';

class AlbumScreenContentFlexibleSpaceBar extends StatelessWidget {
  const AlbumScreenContentFlexibleSpaceBar({
    Key? key,
    required this.parentItem,
    required this.isPlaylist,
    required this.items,
  }) : super(key: key);

  final BaseItemDto parentItem;
  final bool isPlaylist;
  final List<BaseItemDto> items;

  @override
  Widget build(BuildContext context) {
    AudioServiceHelper audioServiceHelper =
        GetIt.instance<AudioServiceHelper>();
    QueueService queueService =
        GetIt.instance<QueueService>();

    void playAlbum() {
      queueService.playbackOrder = PlaybackOrder.linear;
      queueService.startPlayback(
          items: items,
          source: QueueItemSource(
            type: isPlaylist ? QueueItemSourceType.playlist : QueueItemSourceType.album,
            name: parentItem.name ?? "Somewhere",
            id: parentItem.id,
            item: parentItem,
          )
      );
    }

    void shuffleAlbum() {
      queueService.playbackOrder = PlaybackOrder.shuffled;
      queueService.startPlayback(
          items: items,
          source: QueueItemSource(
            type: isPlaylist ? QueueItemSourceType.playlist : QueueItemSourceType.album,
            name: parentItem.name ?? "Somewhere",
            id: parentItem.id,
            item: parentItem,
          )
      );
    }

    void addAlbumToNextUp() {
      queueService.playbackOrder = PlaybackOrder.linear;
      queueService.addToNextUp(
          items: items,
          source: QueueItemSource(
            type: isPlaylist ? QueueItemSourceType.playlist : QueueItemSourceType.album,
            name: parentItem.name ?? "Somewhere",
            id: parentItem.id,
            item: parentItem,
          )
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added to Next Up"),
        ),
      );
    
    }

    void addAlbumNext() {
      queueService.playbackOrder = PlaybackOrder.linear;
      queueService.addNext(
          items: items,
          source: QueueItemSource(
            type: isPlaylist ? QueueItemSourceType.playlist : QueueItemSourceType.album,
            name: parentItem.name ?? "Somewhere",
            id: parentItem.id,
            item: parentItem,
          )
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Will play next"),
        ),
      );
    }

    void shuffleAlbumToNextUp() {
      // linear order is used in this case since we don't want to affect the rest of the queue
      queueService.playbackOrder = PlaybackOrder.linear;
      List<BaseItemDto> clonedItems = List.from(items);
      clonedItems.shuffle();
      queueService.addToNextUp(
          items: clonedItems,
          source: QueueItemSource(
            type: isPlaylist ? QueueItemSourceType.playlist : QueueItemSourceType.album,
            name: parentItem.name ?? "Somewhere",
            id: parentItem.id,
            item: parentItem,
          )
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Shuffled to Next Up"),
        ),
      );
    }

    void shuffleAlbumNext() {
      // linear order is used in this case since we don't want to affect the rest of the queue
      queueService.playbackOrder = PlaybackOrder.linear;
      List<BaseItemDto> clonedItems = List.from(items);
      clonedItems.shuffle();
      queueService.addNext(
          items: clonedItems,
          source: QueueItemSource(
            type: isPlaylist ? QueueItemSourceType.playlist : QueueItemSourceType.album,
            name: parentItem.name ?? "Somewhere",
            id: parentItem.id,
            item: parentItem,
          )
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Will shuffle next"),
        ),
      );
    }

    return FlexibleSpaceBar(
      background: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 125,
                      child: AlbumImage(item: parentItem),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Expanded(
                      flex: 2,
                      child: ItemInfo(
                        item: parentItem,
                        itemSongs: items.length,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                          child: ElevatedButton.icon(
                              onPressed: () => playAlbum(),
                              icon: const Icon(Icons.play_arrow),
                              label:
                                  Text(AppLocalizations.of(context)!.playButtonLabel),
                            ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => shuffleAlbum(),
                            icon: const Icon(Icons.shuffle),
                            label: Text(
                                AppLocalizations.of(context)!.shuffleButtonLabel),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: ElevatedButton.icon(
                              onPressed: () => addAlbumNext(),
                              icon: const Icon(Icons.hourglass_bottom),
                              label:
                                  Text("Play Next"),
                            ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => addAlbumToNextUp(),
                            icon: const Icon(Icons.hourglass_top),
                            label: Text("Add to Next Up"),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: ElevatedButton.icon(
                              onPressed: () => shuffleAlbumNext(),
                              icon: const Icon(Icons.hourglass_bottom),
                              label:
                                  Text("Shuffle Next"),
                            ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => shuffleAlbumToNextUp(),
                            icon: const Icon(Icons.hourglass_top),
                            label: Text("Shuffle to Next Up"),
                          ),
                        ),
                      ]),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

  }

}
