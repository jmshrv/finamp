import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/scrolling_text_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../screens/album_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
import '../artists_text_spans.dart';

/// Creates some text that shows the track's name, album and the artist.
class TrackName extends StatelessWidget {
  const TrackName({super.key});

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final JellyfinApiHelper jellyfinApiHelper =
        GetIt.instance<JellyfinApiHelper>();

    final textColour = Theme.of(context).colorScheme.onSurface;

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final MediaItem mediaItem = snapshot.data!;
          BaseItemDto trackBaseItemDto =
              BaseItemDto.fromJson(mediaItem.extras!["itemJson"]);

          List<TextSpan> separatedArtistTextSpans = [];

          if (trackBaseItemDto.artistItems?.isEmpty ?? true) {
            separatedArtistTextSpans = [
              TextSpan(
                text: AppLocalizations.of(context)!.unknownArtist,
                style: TextStyle(color: textColour),
              )
            ];
          } else {
            trackBaseItemDto.artistItems
                ?.map((e) => TextSpan(
                    text: e.name,
                    style: TextStyle(color: textColour),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Offline artists aren't implemented yet so we return if
                        // offline
                        if (FinampSettingsHelper.finampSettings.isOffline) {
                          return;
                        }

                        jellyfinApiHelper.getItemById(e.id).then((artist) =>
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
          }

          return TrackNameContent(
              trackBaseItemDto: trackBaseItemDto,
              mediaItem: mediaItem,
              separatedArtistTextSpans: buildArtistsTextSpans(
                trackBaseItemDto,
                textColour,
                context,
                true,
              ));
        }

        return const TrackNameContent(
          trackBaseItemDto: null,
          mediaItem: null,
          separatedArtistTextSpans: [],
        );
      },
    );
  }
}

class TrackNameContent extends StatelessWidget {
  const TrackNameContent({
    super.key,
    required this.trackBaseItemDto,
    required this.mediaItem,
    required this.separatedArtistTextSpans,
  });
  final BaseItemDto? trackBaseItemDto;
  final MediaItem? mediaItem;
  final List<TextSpan> separatedArtistTextSpans;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    final textColour =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6);

    return Padding(
      // I don't know why but 12 is the magic number that lines up with the
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: trackBaseItemDto == null
                ? null
                : () => jellyfinApiHelper
                    .getItemById(trackBaseItemDto!.albumId as String)
                    .then((album) => Navigator.of(context).popAndPushNamed(
                        AlbumScreen.routeName,
                        arguments: album)),
            child: Text(
              mediaItem == null
                  ? AppLocalizations.of(context)!.noAlbum
                  : mediaItem!.album ?? AppLocalizations.of(context)!.noAlbum,
              style: TextStyle(color: textColour),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Center(
            child: ScrollingTextHelper(
              id: ValueKey(mediaItem!.id),
              alignment: TextAlign.center,
              text: mediaItem == null
                  ? AppLocalizations.of(context)!.noItem
                  : mediaItem!.title,
              style: TextStyle(
                fontSize: 24,
                height: 26 / 20,
                fontWeight: Theme.of(context).brightness == Brightness.light
                    ? FontWeight.w500
                    : FontWeight.w600,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          RichText(
            text: TextSpan(
              children: mediaItem == null || mediaItem!.artist == null
                  ? [
                      TextSpan(
                        text: AppLocalizations.of(context)!.noArtist,
                        style: TextStyle(color: textColour),
                      )
                    ]
                  : separatedArtistTextSpans,
            ),
          ),
        ],
      ),
    );
  }
}
