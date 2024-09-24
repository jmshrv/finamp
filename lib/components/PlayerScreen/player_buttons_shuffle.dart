import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          tooltip:
              getLocalizedPlaybackOrder(context, _queueService.playbackOrder),
          onPressed: () async {
            FeedbackHelper.feedback(FeedbackType.light);
            _queueService.togglePlaybackOrder();
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

  String getLocalizedPlaybackOrder(
      BuildContext context, FinampPlaybackOrder playbackOrder) {
    switch (playbackOrder) {
      case FinampPlaybackOrder.linear:
        return AppLocalizations.of(context)!.playbackOrderLinearButtonTooltip;
      case FinampPlaybackOrder.shuffled:
        return AppLocalizations.of(context)!.playbackOrderShuffledButtonTooltip;
    }
  }
}
