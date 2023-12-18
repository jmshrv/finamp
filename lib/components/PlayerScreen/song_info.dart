import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../../screens/artist_screen.dart';
import '../../services/current_album_image_provider.dart';
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
  final queueService = GetIt.instance<QueueService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FinampQueueInfo?>(
      stream: queueService.getQueueStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // show loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final currentTrack = snapshot.data!.currentTrack!;
        final mediaItem = currentTrack.item;
        final songBaseItemDto =
            (mediaItem.extras?.containsKey("itemJson") ?? false)
                ? jellyfin_models.BaseItemDto.fromJson(
                    mediaItem.extras!["itemJson"])
                : null;

        List<TextSpan> separatedArtistTextSpans = [];
        final secondaryTextColour =
            Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _PlayerScreenAlbumImage(queueItem: currentTrack),
            SongNameContent(
              currentTrack: currentTrack,
              separatedArtistTextSpans: separatedArtistTextSpans,
              secondaryTextColour: secondaryTextColour,
            )
          ],
        );
      },
    );
  }
}

class _PlayerScreenAlbumImage extends StatelessWidget {
  _PlayerScreenAlbumImage({
    Key? key,
    required this.queueItem,
  }) : super(key: key);

  final FinampQueueItem queueItem;

  @override
  Widget build(BuildContext context) {
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
      alignment: Alignment.center,
      constraints: const BoxConstraints(
        maxHeight: 300,
        // maxWidth: 300,
        // minHeight: 300,
        // minWidth: 300,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
        child: AlbumImage(
          imageListenable: currentAlbumImageProvider,
        ),
      ),
    );
  }
}
