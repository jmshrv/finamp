import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class PlayerButtonsShuffle extends StatelessWidget {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  PlayerButtonsShuffle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: mediaStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return IconButton(
          onPressed: () async {
            _queueService.playbackOrder =
                _queueService.playbackOrder == FinampPlaybackOrder.shuffled
                    ? FinampPlaybackOrder.linear
                    : FinampPlaybackOrder.shuffled;
          },
          icon: Icon(
            (_queueService.playbackOrder == FinampPlaybackOrder.shuffled
                ? TablerIcons.arrows_shuffle
                : TablerIcons.arrows_right),
          ),
        );
      },
    );
  }
}
