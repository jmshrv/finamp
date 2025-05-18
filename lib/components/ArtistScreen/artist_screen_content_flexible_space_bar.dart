import 'dart:async';

import 'package:collection/collection.dart';
import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../album_image.dart';
import 'artist_item_info.dart';

enum ArtistMenuItems {
  playNext,
  addToNextUp,
  addToQueue,
  shuffleNext,
  shuffleToNextUp,
  shuffleToQueue,
  shuffleAlbums,
  shuffleAlbumsNext,
  shuffleAlbumsToNextUp,
  shuffleAlbumsToQueue,
}

class ArtistScreenContentFlexibleSpaceBar extends StatelessWidget {
  const ArtistScreenContentFlexibleSpaceBar({
    super.key,
    required this.parentItem,
    required this.isGenre,
    required this.allTracks,
    required this.albumCount,
    this.genreFilter,
    this.updateGenreFilter,
  });

  final BaseItemDto parentItem;
  final bool isGenre;
  final Future<List<BaseItemDto>?> allTracks;
  final int albumCount;
  final BaseItemDto? genreFilter;
  final void Function(BaseItemDto?)? updateGenreFilter;


  @override
  Widget build(BuildContext context) {
    GetIt.instance<AudioServiceHelper>();
    QueueService queueService = GetIt.instance<QueueService>();

    void playAllFromArtist(List<BaseItemDto> items) {
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

    void shuffleAllFromArtist(List<BaseItemDto> items) {
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

    void shuffleAllFromArtistNext(List<BaseItemDto> items) {
      final shuffled = items..shuffle();
      queueService.addNext(
        items: shuffled,
        source: QueueItemSource(
          type: isGenre
              ? QueueItemSourceType.genre
              : QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext,
          isConfirmation: true);
    }

    void shuffleAllFromArtistToNextUp(List<BaseItemDto> items) {
      final shuffled = items..shuffle();
      queueService.addNext(
        items: shuffled,
        source: QueueItemSource(
          type: isGenre
              ? QueueItemSourceType.genre
              : QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
          isConfirmation: true);
    }

    void shuffleAllFromArtistToQueue(List<BaseItemDto> items) {
      final shuffled = items..shuffle();
      queueService.addNext(
        items: shuffled,
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
      );
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
          isConfirmation: true);
    }

    void addArtistNext(List<BaseItemDto> items) {
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
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!
              .confirmPlayNext(isGenre ? "genre" : "artist"),
          isConfirmation: true);
    }

    void addArtistToNextUp(List<BaseItemDto> items) {
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
          ));
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!
              .confirmAddToNextUp(isGenre ? "genre" : "artist"),
          isConfirmation: true);
    }

