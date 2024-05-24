import 'package:finamp/screens/player_screen.dart';
import 'package:flutter/material.dart';

import 'feature_chips.dart';
import 'player_buttons.dart';
import 'progress_slider.dart';

class ControlArea extends StatelessWidget {
  const ControlArea(this.controller, {super.key});

  final PlayerHideableController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (controller.shouldShow(PlayerHideable.features))
          const FeatureChips(),
        if (controller.shouldShow(PlayerHideable.progressSlider))
          const ProgressSlider(),
        PlayerButtons(controller),
      ],
    );
  }
}
