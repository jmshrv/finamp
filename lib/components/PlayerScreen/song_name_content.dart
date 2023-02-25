import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../screens/album_screen.dart';
import '../../services/jellyfin_api_helper.dart';
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
        Text(
          mediaItem.title,
          style: const TextStyle(
            fontSize: 16,
            height: 20 / 16,
          ),
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
        ArtistChip(
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
        const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
        AlbumChip(
          item: songBaseItemDto,
          key: songBaseItemDto?.album == null
              ? null
              : ValueKey("${songBaseItemDto!.album}-album"),
        )
      ],
    );
  }
}
