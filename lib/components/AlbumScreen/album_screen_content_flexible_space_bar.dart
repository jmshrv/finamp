import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/feedback_helper.dart';
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
          contextNormalizationGain:
              isPlaylist ? null : parentItem.normalizationGain,
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
          contextNormalizationGain:
              isPlaylist ? null : parentItem.normalizationGain,
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
          contextNormalizationGain:
              isPlaylist ? null : parentItem.normalizationGain,
        ),
      );
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!
              .confirmAddToNextUp(isPlaylist ? "playlist" : "album"),
          isConfirmation: true);
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
            contextNormalizationGain:
                isPlaylist ? null : parentItem.normalizationGain,
          ));
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!
              .confirmPlayNext(isPlaylist ? "playlist" : "album"),
          isConfirmation: true);
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
            contextNormalizationGain:
                isPlaylist ? null : parentItem.normalizationGain,
          ));
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
          isConfirmation: true);
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
            contextNormalizationGain:
                isPlaylist ? null : parentItem.normalizationGain,
          ));
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext,
          isConfirmation: true);
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
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!
              .confirmAddToQueue(isPlaylist ? "playlist" : "album"),
          isConfirmation: true);
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
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
          isConfirmation: true);
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
                                      .playButtonLabel
                                      .toUpperCase(),
                                  icon: TablerIcons.player_play,
                                  onPressed: () => playAlbum(),
                                  // set the minimum width as 25% of the screen width,
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                                PopupMenuButton<AlbumMenuItems>(
                                  enableFeedback: true,
                                  icon: const Icon(TablerIcons.dots_vertical),
                                  onOpened: () => FeedbackHelper.feedback(
                                      FeedbackType.light),
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
                                          leading: const Icon(TablerIcons
                                              .corner_right_down_double),
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
                                      .shuffleButtonLabel
                                      .toUpperCase(),
                                  icon: TablerIcons.arrows_shuffle,
                                  onPressed: () => shuffleAlbum(),
                                  // set the minimum width as 25% of the screen width,
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                                PopupMenuButton<AlbumMenuItems>(
                                  enableFeedback: true,
                                  icon: const Icon(TablerIcons.dots_vertical),
                                  onOpened: () => FeedbackHelper.feedback(
                                      FeedbackType.light),
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
                                          leading: const Icon(TablerIcons
                                              .corner_right_down_double),
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
