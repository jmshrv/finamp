import 'package:balanced_text/balanced_text.dart';
import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_button.dart';
import 'package:finamp/components/PlayerScreen/player_buttons_more.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          // show loading indicator
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
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                      maxHeight:
                          controller.shouldShow(PlayerHideable.twoLineTitle)
                              ? 52
                              : 24,
                      maxWidth: 280,
                    ),
                    child: Semantics.fromProperties(
                      properties: SemanticsProperties(
                        label:
                            "${currentTrack.item.title} (${AppLocalizations.of(context)!.title})",
                      ),
                      excludeSemantics: true,
                      container: true,
                      child: BalancedText(
                        currentTrack.item.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          height: 26 / 20,
                          fontWeight:
                              Theme.of(context).brightness == Brightness.light
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                          overflow: TextOverflow.visible,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines:
                            controller.shouldShow(PlayerHideable.twoLineTitle)
                                ? 2
                                : 1,
                      ),
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
