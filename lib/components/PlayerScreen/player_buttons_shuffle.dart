import 'package:audio_service/audio_service.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/player_screen_theme_provider.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class PlayerButtonsShuffle extends ConsumerWidget {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  PlayerButtonsShuffle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconTheme(
      data: IconThemeData(
        color: ref.watch(playerScreenThemeProvider) ??
            (Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
      ),
      child: StreamBuilder(
        stream: _queueService.getCurrentTrackStream(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          final currentTrack = snapshot.data;
          // final playbackState = mediaState?.playbackState;
          return IconButton(
            // onPressed: playbackState != null
            //     ? () async {
            //         if (playbackState!.shuffleMode ==
            //             AudioServiceShuffleMode.all) {
            //           await audioHandler
            //               .setShuffleMode(AudioServiceShuffleMode.none);
            //         } else {
            //           await audioHandler
            //               .setShuffleMode(AudioServiceShuffleMode.all);
            //         }
            //       }
            //     : null,
            onPressed: () async {
              _queueService.playbackOrder = _queueService.playbackOrder == PlaybackOrder.shuffled ? PlaybackOrder.linear : PlaybackOrder.shuffled;
            },
            icon: Icon(
              (_queueService.playbackOrder == PlaybackOrder.shuffled
                  ? TablerIcons.arrows_shuffle
                  : TablerIcons.arrows_right),
            ),
          );
        },
      ),
    );
  }
}
