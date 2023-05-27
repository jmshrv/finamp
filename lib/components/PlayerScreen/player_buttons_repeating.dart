import 'package:audio_service/audio_service.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class PlayerButtonsRepeating extends StatelessWidget {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  PlayerButtonsRepeating({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: mediaStateStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          final mediaState = snapshot.data;
          final playbackState = mediaState?.playbackState;
          return IconButton(
              onPressed: playbackState != null
                  ? () async {
                      // Cyles from none -> all -> one
                      if (playbackState!.repeatMode ==
                          AudioServiceRepeatMode.none) {
                        await audioHandler
                            .setRepeatMode(AudioServiceRepeatMode.all);
                      } else if (playbackState!.repeatMode ==
                          AudioServiceRepeatMode.all) {
                        await audioHandler
                            .setRepeatMode(AudioServiceRepeatMode.one);
                      } else {
                        await audioHandler
                            .setRepeatMode(AudioServiceRepeatMode.none);
                      }
                    }
                  : null,
              icon: _getRepeatingIcon(
                playbackState == null
                    ? AudioServiceRepeatMode.none
                    : playbackState!.repeatMode,
                Theme.of(context).colorScheme.secondary,
              ));
        });
  }

  Widget _getRepeatingIcon(
      AudioServiceRepeatMode repeatMode, Color iconColour) {
    if (repeatMode == AudioServiceRepeatMode.all) {
      return const Icon(TablerIcons.repeat);
    } else if (repeatMode == AudioServiceRepeatMode.one) {
      return const Icon(TablerIcons.repeat_once);
    } else {
      return const Icon(TablerIcons.repeat_off);
    }
  }
}
