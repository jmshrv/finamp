import 'package:flutter/material.dart';

import '../components/AudioServiceSettingsScreen/StopForegroundSelector.dart';
import '../components/AudioServiceSettingsScreen/SongShuffleItemCountEditor.dart';

class AudioServiceSettingsScreen extends StatelessWidget {
  const AudioServiceSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Service"),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            StopForegroundSelector(),
            SongShuffleItemCountEditor(),
          ],
        ),
      ),
    );
  }
}
