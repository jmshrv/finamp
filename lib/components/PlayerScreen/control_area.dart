import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';
import '../../services/player_screen_theme_provider.dart';
import 'player_buttons.dart';
import 'progress_slider.dart';

class ControlArea extends ConsumerWidget {
  const ControlArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ProgressSlider(),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12)),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.5,
                color: (ref.watch(playerScreenThemeProvider) ??
                        Theme.of(context).colorScheme.secondary)
                    .withOpacity(0.15),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: PlayerButtons(),
            ),
          ),
        ],
      ),
    );
  }
}
