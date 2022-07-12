import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';
import 'sleep_timer_dialog.dart';
import 'sleep_timer_cancel_dialog.dart';

class SleepTimerButton extends StatelessWidget {
  const SleepTimerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return ValueListenableBuilder<Timer?>(
      valueListenable: audioHandler.sleepTimer,
      builder: (context, value, child) {
        return IconButton(
            icon: value == null
                ? const Icon(Icons.mode_night_outlined)
                : const Icon(Icons.mode_night),
            onPressed: () async {
              if (value != null) {
                showDialog(
                  context: context,
                  builder: (context) => const SleepTimerCancelDialog(),
                );
              } else {
                await showDialog(
                  context: context,
                  builder: (context) => const SleepTimerDialog(),
                );
              }
            });
      },
    );
  }
}
