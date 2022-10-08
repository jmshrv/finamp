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
        children: [
          // ProgressSlider(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.5,
                color: (ref.watch(playerScreenThemeProvider) ??
                        Theme.of(context).colorScheme.secondary)
                    .withOpacity(0.15),
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: PlayerButtons(),
            ),
          ),
        ],
      ),
    );
  }
}
