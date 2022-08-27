import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';
import 'sleep_timer_dialog.dart';
import 'sleep_timer_cancel_dialog.dart';

// Flutter doesn't flip this icon in RTL layouts, which apparently isn't correct
// behaviour. We fix this by defining IconDatas with matchTextDirection set to
// true. See #310 for more info.
final directionalModeNight = IconData(
  Icons.mode_night.codePoint,
  fontFamily: Icons.mode_night.fontFamily,
  fontPackage: Icons.mode_night.fontPackage,
  matchTextDirection: true,
);

final directionalModeNightOutlined = IconData(
  Icons.mode_night_outlined.codePoint,
  fontFamily: Icons.mode_night_outlined.fontFamily,
  fontPackage: Icons.mode_night_outlined.fontPackage,
  matchTextDirection: true,
);

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
                ? Icon(directionalModeNightOutlined)
                : Icon(directionalModeNight),
            tooltip: AppLocalizations.of(context)!.sleepTimerTooltip,
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
