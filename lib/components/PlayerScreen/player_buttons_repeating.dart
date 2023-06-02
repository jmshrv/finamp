import 'package:audio_service/audio_service.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:finamp/services/player_screen_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class PlayerButtonsRepeating extends StatelessWidget {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final queueService = GetIt.instance<QueueService>();

  PlayerButtonsRepeating({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: mediaStateStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return IconButton(
              onPressed: () async {
                  // Cycles from none -> all -> one
                  switch (queueService.loopMode) {
                    case LoopMode.none:
                      queueService.loopMode = LoopMode.all;
                      break;
                    case LoopMode.all:
                      queueService.loopMode = LoopMode.one;
                      break;
                    case LoopMode.one:
                      queueService.loopMode = LoopMode.none;
                      break;
                    default:
                      queueService.loopMode = LoopMode.none;
                      break;
                  }
                },
                icon: _getRepeatingIcon(
                  queueService.loopMode,
                  Theme.of(context).colorScheme.secondary,
                ));
        });
  }

  Widget _getRepeatingIcon(
      LoopMode loopMode, Color iconColour) {
    if (loopMode == LoopMode.all) {
      return const Icon(TablerIcons.repeat);
    } else if (loopMode == LoopMode.one) {
      return const Icon(TablerIcons.repeat_once);
    } else {
      return const Icon(TablerIcons.repeat_off);
    }
  }
}
