import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/PlayerScreen/player_buttons_more.dart';
import 'package:finamp/components/PlayerScreen/player_buttons_shuffle.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';

import 'album_chip.dart';
import 'artist_chip.dart';

class SongNameContent extends StatelessWidget {
  const SongNameContent(
      {Key? key,
      required this.songBaseItemDto,
      required this.mediaItem,
      required this.separatedArtistTextSpans,
      required this.secondaryTextColour})
      : super(key: key);
  final BaseItemDto? songBaseItemDto;
  final MediaItem mediaItem;
  final List<TextSpan> separatedArtistTextSpans;
  final Color? secondaryTextColour;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              mediaItem.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                height: 24 / 20,
              ),
              overflow: TextOverflow.fade,
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlayerButtonsMore(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ArtistChip(
                      item: songBaseItemDto,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: AlbumChip(
                      item: songBaseItemDto,
                      key: songBaseItemDto?.album == null
                          ? null
                          : ValueKey("${songBaseItemDto!.album}-album"),
                    ),
                  ),
                ],
              ),
              FavoriteButton(item: songBaseItemDto),
            ],
          ),
        ),
      ],
    );
  }
}
