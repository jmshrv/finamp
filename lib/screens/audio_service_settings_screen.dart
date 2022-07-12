import 'package:flutter/material.dart';

import '../components/AudioServiceSettingsScreen/stop_foreground_selector.dart';
import '../components/AudioServiceSettingsScreen/song_shuffle_item_count_editor.dart';

class AudioServiceSettingsScreen extends StatelessWidget {
  const AudioServiceSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/audioservice";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Service"),
      ),
      body: Scrollbar(
        child: ListView(
          children: const [
            StopForegroundSelector(),
            SongShuffleItemCountEditor(),
          ],
        ),
      ),
    );
  }
}
