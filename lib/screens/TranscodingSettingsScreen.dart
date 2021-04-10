import 'package:flutter/material.dart';

import '../components/TranscodingSettingsScreen/TranscodeSwitch.dart';
import '../components/TranscodingSettingsScreen/BitrateSelector.dart';

class TranscodingSettingsScreen extends StatelessWidget {
  const TranscodingSettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transcoding"),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            TranscodeSwitch(),
            BitrateSelector(),
            Text(
              "Jellyfin uses AAC for transcoding.",
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
