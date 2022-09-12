import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/media_state_stream.dart';
import '../../services/music_player_background_task.dart';
import '../favourite_button.dart';
import 'add_to_playlist_button.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaState>(
      stream: mediaStateStream,
      builder: (context, snapshot) {
        final mediaState = snapshot.data;
        final playbackState = mediaState?.playbackState;
        final item = mediaState?.mediaItem?.extras?["itemJson"] == null
            ? null
            : BaseItemDto.fromJson(mediaState!.mediaItem!.extras!["itemJson"]);

        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.ltr,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.shuffle),
                  onPressed: playbackState != null
                      ? () async {
                          if (playbackState.shuffleMode ==
                              AudioServiceShuffleMode.all) {
                            await audioHandler
                                .setShuffleMode(AudioServiceShuffleMode.none);
                          } else {
                            await audioHandler
                                .setShuffleMode(AudioServiceShuffleMode.all);
                          }
                        }
                      : null,
                  iconSize: 20,
                ),
                IconButton(
                  icon: _getRepeatingIcon(
                    playbackState == null
                        ? AudioServiceRepeatMode.none
                        : playbackState.repeatMode,
                    Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: playbackState != null
                      ? () async {
                          // Cyles from none -> all -> one
                          if (playbackState.repeatMode ==
                              AudioServiceRepeatMode.none) {
                            await audioHandler
                                .setRepeatMode(AudioServiceRepeatMode.all);
                          } else if (playbackState.repeatMode ==
                              AudioServiceRepeatMode.all) {
                            await audioHandler
                                .setRepeatMode(AudioServiceRepeatMode.one);
                          } else {
                            await audioHandler
                                .setRepeatMode(AudioServiceRepeatMode.none);
                          }
                        }
                      : null,
                  iconSize: 20,
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: playbackState != null
                  ? () async => await audioHandler.skipToPrevious()
                  : null,
              iconSize: 36,
            ),
            SizedBox(
              height: 56,
              width: 56,
              child: FloatingActionButton(
                // We set a heroTag because otherwise the play button on AlbumScreenContent will do hero widget stuff
                heroTag: "PlayerScreenFAB",
                onPressed: playbackState != null
                    ? () async {
                        if (playbackState.playing) {
                          await audioHandler.pause();
                        } else {
                          await audioHandler.play();
                        }
                      }
                    : null,
                child: Icon(
                  playbackState == null || playbackState.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 36,
                ),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: playbackState != null
                    ? () async => audioHandler.skipToNext()
                    : null,
                iconSize: 36),
            Column(
              children: [
                FavoriteButton(item: item),
                AddToPlaylistButton(),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _getRepeatingIcon(
      AudioServiceRepeatMode repeatMode, Color iconColour) {
    if (repeatMode == AudioServiceRepeatMode.all) {
      return Icon(Icons.repeat, color: iconColour);
    } else if (repeatMode == AudioServiceRepeatMode.one) {
      return Icon(Icons.repeat_one, color: iconColour);
    } else {
      return const Icon(Icons.repeat);
    }
  }
}
