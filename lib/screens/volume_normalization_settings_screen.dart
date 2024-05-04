import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/VolumeNormalizationSettingsScreen/volume_normalization_ios_base_gain_editor.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_switch.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_mode_selector.dart';

class VolumeNormalizationSettingsScreen extends StatelessWidget {
  const VolumeNormalizationSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/volume-normalization";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.volumeNormalizationSettingsTitle),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            const VolumeNormalizationSwitch(),
            if (!Platform.isAndroid)
              const VolumeNormalizationIOSBaseGainEditor(),
            const VolumeNormalizationModeSelector(),
          ],
        ),
      ),
    );
  }
}
