import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/MusicPlayerBackgroundTask.dart';
import 'SleepTimerDialog.dart';
import 'SleepTimerCancelDialog.dart';

class SleepTimerButton extends StatelessWidget {
  const SleepTimerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return ValueListenableBuilder<Timer?>(
      valueListenable: _audioHandler.sleepTimer,
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
