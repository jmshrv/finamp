import 'dart:math';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../AlbumScreen/item_info.dart';
import '../album_image.dart';
import 'artist_item_info.dart';

class ArtistScreenContentFlexibleSpaceBar extends StatelessWidget {
  const ArtistScreenContentFlexibleSpaceBar({
    Key? key,
    required this.parentItem,
    required this.isGenre,
    required this.items,
  }) : super(key: key);

  final BaseItemDto parentItem;
  final bool isGenre;
  final List<BaseItemDto> items;

  @override
  Widget build(BuildContext context) {
    GetIt.instance<AudioServiceHelper>();
    QueueService queueService = GetIt.instance<QueueService>();

    void playAllFromArtist() {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type:
              isGenre ? QueueItemSourceType.genre : QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.linear,
      );
    }

    void shuffleAllFromArtist() {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type:
              isGenre ? QueueItemSourceType.genre : QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.shuffled,
      );
    }

    void addArtistToNextUp() {
      queueService.addToNextUp(
        items: items,
        source: QueueItemSource(
          type: isGenre
              ? QueueItemSourceType.nextUpPlaylist
              : QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .confirmAddToNextUp(isGenre ? "genre" : "artist")),
        ),
      );
    }

    void addArtistNext() {
      queueService.addNext(
          items: items,
          source: QueueItemSource(
            type: isGenre
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.nextUpArtist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .confirmPlayNext(isGenre ? "genre" : "artist")),
        ),
      );
    }

    void shuffleArtistToNextUp() {
      // linear order is used in this case since we don't want to affect the rest of the queue
      List<BaseItemDto> clonedItems = List.from(items);
      clonedItems.shuffle();
      queueService.addToNextUp(
          items: clonedItems,
          source: QueueItemSource(
            type: isGenre
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.nextUpArtist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmShuffleToNextUp),
        ),
      );
    }

    void shuffleArtistNext() {
      // linear order is used in this case since we don't want to affect the rest of the queue
      List<BaseItemDto> clonedItems = List.from(items);
      clonedItems.shuffle();
      queueService.addNext(
          items: clonedItems,
          source: QueueItemSource(
            type: isGenre
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.nextUpArtist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmShuffleNext),
        ),
      );
    }

    void addArtistToQueue() {
      queueService.addToQueue(
        items: items,
        source: QueueItemSource(
          type: isGenre
              ? QueueItemSourceType.nextUpPlaylist
              : QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .confirmAddToQueue(isGenre ? "genre" : "artist")),
        ),
      );
    }

    void shuffleArtistToQueue() {
      // linear order is used in this case since we don't want to affect the rest of the queue
      List<BaseItemDto> clonedItems = List.from(items);
      clonedItems.shuffle();
      queueService.addToQueue(
          items: clonedItems,
          source: QueueItemSource(
            type: isGenre
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.nextUpArtist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmShuffleToQueue),
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
                      child: ArtistItemInfo(
                        item: parentItem,
                        itemSongs: items.length,
                        itemAlbums: parentItem.childCount ?? 0,
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
                            onPressed: () => playAllFromArtist(),
                            icon: const Icon(Icons.play_arrow),
                            label: Text(
                                AppLocalizations.of(context)!.playButtonLabel),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8)),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => shuffleAllFromArtist(),
                            icon: const Icon(Icons.shuffle),
                            label: Text(AppLocalizations.of(context)!
                                .shuffleButtonLabel),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                                visualDensity: VisualDensity.compact),
                            onPressed: () => addArtistNext(),
                            icon: const Icon(Icons.hourglass_bottom),
                            label: Text(AppLocalizations.of(context)!.playNext),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8)),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                                visualDensity: VisualDensity.compact),
                            onPressed: () => shuffleArtistNext(),
                            icon: const Icon(Icons.hourglass_bottom),
                            label:
                                Text(AppLocalizations.of(context)!.shuffleNext),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                                visualDensity: VisualDensity.compact),
                            onPressed: () => addArtistToNextUp(),
                            icon: const Icon(Icons.hourglass_top),
                            label:
                                Text(AppLocalizations.of(context)!.addToNextUp),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8)),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                                visualDensity: VisualDensity.compact),
                            onPressed: () => shuffleArtistToNextUp(),
                            icon: const Icon(Icons.hourglass_top),
                            label: Text(
                                AppLocalizations.of(context)!.shuffleToNextUp),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                                visualDensity: VisualDensity.compact),
                            onPressed: () => addArtistToQueue(),
                            icon: const Icon(Icons.queue_music),
                            label:
                                Text(AppLocalizations.of(context)!.addToQueue),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8)),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                                visualDensity: VisualDensity.compact),
                            onPressed: () => shuffleArtistToQueue(),
                            icon: const Icon(Icons.queue_music),
                            label: Text(
                                AppLocalizations.of(context)!.shuffleToQueue),
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
