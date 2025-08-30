import 'dart:async';

import 'package:finamp/menus/components/playbackActions/playback_action_row.dart';
import 'package:finamp/menus/components/playbackActions/playback_actions.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class ArtistScreenContentFlexibleSpaceBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    GetIt.instance<AudioServiceHelper>();
    final queueService = GetIt.instance<QueueService>();

    final lastUsedPlaybackActionRowPage = ref.read(finampSettingsProvider.lastUsedPlaybackActionRowPage);
    final lastUsedPlaybackActionRowPageIndex = lastUsedPlaybackActionRowPage.pageIndexFor(
      nextUpIsEmpty: queueService.getQueue().nextUp.isEmpty,
    );
    final initialPageViewIndex = ref.read(finampSettingsProvider.rememberLastUsedPlaybackActionRowPage)
        ? lastUsedPlaybackActionRowPageIndex
        : 0;
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
                        child: FutureBuilder(
                          future: allTracks,
                          builder: (context, snapshot) {
                            return ArtistItemInfo(
                              item: parentItem,
                              itemTracks: snapshot.data?.length ?? 0,
                              itemAlbums: albumCount,
                              genreFilter: genreFilter,
                              updateGenreFilter: updateGenreFilter,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PlaybackActionRow(
                    controller: pageViewController,
                    compactLayout: true,
                    playbackActionPages: getPlaybackActionPages(
                      context: context,
                      item: parentItem,
                      popContext: false,
                      compactLayout: true,
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
