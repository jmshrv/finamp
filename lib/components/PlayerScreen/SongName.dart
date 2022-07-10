import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../screens/AlbumScreen.dart';
import '../../screens/ArtistScreen.dart';
import '../../services/FinampSettingsHelper.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/MusicPlayerBackgroundTask.dart';

/// Creates some text that shows the song's name, album and the artist.
class SongName extends StatelessWidget {
  const SongName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final jellyfinApiData = GetIt.instance<JellyfinApiData>();

    final textColour =
        Theme.of(context).textTheme.bodyText2?.color?.withOpacity(0.6);

    return StreamBuilder<MediaItem?>(
      stream: _audioHandler.mediaItem,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final MediaItem mediaItem = snapshot.data!;
          BaseItemDto songBaseItemDto =
              BaseItemDto.fromJson(mediaItem.extras!["itemJson"]);

          List<TextSpan> separatedArtistTextSpans = [];
          songBaseItemDto.artistItems
              ?.map((e) => TextSpan(
                  text: e.name,
                  style: TextStyle(color: textColour),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Offline artists aren't implemented yet so we return if
                      // offline
                      if (FinampSettingsHelper.finampSettings.isOffline) return;

                      jellyfinApiData.getItemById(e.id).then((artist) =>
                          Navigator.of(context).popAndPushNamed(
                              ArtistScreen.routeName,
                              arguments: artist));
                    }))
              .forEach((artistTextSpan) {
            separatedArtistTextSpans.add(artistTextSpan);
            separatedArtistTextSpans.add(TextSpan(
              text: ", ",
              style: TextStyle(color: textColour),
            ));
          });
          separatedArtistTextSpans.removeLast();

          return SongNameContent(
              songBaseItemDto: songBaseItemDto,
              mediaItem: mediaItem,
              separatedArtistTextSpans: separatedArtistTextSpans);
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
    final jellyfinApiData = GetIt.instance<JellyfinApiData>();

    final textColour =
        Theme.of(context).textTheme.bodyText2?.color?.withOpacity(0.6);

    return Column(children: [
      GestureDetector(
        onTap: songBaseItemDto == null
            ? null
            : () => jellyfinApiData
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
      ),
    ]);
  }
}
