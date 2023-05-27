import 'package:audio_service/audio_service.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class PlayerButtonsShuffle extends StatelessWidget {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  PlayerButtonsShuffle({Key? key}) : super(key: key);

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
                  if (playbackState!.shuffleMode ==
                      AudioServiceShuffleMode.all) {
                    await audioHandler
                        .setShuffleMode(AudioServiceShuffleMode.none);
                  } else {
                    await audioHandler
                        .setShuffleMode(AudioServiceShuffleMode.all);
                  }
                }
              : null,
          icon: Icon(
            (playbackState?.shuffleMode == AudioServiceShuffleMode.all
                ? TablerIcons.arrows_shuffle
                : TablerIcons.arrows_right),
          ),
        );
      },
    );
  }
}
