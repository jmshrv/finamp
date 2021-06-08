import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../../services/connectIfDisconnected.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: AudioService.playbackStateStream,
      builder: (context, snapshot) {
        connectIfDisconnected();

        final PlaybackState? playbackState = snapshot.data;
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: _getShufflingIcon(
                playbackState == null
                    ? AudioServiceShuffleMode.none
                    : playbackState.shuffleMode,
              ),
              onPressed: AudioService.connected && playbackState != null
                  ? () async {
                      if (playbackState.shuffleMode ==
                          AudioServiceShuffleMode.all) {
                        await AudioService.setShuffleMode(
                            AudioServiceShuffleMode.none);
                      } else {
                        await AudioService.setShuffleMode(
                            AudioServiceShuffleMode.all);
                      }
                    }
                  : null,
              iconSize: 20,
            ),
            IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: AudioService.connected && playbackState != null
                  ? () async => await AudioService.skipToPrevious()
                  : null,
              iconSize: 36,
            ),
            SizedBox(
              height: 56,
              width: 56,
              child: FloatingActionButton(
                // We set a heroTag because otherwise the play button on AlbumScreenContent will do hero widget stuff
                heroTag: "PlayerScreenFAB",
                onPressed: AudioService.connected && playbackState != null
                    ? () async {
                        if (playbackState.playing) {
                          await AudioService.pause();
                        } else {
                          await AudioService.play();
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
                icon: Icon(Icons.skip_next),
                onPressed: AudioService.connected && playbackState != null
                    ? () async => AudioService.skipToNext()
                    : null,
                iconSize: 36),
            IconButton(
              icon: _getRepeatingIcon(playbackState == null
                  ? AudioServiceRepeatMode.none
                  : playbackState.repeatMode),
              onPressed: AudioService.connected && playbackState != null
                  ? () async {
                      // Cyles from none -> all -> one
                      if (playbackState.repeatMode ==
                          AudioServiceRepeatMode.none) {
                        await AudioService.setRepeatMode(
                            AudioServiceRepeatMode.all);
                      } else if (playbackState.repeatMode ==
                          AudioServiceRepeatMode.all) {
                        await AudioService.setRepeatMode(
                            AudioServiceRepeatMode.one);
                      } else {
                        await AudioService.setRepeatMode(
                            AudioServiceRepeatMode.none);
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

  Widget _getRepeatingIcon(AudioServiceRepeatMode repeatMode) {
    if (repeatMode == AudioServiceRepeatMode.all) {
      return Icon(Icons.repeat, color: Colors.green);
    } else if (repeatMode == AudioServiceRepeatMode.one) {
      return Icon(Icons.repeat_one, color: Colors.green);
    } else {
      return Icon(Icons.repeat);
    }
  }

  Icon _getShufflingIcon(AudioServiceShuffleMode shuffleMode) {
    if (shuffleMode == AudioServiceShuffleMode.all) {
      return Icon(Icons.shuffle, color: Colors.green);
    } else {
      return Icon(Icons.shuffle);
    }
  }
}
