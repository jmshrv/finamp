import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/media_state_stream.dart';
import '../../services/music_player_background_task.dart';
import '../../services/player_screen_theme_provider.dart';
import '../favourite_button.dart';
import 'add_to_playlist_button.dart';

class PlayerButtons extends ConsumerWidget {
  const PlayerButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return IconTheme(
      data: IconThemeData(
        color: ref.watch(playerScreenThemeProvider) ??
            (Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
      ),
      child: StreamBuilder<MediaState>(
        stream: mediaStateStream,
        builder: (context, snapshot) {
          final mediaState = snapshot.data;
          final playbackState = mediaState?.playbackState;
          final item = mediaState?.mediaItem?.extras?["itemJson"] == null
              ? null
              : BaseItemDto.fromJson(
                  mediaState!.mediaItem!.extras!["itemJson"]);

          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.ltr,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(TablerIcons.arrows_shuffle),
                    onPressed: playbackState != null
                        ? () async {
                            if (playbackState.shuffleMode ==
                                AudioServiceShuffleMode.all) {
                              await audioHandler
                                  .setShuffleMode(AudioServiceShuffleMode.none);
                            } else {
                              await audioHandler
                                  .setShuffleMode(AudioServiceShuffleMode.all);
                            }
                          }
                        : null,
                    iconSize: 20,
                  ),
                  IconButton(
                    icon: _getRepeatingIcon(
                      playbackState == null
                          ? AudioServiceRepeatMode.none
                          : playbackState.repeatMode,
                      Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: playbackState != null
                        ? () async {
                            // Cyles from none -> all -> one
                            if (playbackState.repeatMode ==
                                AudioServiceRepeatMode.none) {
                              await audioHandler
                                  .setRepeatMode(AudioServiceRepeatMode.all);
                            } else if (playbackState.repeatMode ==
                                AudioServiceRepeatMode.all) {
                              await audioHandler
                                  .setRepeatMode(AudioServiceRepeatMode.one);
                            } else {
                              await audioHandler
                                  .setRepeatMode(AudioServiceRepeatMode.none);
                            }
                          }
                        : null,
                    iconSize: 20,
                  ),
                ],
              ),
              _RoundedIconButton(
                icon: const Icon(TablerIcons.player_skip_back),
                height: 36,
                onTap: playbackState != null
                    ? () async => await audioHandler.skipToPrevious()
                    : null,
              ),
              _RoundedIconButton(
                width: 56,
                height: 56,
                onTap: playbackState != null
                    ? () async {
                        if (playbackState.playing) {
                          await audioHandler.pause();
                        } else {
                          await audioHandler.play();
                        }
                      }
                    : null,
                icon: Icon(playbackState == null || playbackState.playing
                    ? TablerIcons.player_pause
                    : TablerIcons.player_play),
              ),
              _RoundedIconButton(
                icon: const Icon(TablerIcons.player_skip_forward),
                height: 36,
                onTap: playbackState != null
                    ? () async => audioHandler.skipToNext()
                    : null,
              ),
              Column(
                children: [
                  FavoriteButton(item: item),
                  AddToPlaylistButton(),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _getRepeatingIcon(
      AudioServiceRepeatMode repeatMode, Color iconColour) {
    if (repeatMode == AudioServiceRepeatMode.all) {
      return Icon(TablerIcons.repeat);
    } else if (repeatMode == AudioServiceRepeatMode.one) {
      return Icon(TablerIcons.repeat_once);
    } else {
      return const Icon(TablerIcons.repeat_off);
    }
  }
}

class _RoundedIconButton extends StatelessWidget {
  const _RoundedIconButton({
    Key? key,
    required this.icon,
    this.borderRadius,
    this.width = 48,
    this.height = 48,
    this.onTap,
  }) : super(key: key);

  final Widget icon;
  final BorderRadius? borderRadius;
  final double width;
  final double height;
  final VoidCallback? onTap;

  Widget _addDropShadow(Icon icon, BuildContext context) {
    // If only Icon had a .copyWith() function lol
    return Transform.translate(
      offset: icon.icon?.fontFamily == "tabler-icons"
          ? const Offset(1, -1)
          : Offset.zero,
      child: Icon(
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
      ),
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
