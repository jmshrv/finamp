import 'dart:async';

import 'package:collection/collection.dart';
import 'package:finamp/menus/artist_menu.dart';
import 'package:finamp/menus/components/overflow_menu_button.dart';
import 'package:finamp/menus/genre_menu.dart';
import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
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
    required this.allTracks,
    required this.albumCount,
    this.genreFilter,
    this.updateGenreFilter,
  });

  final BaseItemDto parentItem;
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
          type: QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
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
          type: QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
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
          type: QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext, isConfirmation: true);
    }

    void shuffleAllFromArtistToNextUp(List<BaseItemDto> items) {
      final shuffled = items..shuffle();
      queueService.addNext(
        items: shuffled,
        source: QueueItemSource(
          type: QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp, isConfirmation: true);
    }

    void shuffleAllFromArtistToQueue(List<BaseItemDto> items) {
      final shuffled = items..shuffle();
      queueService.addNext(
        items: shuffled,
        source: QueueItemSource(
          type: QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue, isConfirmation: true);
    }

    void addArtistNext(List<BaseItemDto> items) {
      queueService.addNext(
          items: items,
          source: QueueItemSource(
            type: QueueItemSourceType.nextUpArtist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmPlayNext("artist"),
          isConfirmation: true);
    }

    void addArtistToNextUp(List<BaseItemDto> items) {
      queueService.addToNextUp(
          items: items,
          source: QueueItemSource(
            type: QueueItemSourceType.nextUpArtist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmAddToNextUp("artist"),
          isConfirmation: true);
    }

    void addArtistToQueue(List<BaseItemDto> items) {
      queueService.addToQueue(
          items: items,
          source: QueueItemSource(
            type: QueueItemSourceType.artist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmAddToQueue("artist"),
          isConfirmation: true);
    }

    void shuffleAlbumsFromArtist(List<BaseItemDto> items) {
      var tracks = (items.groupListsBy((element) => element.albumId).values.toList()..shuffle()).flattened.toList();

      queueService.startPlayback(
        items: tracks,
        source: QueueItemSource(
          type: QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.linear,
      );
    }

    void shuffleAlbumsFromArtistNext(List<BaseItemDto> items) {
      var tracks = (items.groupListsBy((element) => element.albumId).values.toList()..shuffle()).flattened.toList();

      queueService.addNext(
        items: tracks,
        source: QueueItemSource(
          type: QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext, isConfirmation: true);
    }

    void shuffleAlbumsFromArtistToNextUp(List<BaseItemDto> items) {
      var tracks = (items.groupListsBy((element) => element.albumId).values.toList()..shuffle()).flattened.toList();

      queueService.addToNextUp(
        items: tracks,
        source: QueueItemSource(
          type: QueueItemSourceType.nextUpArtist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp, isConfirmation: true);
    }

    void shuffleAlbumsFromArtistToQueue(List<BaseItemDto> items) {
      var tracks = (items.groupListsBy((element) => element.albumId).values.toList()..shuffle()).flattened.toList();

      queueService.addToQueue(
        items: tracks,
        source: QueueItemSource(
          type: QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
      );
      GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue, isConfirmation: true);
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
                      child: AlbumImage(
                        item: parentItem,
                        tapToZoom: true,
                      ),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                  child: Wrap(
                    spacing: 8.0,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      CTAMedium(
                        text: AppLocalizations.of(context)!.playButtonLabel,
                        icon: TablerIcons.player_play,
                        onPressed: () => allTracks.then((items) => playAllFromArtist(items ?? [])),
                        // set the minimum width as 25% of the screen width,
                        minWidth: MediaQuery.of(context).size.width * 0.25,
                      ),
                      CTAMedium(
                        text: AppLocalizations.of(context)!.shuffleButtonLabel,
                        icon: TablerIcons.arrows_shuffle,
                        onPressed: () => allTracks.then((items) => shuffleAllFromArtist(items ?? [])),
                        // set the minimum width as 25% of the screen width,
                        minWidth: MediaQuery.of(context).size.width * 0.25,
                      ),
                      OverflowMenuButton(
                        onPressed: () => showModalArtistMenu(context: context, baseItem: parentItem),
                        label: AppLocalizations.of(context)!.menuButtonLabel,
                      ),
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
