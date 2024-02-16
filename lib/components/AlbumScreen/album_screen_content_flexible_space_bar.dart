import 'dart:io';
import 'dart:math';

import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../album_image.dart';
import 'item_info.dart';

enum AlbumMenuItems {
  addFavourite,
  removeFavourite,
  addToMixList,
  removeFromMixList,
  playNext,
  addToNextUp,
  shuffleNext,
  shuffleToNextUp,
  addToQueue,
  shuffleToQueue,
}

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
    GetIt.instance<AudioServiceHelper>();
    QueueService queueService = GetIt.instance<QueueService>();

    void playAlbum() {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type: isPlaylist
              ? QueueItemSourceType.playlist
              : QueueItemSourceType.album,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
          contextLufs: (isPlaylist || parentItem.lufs == 0.0) ? null : parentItem.lufs, // album LUFS sometimes end up being simply `0`, but that's not the actual value
        ),
        order: FinampPlaybackOrder.linear,
      );
    }

    void shuffleAlbum() {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type: isPlaylist
              ? QueueItemSourceType.playlist
              : QueueItemSourceType.album,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
          contextLufs: (isPlaylist || parentItem.lufs == 0.0) ? null : parentItem.lufs, // album LUFS sometimes end up being simply `0`, but that's not the actual value
        ),
        order: FinampPlaybackOrder.shuffled,
      );
    }

    void addAlbumToNextUp() {
      queueService.addToNextUp(
        items: items,
        source: QueueItemSource(
          type: isPlaylist
              ? QueueItemSourceType.nextUpPlaylist
              : QueueItemSourceType.nextUpAlbum,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
          contextLufs: (isPlaylist || parentItem.lufs == 0.0) ? null : parentItem.lufs, // album LUFS sometimes end up being simply `0`, but that's not the actual value
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .confirmAddToNextUp(isPlaylist ? "playlist" : "album")),
        ),
      );
    }

    void addAlbumNext() {
      queueService.addNext(
          items: items,
          source: QueueItemSource(
            type: isPlaylist
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.nextUpAlbum,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
            contextLufs: (isPlaylist || parentItem.lufs == 0.0) ? null : parentItem.lufs, // album LUFS sometimes end up being simply `0`, but that's not the actual value
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .confirmPlayNext(isPlaylist ? "playlist" : "album")),
        ),
      );
    }

    void shuffleAlbumToNextUp() {
      // linear order is used in this case since we don't want to affect the rest of the queue
      List<BaseItemDto> clonedItems = List.from(items);
      clonedItems.shuffle();
      queueService.addToNextUp(
          items: clonedItems,
          source: QueueItemSource(
            type: isPlaylist
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.nextUpAlbum,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
            contextLufs: (isPlaylist || parentItem.lufs == 0.0) ? null : parentItem.lufs, // album LUFS sometimes end up being simply `0`, but that's not the actual value
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmShuffleToNextUp),
        ),
      );
    }

    void shuffleAlbumNext() {
      // linear order is used in this case since we don't want to affect the rest of the queue
      List<BaseItemDto> clonedItems = List.from(items);
      clonedItems.shuffle();
      queueService.addNext(
          items: clonedItems,
          source: QueueItemSource(
            type: isPlaylist
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.nextUpAlbum,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
            contextLufs: (isPlaylist || parentItem.lufs == 0.0) ? null : parentItem.lufs, // album LUFS sometimes end up being simply `0`, but that's not the actual value
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmShuffleNext),
        ),
      );
    }

    void addAlbumToQueue() {
      queueService.addToQueue(
        items: items,
        source: QueueItemSource(
          type: isPlaylist
              ? QueueItemSourceType.playlist
              : QueueItemSourceType.album,
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
              .confirmAddToQueue(isPlaylist ? "playlist" : "album")),
        ),
      );
    }

    void shuffleAlbumToQueue() {
      // linear order is used in this case since we don't want to affect the rest of the queue
      List<BaseItemDto> clonedItems = List.from(items);
      clonedItems.shuffle();
      queueService.addToQueue(
          items: clonedItems,
          source: QueueItemSource(
            type: isPlaylist
                ? QueueItemSourceType.playlist
                : QueueItemSourceType.album,
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
                      child: ItemInfo(
                        item: parentItem,
                        itemSongs: items.length,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CTAMedium(
                                  text: AppLocalizations.of(context)!
                                      .playButtonLabel,
                                  icon: TablerIcons.player_play,
                                  onPressed: () => playAlbum(),
                                  minWidth: 100.0,
                                ),
                                PopupMenuButton<AlbumMenuItems>(
                                  enableFeedback: true,
                                  icon: const Icon(TablerIcons.dots_vertical),
                                  onOpened: () =>
                                      Vibrate.feedback(FeedbackType.light),
                                  itemBuilder: (context) {
                                    final queueService =
                                        GetIt.instance<QueueService>();
                                    return <PopupMenuEntry<AlbumMenuItems>>[
                                      if (queueService
                                          .getQueue()
                                          .nextUp
                                          .isNotEmpty)
                                        PopupMenuItem<AlbumMenuItems>(
                                          value: AlbumMenuItems.playNext,
                                          child: ListTile(
                                            leading: const Icon(
                                                TablerIcons.corner_right_down),
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .playNext),
                                          ),
                                        ),
                                      PopupMenuItem<AlbumMenuItems>(
                                        value: AlbumMenuItems.addToNextUp,
                                        child: ListTile(
                                          leading:
                                              const Icon(TablerIcons.corner_right_down_double),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .addToNextUp),
                                        ),
                                      ),
                                      PopupMenuItem<AlbumMenuItems>(
                                        value: AlbumMenuItems.addToQueue,
                                        child: ListTile(
                                          leading:
                                              const Icon(TablerIcons.playlist),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .addToQueue),
                                        ),
                                      ),
                                    ];
                                  },
                                  onSelected: (AlbumMenuItems selection) async {
                                    switch (selection) {
                                      case AlbumMenuItems.playNext:
                                        addAlbumNext();
                                        break;
                                      case AlbumMenuItems.addToNextUp:
                                        addAlbumToNextUp();
                                        break;
                                      case AlbumMenuItems.shuffleNext:
                                        shuffleAlbumNext();
                                        break;
                                      case AlbumMenuItems.shuffleToNextUp:
                                        shuffleAlbumToNextUp();
                                        break;
                                      case AlbumMenuItems.addToQueue:
                                        addAlbumToQueue();
                                        break;
                                      case AlbumMenuItems.shuffleToQueue:
                                        shuffleAlbumToQueue();
                                        break;
                                      default:
                                        break;
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CTAMedium(
                                  text: AppLocalizations.of(context)!
                                      .shuffleButtonLabel,
                                  icon: TablerIcons.arrows_shuffle,
                                  onPressed: () => shuffleAlbum(),
                                  minWidth: 100.0,
                                ),
                                PopupMenuButton<AlbumMenuItems>(
                                  enableFeedback: true,
                                  icon: const Icon(TablerIcons.dots_vertical),
                                  onOpened: () =>
                                      Vibrate.feedback(FeedbackType.light),
                                  itemBuilder: (context) {
                                    final queueService =
                                        GetIt.instance<QueueService>();
                                    return <PopupMenuEntry<AlbumMenuItems>>[
                                      if (queueService
                                          .getQueue()
                                          .nextUp
                                          .isNotEmpty)
                                        PopupMenuItem<AlbumMenuItems>(
                                          value: AlbumMenuItems.shuffleNext,
                                          child: ListTile(
                                            leading: const Icon(
                                                TablerIcons.corner_right_down),
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .shuffleNext),
                                          ),
                                        ),
                                      PopupMenuItem<AlbumMenuItems>(
                                        value: AlbumMenuItems.shuffleToNextUp,
                                        child: ListTile(
                                          leading:
                                              const Icon(TablerIcons.corner_right_down_double),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .shuffleToNextUp),
                                        ),
                                      ),
                                      PopupMenuItem<AlbumMenuItems>(
                                        value: AlbumMenuItems.shuffleToQueue,
                                        child: ListTile(
                                          leading:
                                              const Icon(TablerIcons.playlist),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .shuffleToQueue),
                                        ),
                                      ),
                                    ];
                                  },
                                  onSelected: (AlbumMenuItems selection) async {
                                    switch (selection) {
                                      case AlbumMenuItems.playNext:
                                        addAlbumNext();
                                        break;
                                      case AlbumMenuItems.addToNextUp:
                                        addAlbumToNextUp();
                                        break;
                                      case AlbumMenuItems.shuffleNext:
                                        shuffleAlbumNext();
                                        break;
                                      case AlbumMenuItems.shuffleToNextUp:
                                        shuffleAlbumToNextUp();
                                        break;
                                      case AlbumMenuItems.addToQueue:
                                        addAlbumToQueue();
                                        break;
                                      case AlbumMenuItems.shuffleToQueue:
                                        shuffleAlbumToQueue();
                                        break;
                                      default:
                                        break;
                                    }
                                  },
                                ),
                              ],
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
