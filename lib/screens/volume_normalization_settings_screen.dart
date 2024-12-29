import 'dart:io';

import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/VolumeNormalizationSettingsScreen/volume_normalization_ios_base_gain_editor.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_mode_selector.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_switch.dart';

class VolumeNormalizationSettingsScreen extends  StatefulWidget {
  const VolumeNormalizationSettingsScreen({super.key});
  static const routeName = "/settings/volume-normalization";
  @override
  State<VolumeNormalizationSettingsScreen> createState() =>
    _VolumeNormalizationSettingsScreenState();
}

class _VolumeNormalizationSettingsScreenState extends State<VolumeNormalizationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.volumeNormalizationSettingsTitle),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                FinampSettingsHelper.resetNormalizationSettings();
              });
            },
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.resetToDefaults,
          )
        ],
      ),
      body: ListView(
        children: [
          const VolumeNormalizationSwitch(),
          if (!Platform.isAndroid) const VolumeNormalizationIOSBaseGainEditor(),
          const VolumeNormalizationModeSelector(),
        ],
      ),
    );
  }
}
