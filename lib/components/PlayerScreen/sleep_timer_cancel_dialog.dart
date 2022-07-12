import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';

class SleepTimerCancelDialog extends StatelessWidget {
  const SleepTimerCancelDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return AlertDialog(
      title: const Text("Cancel Sleep Timer?"),
      actions: [
        TextButton(
          child: const Text("NO"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("YES"),
          onPressed: () {
            audioHandler.clearSleepTimer();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