    void addArtistToQueue(List<BaseItemDto> items) {
      queueService.addToQueue(
          items: items,
          source: QueueItemSource(
            type: isGenre
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.artist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!
              .confirmAddToQueue(isGenre ? "genre" : "artist"),
          isConfirmation: true);
    }

    void shuffleAlbumsFromArtist(List<BaseItemDto> items) {
      var tracks =
          (items.groupListsBy((element) => element.albumId).values.toList()
                ..shuffle())
              .flattened
              .toList();

      queueService.startPlayback(
        items: tracks,
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

    void shuffleAlbumsFromArtistNext(List<BaseItemDto> items) {
      var tracks =
          (items.groupListsBy((element) => element.albumId).values.toList()
                ..shuffle())
              .flattened
              .toList();

      queueService.addNext(
        items: tracks,
        source: QueueItemSource(
          type: isGenre
              ? QueueItemSourceType.genre
              : QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext,
          isConfirmation: true);
    }

    void shuffleAlbumsFromArtistToNextUp(List<BaseItemDto> items) {
      var tracks =
          (items.groupListsBy((element) => element.albumId).values.toList()
                ..shuffle())
              .flattened
              .toList();

      queueService.addToNextUp(
        items: tracks,
        source: QueueItemSource(
          type: isGenre
              ? QueueItemSourceType.genre
              : QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
          isConfirmation: true);
    }

    void shuffleAlbumsFromArtistToQueue(List<BaseItemDto> items) {
      var tracks =
          (items.groupListsBy((element) => element.albumId).values.toList()
                ..shuffle())
              .flattened
              .toList();

      queueService.addToQueue(
        items: tracks,
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
      );
      GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
          isConfirmation: true);
    }

    return FlexibleSpaceBar(
      background: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 125,
                      child: TapToZoomImage(
                          albumImage: AlbumImage(item: parentItem)),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    FutureBuilder(
                      future: allTracks,
                      builder: (context, snapshot) => Expanded(
                        flex: 2,
                        child: ArtistItemInfo(
                          item: parentItem,
                          itemTracks: snapshot.data?.length ?? 0,
                          itemAlbums: albumCount,
                          genreFilter: genreFilter,
                          updateGenreFilter: updateGenreFilter,
                        ),
                      ),
                    )
                  ],
                ),
                // We don't want to add a whole genre to the queue
                if (!isGenre)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
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
                                  onPressed: () => allTracks.then((items) =>
                                      playAllFromArtist(items ?? [])),
                                  // set the minimum width as 25% of the screen width,
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                                PopupMenuButton<ArtistMenuItems>(
                                  enableFeedback: true,
                                  // icon: const Icon(TablerIcons.dots_vertical),
                                  onOpened: () => FeedbackHelper.feedback(
                                      FeedbackType.light),
                                  itemBuilder: (context) {
                                    final queueService =
                                        GetIt.instance<QueueService>();
                                    return <PopupMenuEntry<ArtistMenuItems>>[
                                      if (queueService
                                          .getQueue()
                                          .nextUp
                                          .isNotEmpty)
                                        PopupMenuItem<ArtistMenuItems>(
                                          value: ArtistMenuItems.playNext,
                                          child: ListTile(
                                            leading: const Icon(
                                                TablerIcons.corner_right_down),
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .playNext),
                                          ),
                                        ),
                                      PopupMenuItem<ArtistMenuItems>(
                                        value: ArtistMenuItems.addToNextUp,
                                        child: ListTile(
                                          leading: const Icon(TablerIcons
                                              .corner_right_down_double),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .addToNextUp),
                                        ),
                                      ),
                                      PopupMenuItem<ArtistMenuItems>(
                                        value: ArtistMenuItems.addToQueue,
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
                                  onSelected:
                                      (ArtistMenuItems selection) async {
                                    switch (selection) {
                                      case ArtistMenuItems.playNext:
                                        unawaited(allTracks.then((items) =>
                                            addArtistNext(items ?? [])));
                                        break;
                                      case ArtistMenuItems.addToNextUp:
                                        unawaited(allTracks.then((items) =>
                                            addArtistToNextUp(items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleNext:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAllFromArtistNext(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleToNextUp:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAllFromArtistToNextUp(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.addToQueue:
                                        unawaited(allTracks.then((items) =>
                                            addArtistToQueue(items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleToQueue:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAllFromArtistToQueue(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleAlbums:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAlbumsFromArtist(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleAlbumsNext:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAlbumsFromArtistNext(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems
                                            .shuffleAlbumsToNextUp:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAlbumsFromArtistToNextUp(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleAlbumsToQueue:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAlbumsFromArtistToQueue(
                                                items ?? [])));
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
                                  onPressed: () => allTracks.then((items) =>
                                      shuffleAllFromArtist(items ?? [])),
                                  // set the minimum width as 25% of the screen width,
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                                PopupMenuButton<ArtistMenuItems>(
                                  enableFeedback: true,
                                  // icon: const Icon(TablerIcons.dots_vertical),
                                  onOpened: () => FeedbackHelper.feedback(
                                      FeedbackType.light),
                                  itemBuilder: (context) {
                                    final queueService =
                                        GetIt.instance<QueueService>();
                                    return <PopupMenuEntry<ArtistMenuItems>>[
                                      if (queueService
                                          .getQueue()
                                          .nextUp
                                          .isNotEmpty)
                                        PopupMenuItem<ArtistMenuItems>(
                                          value: ArtistMenuItems.shuffleNext,
                                          child: ListTile(
                                            leading: const Icon(
                                                TablerIcons.corner_right_down),
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .shuffleNext),
                                          ),
                                        ),
                                      PopupMenuItem<ArtistMenuItems>(
                                        value: ArtistMenuItems.shuffleToNextUp,
                                        child: ListTile(
                                          leading: const Icon(TablerIcons
                                              .corner_right_down_double),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .shuffleToNextUp),
                                        ),
                                      ),
                                      PopupMenuItem<ArtistMenuItems>(
                                        value: ArtistMenuItems.shuffleToQueue,
                                        child: ListTile(
                                          leading:
                                              const Icon(TablerIcons.playlist),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .shuffleToQueue),
                                        ),
                                      ),
                                      PopupMenuItem<ArtistMenuItems>(
                                        value: ArtistMenuItems.shuffleAlbums,
                                        child: ListTile(
                                          leading:
                                              const Icon(TablerIcons.playlist),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .shuffleAlbums),
                                        ),
                                      ),
                                      if (queueService
                                          .getQueue()
                                          .nextUp
                                          .isNotEmpty)
                                        PopupMenuItem<ArtistMenuItems>(
                                          value:
                                              ArtistMenuItems.shuffleAlbumsNext,
                                          child: ListTile(
                                            leading: const Icon(
                                                TablerIcons.corner_right_down),
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .shuffleAlbumsNext),
                                          ),
                                        ),
                                      PopupMenuItem<ArtistMenuItems>(
                                        value: ArtistMenuItems
                                            .shuffleAlbumsToNextUp,
                                        child: ListTile(
                                          leading: const Icon(TablerIcons
                                              .corner_right_down_double),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .shuffleAlbumsToNextUp),
                                        ),
                                      ),
                                      PopupMenuItem<ArtistMenuItems>(
                                        value: ArtistMenuItems
                                            .shuffleAlbumsToQueue,
                                        child: ListTile(
                                          leading:
                                              const Icon(TablerIcons.playlist),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .shuffleAlbumsToQueue),
                                        ),
                                      ),
                                    ];
                                  },
                                  onSelected:
                                      (ArtistMenuItems selection) async {
                                    switch (selection) {
                                      case ArtistMenuItems.playNext:
                                        unawaited(allTracks.then((items) =>
                                            addArtistNext(items ?? [])));
                                        break;
                                      case ArtistMenuItems.addToNextUp:
                                        unawaited(allTracks.then((items) =>
                                            addArtistToNextUp(items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleNext:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAllFromArtistNext(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleToNextUp:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAllFromArtistToNextUp(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.addToQueue:
                                        unawaited(allTracks.then((items) =>
                                            addArtistToQueue(items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleToQueue:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAllFromArtistToQueue(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleAlbums:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAlbumsFromArtist(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleAlbumsNext:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAlbumsFromArtistNext(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems
                                            .shuffleAlbumsToNextUp:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAlbumsFromArtistToNextUp(
                                                items ?? [])));
                                        break;
                                      case ArtistMenuItems.shuffleAlbumsToQueue:
                                        unawaited(allTracks.then((items) =>
                                            shuffleAlbumsFromArtistToQueue(
                                                items ?? [])));
                                        break;
                                      default:
                                        break;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ]),
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
