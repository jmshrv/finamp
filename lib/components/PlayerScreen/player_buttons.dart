import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/music_player_background_task.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState,
      builder: (context, snapshot) {
        final PlaybackState? playbackState = snapshot.data;
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.ltr,
          children: [
            IconButton(
              tooltip: playbackState?.shuffleMode == AudioServiceShuffleMode.all
                  ? AppLocalizations.of(context)!.playbackOrderShuffledTooltip
                  : AppLocalizations.of(context)!.playbackOrderLinearTooltip,
              icon: _getShufflingIcon(
                playbackState == null
                    ? AudioServiceShuffleMode.none
                    : playbackState.shuffleMode,
                Theme.of(context).colorScheme.secondary,
              ),
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
              tooltip: AppLocalizations.of(context)!.skipToPrevious,
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
                tooltip: AppLocalizations.of(context)!.togglePlayback,
                // We set a heroTag because otherwise the play button on AlbumScreenContent will do hero widget stuff
                heroTag: "PlayerScreenFAB",
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                splashColor:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.24),
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
                tooltip: AppLocalizations.of(context)!.skipToNext,
                icon: const Icon(Icons.skip_next),
                onPressed: playbackState != null
                    ? () async => audioHandler.skipToNext()
                    : null,
                iconSize: 36),
            IconButton(
              tooltip: playbackState?.repeatMode == AudioServiceRepeatMode.all
                  ? AppLocalizations.of(context)!.loopModeAllTooltip
                  : playbackState?.repeatMode == AudioServiceRepeatMode.one
                      ? AppLocalizations.of(context)!.loopModeOneTooltip
                      : AppLocalizations.of(context)!.loopModeNoneTooltip,
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

  Icon _getShufflingIcon(
      AudioServiceShuffleMode shuffleMode, Color iconColour) {
    if (shuffleMode == AudioServiceShuffleMode.all) {
      return Icon(Icons.shuffle, color: iconColour);
    } else {
      return const Icon(Icons.shuffle);
    }
  }
}
