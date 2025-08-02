import 'dart:async';

import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/artist_menu.dart';
import 'package:finamp/menus/components/overflow_menu_button.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../../services/queue_service.dart';
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
            pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource,
          ),
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
            pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource,
          ),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.shuffled,
      );
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
                    SizedBox(height: 125, child: AlbumImage(item: parentItem, tapToZoom: true)),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
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
                    ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
