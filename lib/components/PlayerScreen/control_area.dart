import 'package:flutter/material.dart';

import 'feature_chips.dart';
import 'player_buttons.dart';
import 'progress_slider.dart';

class ControlArea extends StatelessWidget {
  const ControlArea(this.targetHeight, {super.key});

  final double targetHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (targetHeight > 210) const FeatureChips(),
        if (targetHeight > 190) const ProgressSlider(),
        const PlayerButtons(),
      ],
    );
  }
}
