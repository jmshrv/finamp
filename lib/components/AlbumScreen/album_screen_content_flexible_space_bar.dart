import 'package:finamp/menus/components/playbackActions/playback_action_row.dart';
import 'package:finamp/menus/components/playbackActions/playback_actions.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
    
    final queueService = GetIt.instance<QueueService>();
    final initialPageViewIndex = (queueService.playbackOrder == FinampPlaybackOrder.shuffled) ? 1 : 0;
    final pageViewController = PageController(initialPage: initialPageViewIndex);

    return FlexibleSpaceBar(
      background: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: 8,
              right: 8,
              bottom: MediaQuery.of(context).padding.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(height: 125, child: AlbumImage(item: parentItem, tapToZoom: true)),
                      const SizedBox(width: 4),
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
                  SizedBox(height: 20),
                  PlaybackActionRow(
                    controller: pageViewController,
                    playbackActionPages: getPlaybackActionPages(
                      context: context,
                      item: parentItem,
                      popContext: false,
                      genreFilter: genreFilter,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
