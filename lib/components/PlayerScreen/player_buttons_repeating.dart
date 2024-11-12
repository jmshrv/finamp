import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              tooltip:
                  "${getLocalizedLoopMode(context, queueService.loopMode)}. ${AppLocalizations.of(context)!.genericToggleButtonTooltip}",
              onPressed: () async {
                FeedbackHelper.feedback(FeedbackType.light);
                queueService.toggleLoopMode();
              },
              icon: _getRepeatingIcon(
                queueService.loopMode,
                Theme.of(context).colorScheme.secondary,
              ));
        });
  }

  Widget _getRepeatingIcon(FinampLoopMode loopMode, Color iconColour) {
    if (loopMode == FinampLoopMode.all) {
      return const Icon(TablerIcons.repeat);
    } else if (loopMode == FinampLoopMode.one) {
      return const Icon(TablerIcons.repeat_once);
    } else {
      return const Icon(TablerIcons.repeat_off);
    }
  }

  String getLocalizedLoopMode(BuildContext context, FinampLoopMode loopMode) {
    switch (loopMode) {
      case FinampLoopMode.all:
        return AppLocalizations.of(context)!.loopModeAllButtonLabel;
      case FinampLoopMode.one:
        return AppLocalizations.of(context)!.loopModeOneButtonLabel;
      case FinampLoopMode.none:
        return AppLocalizations.of(context)!.loopModeNoneButtonLabel;
    }
  }
}
