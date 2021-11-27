import 'dart:io';

import 'package:flutter/material.dart';

import '../components/TranscodingSettingsScreen/TranscodeSwitch.dart';
import '../components/TranscodingSettingsScreen/BitrateSelector.dart';
import '../components/TranscodingSettingsScreen/VorbisSwitch.dart';

class TranscodingSettingsScreen extends StatelessWidget {
  const TranscodingSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transcoding"),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            const TranscodeSwitch(),
            const BitrateSelector(),
            if (!(Platform.isIOS || Platform.isMacOS)) const VorbisSwitch(),
          ],
        ),
      ),
    );
  }
}
