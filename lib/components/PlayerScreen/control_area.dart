import 'package:flutter/material.dart';

import 'player_buttons.dart';
import 'progress_slider.dart';
import 'song_features.dart';

class ControlArea extends StatelessWidget {
  const ControlArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SongAudioFeatures(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ProgressSlider(),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        PlayerButtons(),
      ],
    );
  }
}
