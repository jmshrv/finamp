import 'package:audio_service/audio_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/current_album_image_provider.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
import '../../services/player_screen_theme_provider.dart';
import 'song_name_content.dart';
import '../album_image.dart';
import '../../to_contrast.dart';

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
        final artistTextStyle = TextStyle(
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PlayerScreenAlbumImage(item: songBaseItemDto),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12)),
            SongNameContent(
              songBaseItemDto: songBaseItemDto,
              mediaItem: mediaItem,
              separatedArtistTextSpans: separatedArtistTextSpans,
              secondaryTextColour: secondaryTextColour,
            )
          ],
        );
      },
    );
  }
}

class _PlayerScreenAlbumImage extends ConsumerWidget {
  const _PlayerScreenAlbumImage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BaseItemDto? item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 32,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.15),
          )
        ],
      ),
      child: AlbumImage(
        item: item,
        // We need a post frame callback because otherwise this
        // widget rebuilds on the same frame
        imageProviderCallback: (imageProvider) =>
            WidgetsBinding.instance.addPostFrameCallback((_) async {
          ref.read(currentAlbumImageProvider.notifier).state = imageProvider;

          if (imageProvider != null) {
            final theme = Theme.of(context);

            final paletteGenerator =
                await PaletteGenerator.fromImageProvider(imageProvider);

            final accent = paletteGenerator.dominantColor!.color;

            final lighter = theme.brightness == Brightness.dark;
            final background = Color.alphaBlend(
                lighter
                    ? Colors.black.withOpacity(0.75)
                    : Colors.white.withOpacity(0.5),
                accent);

            final newColour = accent.atContrast(4.5, background, lighter);

            ref.read(playerScreenThemeProvider.notifier).state = newColour;
          }
        }),
      ),
    );
  }
}
