import 'package:audio_service/audio_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
import 'song_name_content.dart';
import '../album_image.dart';

/// Album image and song name/album etc. We do this in one widget to share a
/// StreamBuilder and to make alignment easier.
class SongInfo extends StatefulWidget {
  const SongInfo({Key? key}) : super(key: key);

  @override
  State<SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<SongInfo> {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      initialData: MediaItem(
        id: "",
        title: AppLocalizations.of(context)!.noItem,
        album: AppLocalizations.of(context)!.noAlbum,
        artist: AppLocalizations.of(context)!.noArtist,
      ),
      builder: (context, snapshot) {
        final mediaItem = snapshot.data!;
        final songBaseItemDto =
            (mediaItem.extras?.containsKey("itemJson") ?? false)
                ? BaseItemDto.fromJson(mediaItem.extras!["itemJson"])
                : null;

        List<TextSpan> separatedArtistTextSpans = [];
        final secondaryTextColour =
            Theme.of(context).textTheme.bodyText2?.color?.withOpacity(0.8);
        final artistTextStyle = GoogleFonts.lexendDeca(
          color: secondaryTextColour,
          fontSize: 14,
          height: 17.5 / 14,
          fontWeight: FontWeight.w300,
        );

        if (songBaseItemDto?.artistItems?.isEmpty ?? true) {
          separatedArtistTextSpans = [
            TextSpan(
              text: AppLocalizations.of(context)!.unknownArtist,
              style: artistTextStyle,
            )
          ];
        } else {
          songBaseItemDto!.artistItems
              ?.map((e) => TextSpan(
                  text: e.name,
                  style: TextStyle(color: secondaryTextColour),
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
              style: artistTextStyle,
            ));
          });
          separatedArtistTextSpans.removeLast();
        }

        return Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 32,
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(0.15),
                    )
                  ],
                ),
                child: AlbumImage(item: songBaseItemDto),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12)),
              SongNameContent(
                songBaseItemDto: songBaseItemDto,
                mediaItem: mediaItem,
                separatedArtistTextSpans: separatedArtistTextSpans,
                secondaryTextColour: secondaryTextColour,
              )
            ],
          ),
        );
      },
    );
  }
}
