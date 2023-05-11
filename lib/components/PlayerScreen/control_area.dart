import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'player_buttons.dart';
import 'progress_slider.dart';

class ControlArea extends ConsumerWidget {
  const ControlArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ProgressSlider(),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 12)),
          PlayerButtons(),
        ],
      ),
    );
  }
}
