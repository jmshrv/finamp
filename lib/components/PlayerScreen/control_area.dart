import 'package:flutter/material.dart';

import 'player_buttons.dart';
import 'progress_slider.dart';
import 'feature_chips.dart';

class ControlArea extends StatelessWidget {
  const ControlArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (MediaQuery.sizeOf(context).height > 600)
            const FeatureChips(),
          if (MediaQuery.sizeOf(context).height > 400)  
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ProgressSlider(),
            ),
          const PlayerButtons(),
        ],
      ),
    );
  }
}
