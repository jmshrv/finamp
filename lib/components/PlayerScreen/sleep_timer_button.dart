import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';
import '../../services/player_screen_theme_provider.dart';
import 'sleep_timer_dialog.dart';
import 'sleep_timer_cancel_dialog.dart';

class SleepTimerButton extends ConsumerWidget {
  const SleepTimerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return ValueListenableBuilder<Timer?>(
      valueListenable: audioHandler.sleepTimer,
      builder: (context, value, child) {
        return ListTile(
            leading: const Icon(TablerIcons.hourglass_high),
            onTap: () async {
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
            },
            title: Text(AppLocalizations.of(context)!.sleepTimerTooltip));
      },
    );
  }
}
