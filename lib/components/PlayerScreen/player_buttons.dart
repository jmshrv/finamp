import 'package:finamp/components/PlayerScreen/player_buttons_repeating.dart';
import 'package:finamp/components/PlayerScreen/player_buttons_shuffle.dart';
import 'package:finamp/screens/player_screen.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/media_state_stream.dart';
import '../../services/music_player_background_task.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons(this.controller, {super.key});

  final PlayerHideableController controller;

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaState>(
        stream: mediaStateStream,
        builder: (context, snapshot) {
          final mediaState = snapshot.data;
          final playbackState = mediaState?.playbackState;

          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            textDirection: TextDirection.ltr,
            children: [
              if (controller.shouldShow(PlayerHideable.loopShuffleButtons))
                PlayerButtonsRepeating(),
              Semantics.fromProperties(
                properties: SemanticsProperties(
                  label: AppLocalizations.of(context)!
                      .skipToPreviousTrackButtonTooltip,
                  button: true,
                ),
                container: true,
                excludeSemantics: true,
                child: IconButton(
                  icon: const Icon(TablerIcons.player_skip_back),
                  onPressed: playbackState != null
                      ? () async {
                          FeedbackHelper.feedback(FeedbackType.light);
                          await audioHandler.skipToPrevious();
                        }
                      : null,
                ),
              ),
              Semantics.fromProperties(
                properties: SemanticsProperties(
                  label:
                      AppLocalizations.of(context)!.togglePlaybackButtonTooltip,
                  button: true,
                ),
                container: true,
                excludeSemantics: true,
                child: _RoundedIconButton(
                  width: controller.shouldShow(PlayerHideable.bigPlayButton)
                      ? 62
                      : 48,
                  height: controller.shouldShow(PlayerHideable.bigPlayButton)
                      ? 62
                      : 48,
                  borderRadius: BorderRadius.circular(
                      controller.shouldShow(PlayerHideable.bigPlayButton)
                          ? 16
                          : 12),
                  onTap: playbackState != null
                      ? () async {
                          FeedbackHelper.feedback(FeedbackType.light);
                          if (playbackState.playing) {
                            await audioHandler.pause();
                          } else {
                            await audioHandler.play();
                          }
                        }
                      : null,
                  icon: Icon(
                      playbackState == null || playbackState.playing
                          ? TablerIcons.player_pause
                          : TablerIcons.player_play,
                      size: 28),
                ),
              ),
              Semantics.fromProperties(
                properties: SemanticsProperties(
                  label: AppLocalizations.of(context)!
                      .skipToNextTrackButtonTooltip,
                  button: true,
                ),
                container: true,
                excludeSemantics: true,
                child: IconButton(
                  icon: const Icon(TablerIcons.player_skip_forward),
                  onPressed: playbackState != null
                      ? () async {
                          FeedbackHelper.feedback(FeedbackType.light);
                          await audioHandler.skipToNext();
                        }
                      : null,
                ),
              ),
              if (controller.shouldShow(PlayerHideable.loopShuffleButtons))
                PlayerButtonsShuffle()
            ],
          );
        });
  }
}

class _RoundedIconButton extends StatelessWidget {
  const _RoundedIconButton({
    super.key,
    required this.icon,
    this.borderRadius,
    this.width = 48,
    this.height = 48,
    this.onTap,
  });

  final Widget icon;
  final BorderRadius? borderRadius;
  final double width;
  final double height;
  final VoidCallback? onTap;

  Widget _addDropShadow(Icon icon, BuildContext context) {
    // If only Icon had a .copyWith() function lol
    return Icon(
      icon.icon,
      color: icon.color,
      key: icon.key,
      semanticLabel: icon.semanticLabel,
      size: icon.size,
      textDirection: icon.textDirection,
      shadows: icon.shadows ??
          [
            BoxShadow(
              blurRadius: 2,
              offset: const Offset(0, 2),
              color: (icon.color ?? IconTheme.of(context).color)!
                  .withOpacity(0.25),
            )
          ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _borderRadius = borderRadius ?? BorderRadius.circular(height);
    final _icon = icon is Icon ? _addDropShadow(icon as Icon, context) : icon;
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        borderRadius: _borderRadius,
        color: IconTheme.of(context).color!.withOpacity(0.15),
        child: InkWell(
          borderRadius: _borderRadius,
          onTap: onTap,
          child: _icon,
        ),
      ),
    );
  }
}
