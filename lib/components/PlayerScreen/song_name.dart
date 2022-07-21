import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../screens/album_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
import '../artists_text_spans.dart';

/// Creates some text that shows the song's name, album and the artist.
class SongName extends StatelessWidget {
  const SongName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    final textColour =
        Theme.of(context).textTheme.bodyText2?.color?.withOpacity(0.6);

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final MediaItem mediaItem = snapshot.data!;
          BaseItemDto songBaseItemDto =
              BaseItemDto.fromJson(mediaItem.extras!["itemJson"]);

          return SongNameContent(
              songBaseItemDto: songBaseItemDto,
              mediaItem: mediaItem,
              separatedArtistTextSpans: ArtistsTextSpans(
                songBaseItemDto,
                textColour,
                context,
                true,
              ));
        }

        return const SongNameContent(
          songBaseItemDto: null,
          mediaItem: null,
          separatedArtistTextSpans: [],
        );
      },
    );
  }
}

class SongNameContent extends StatelessWidget {
  const SongNameContent({
    Key? key,
    required this.songBaseItemDto,
    required this.mediaItem,
    required this.separatedArtistTextSpans,
  }) : super(key: key);
  final BaseItemDto? songBaseItemDto;
  final MediaItem? mediaItem;
  final List<TextSpan> separatedArtistTextSpans;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    final textColour =
        Theme.of(context).textTheme.bodyText2?.color?.withOpacity(0.6);

    return Column(children: [
      GestureDetector(
        onTap: songBaseItemDto == null
            ? null
            : () => jellyfinApiHelper
                .getItemById(songBaseItemDto!.albumId as String)
                .then((album) => Navigator.of(context)
                    .popAndPushNamed(AlbumScreen.routeName, arguments: album)),
        child: Text(
          mediaItem == null ? "No Album" : mediaItem!.album ?? "No Album",
          style: TextStyle(color: textColour),
          textAlign: TextAlign.center,
        ),
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
      Text(
        mediaItem == null ? "No Item" : mediaItem!.title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        overflow: TextOverflow.fade,
        softWrap: false,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
      RichText(
        text: TextSpan(
          children: mediaItem == null || mediaItem!.artist == null
              ? [
                  TextSpan(
                    text: "No Artist",
                    style: TextStyle(color: textColour),
                  )
                ]
              : separatedArtistTextSpans,
        ),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}
