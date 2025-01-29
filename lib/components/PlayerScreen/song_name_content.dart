import 'package:finamp/screens/player_screen.dart';
import 'package:finamp/services/scrolling_text_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_button.dart';
import 'package:finamp/components/PlayerScreen/player_buttons_more.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:get_it/get_it.dart';

import '../../services/queue_service.dart';
import 'album_chip.dart';
import 'artist_chip.dart';

class SongNameContent extends StatelessWidget {
  const SongNameContent(
    this.controller, {
    super.key,
  });

  final PlayerHideableController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FinampQueueInfo?>(
      stream: GetIt.instance<QueueService>().getQueueStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.currentTrack == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final currentTrack = snapshot.data!.currentTrack!;
        final jellyfin_models.BaseItemDto? songBaseItemDto =
            currentTrack.baseItem;

        return LayoutBuilder(builder: (context, constraints) {
          double padding = ((constraints.maxWidth - 260) / 4).clamp(0, 20);
          return Padding(
            padding:
                EdgeInsets.only(left: padding, right: padding, bottom: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 280,
                    ),
                    child: ScrollingTextHelper(
                      id: ValueKey(currentTrack.item.id),
                      text: currentTrack.item.title,
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontWeight:
                            Theme.of(context).brightness == Brightness.light
                                ? FontWeight.w500
                                : FontWeight.w600,
                      ),
                      alignment: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlayerButtonsMore(
                        item: songBaseItemDto, queueItem: currentTrack),
                    Flexible(
                      child: ArtistChips(
                        baseItem: songBaseItemDto,
                        backgroundColor:
                            IconTheme.of(context).color!.withOpacity(0.1),
                      ),
                    ),
                    AddToPlaylistButton(
                      item: songBaseItemDto,
                      queueItem: currentTrack,
                    ),
                  ],
                ),
                AlbumChip(
                  item: songBaseItemDto,
                  backgroundColor:
                      IconTheme.of(context).color!.withOpacity(0.1),
                  key: songBaseItemDto?.album == null
                      ? null
                      : ValueKey("${songBaseItemDto!.album}-album"),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
