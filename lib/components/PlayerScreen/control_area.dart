import 'package:flutter/material.dart';

import 'player_buttons.dart';
import 'progress_slider.dart';
import 'feature_chips.dart';

class ControlArea extends StatelessWidget {
  const ControlArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FeatureChips(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ProgressSlider(),
        ),
        PlayerButtons(),
      ],
    );
  }
}
