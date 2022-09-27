import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/album_screen.dart';
import '../../services/jellyfin_api_helper.dart';
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
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mediaItem.title,
          style: GoogleFonts.lexendDeca(
            fontSize: 16,
            height: 20 / 16,
          ),
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
        ArtistChip(item: songBaseItemDto!),
        GestureDetector(
          onTap: songBaseItemDto == null
              ? null
              : () => jellyfinApiHelper
                  .getItemById(songBaseItemDto!.albumId as String)
                  .then((album) => Navigator.of(context).popAndPushNamed(
                      AlbumScreen.routeName,
                      arguments: album)),
          child: Text(
            mediaItem.album ?? AppLocalizations.of(context)!.noAlbum,
            style: GoogleFonts.lexendDeca(
              color: secondaryTextColour,
              fontWeight: FontWeight.w300,
              fontSize: 14,
              height: 17.5 / 14,
            ),
          ),
        ),
      ],
    );
  }
}
