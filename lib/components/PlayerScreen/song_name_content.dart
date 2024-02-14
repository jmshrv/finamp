import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/PlayerScreen/player_buttons_more.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:flutter/material.dart';
import 'package:balanced_text/balanced_text.dart';

import '../favourite_button.dart';
import 'album_chip.dart';
import 'artist_chip.dart';

class SongNameContent extends StatelessWidget {
  const SongNameContent(
      {Key? key,
      required this.currentTrack,
      required this.secondaryTextColour})
      : super(key: key);
  final FinampQueueItem currentTrack;
  final Color? secondaryTextColour;

  @override
  Widget build(BuildContext context) {
    final jellyfin_models.BaseItemDto? songBaseItemDto =
        currentTrack.item.extras!["itemJson"] != null
            ? jellyfin_models.BaseItemDto.fromJson(
                currentTrack.item.extras!["itemJson"])
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(
              maxHeight: 60,
            ),
            child: BalancedText(
              currentTrack.item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                // height: 24 / 20,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlayerButtonsMore(item: songBaseItemDto),
            Flexible(
              child: ArtistChips(
                baseItem: songBaseItemDto,
                backgroundColor: IconTheme.of(context).color!.withOpacity(0.1),
                key: songBaseItemDto?.albumArtist == null
                    ? null
                    // We have to add -artist and -album to the keys because otherwise
                    // self-titled albums (e.g. Aerosmith by Aerosmith) will break due
                    // to duplicate keys.
                    // Its probably more efficient to put a single character instead
                    // of a whole 6-7 characters, but I think we can spare the CPU
                    // cycles.
                    : ValueKey("${songBaseItemDto!.albumArtist}-artist"),
              ),
            ),
            FavoriteButton(
              item: songBaseItemDto,
              onToggle: (isFavorite) {
                songBaseItemDto!.userData!.isFavorite = isFavorite;
                currentTrack.item.extras!["itemJson"] =
                    songBaseItemDto.toJson();
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: AlbumChip(
            item: songBaseItemDto,
            backgroundColor: IconTheme.of(context).color!.withOpacity(0.1),
            key: songBaseItemDto?.album == null
                ? null
                : ValueKey("${songBaseItemDto!.album}-album"),
          ),
        ),
      ],
    );
  }
}
