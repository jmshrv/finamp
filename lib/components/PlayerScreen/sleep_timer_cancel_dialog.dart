import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';

class SleepTimerCancelDialog extends StatelessWidget {
  const SleepTimerCancelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.cancelSleepTimer),
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.noButtonLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.yesButtonLabel),
          onPressed: () {
            audioHandler.clearSleepTimer();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
