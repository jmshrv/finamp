import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/album_menu.dart';
import 'package:finamp/menus/components/overflow_menu_button.dart';
import 'package:finamp/menus/playlist_menu.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../album_image.dart';
import 'item_info.dart';

enum AlbumMenuItems {
  addFavorite,
  removeFavorite,
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
    super.key,
    required this.parentItem,
    required this.isPlaylist,
    required this.items,
    this.genreFilter,
    this.updateGenreFilter,
  });

  final BaseItemDto parentItem;
  final bool isPlaylist;
  final List<BaseItemDto> items;
  final BaseItemDto? genreFilter;
  final void Function(BaseItemDto?)? updateGenreFilter;

  @override
  Widget build(BuildContext context) {
    GetIt.instance<AudioServiceHelper>();
    QueueService queueService = GetIt.instance<QueueService>();

    void playAlbum() {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type: isPlaylist ? QueueItemSourceType.playlist : QueueItemSourceType.album,
          name: QueueItemSourceName(
            type: QueueItemSourceNameType.preTranslated,
            pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource,
          ),
          id: parentItem.id,
          item: parentItem,
          contextNormalizationGain: isPlaylist ? null : parentItem.normalizationGain,
        ),
        order: FinampPlaybackOrder.linear,
      );
    }

    void shuffleAlbum() {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type: isPlaylist ? QueueItemSourceType.playlist : QueueItemSourceType.album,
          name: QueueItemSourceName(
            type: QueueItemSourceNameType.preTranslated,
            pretranslatedName: parentItem.name ?? AppLocalizations.of(context)!.placeholderSource,
          ),
          id: parentItem.id,
          item: parentItem,
          contextNormalizationGain: isPlaylist ? null : parentItem.normalizationGain,
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
                    Expanded(
                      flex: 2,
                      child: ItemInfo(
                        item: parentItem,
                        itemTracks: items,
                        genreFilter: genreFilter,
                        updateGenreFilter: updateGenreFilter,
                      ),
                    ),
                  ],
                ),
                //TODO instead of making this scrollable, we could hide any additional buttons on overflow and put them into the overflow menu?
                // that would however mean that the layout is different (but pretty static) across different languages, which is kinda strange
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                  child: Wrap(
                    spacing: 8.0,
                    alignment: WrapAlignment.spaceEvenly,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CTAMedium(
                        text: AppLocalizations.of(context)!.playButtonLabel,
                        icon: TablerIcons.player_play,
                        onPressed: () => playAlbum(),
                        // set the minimum width as 25% of the screen width,
                        minWidth: MediaQuery.of(context).size.width * 0.25,
                      ),
                      CTAMedium(
                        text: AppLocalizations.of(context)!.shuffleButtonLabel,
                        icon: TablerIcons.arrows_shuffle,
                        onPressed: () => shuffleAlbum(),
                        // set the minimum width as 25% of the screen width,
                        minWidth: MediaQuery.of(context).size.width * 0.25,
                      ),
                      OverflowMenuButton(
                        onPressed: () => isPlaylist
                            ? showModalPlaylistMenu(context: context, baseItem: parentItem)
                            : showModalAlbumMenu(context: context, baseItem: parentItem),
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
