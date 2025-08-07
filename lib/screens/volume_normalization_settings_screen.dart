import 'dart:io';

import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';

import '../components/VolumeNormalizationSettingsScreen/volume_normalization_ios_base_gain_editor.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_mode_selector.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_switch.dart';

class VolumeNormalizationSettingsScreen extends StatefulWidget {
  const VolumeNormalizationSettingsScreen({super.key});
  static const routeName = "/settings/volume-normalization";
  static const searchableSettingsChildren = const [
    const VolumeNormalizationSwitch(),
    const VolumeNormalizationModeSelector(),
  ];
  @override
  State<VolumeNormalizationSettingsScreen> createState() =>
      _VolumeNormalizationSettingsScreenState();
}

class _VolumeNormalizationSettingsScreenState
    extends State<VolumeNormalizationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.volumeNormalizationSettingsTitle,
        ),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(context, () {
            setState(() {
              FinampSettingsHelper.resetNormalizationSettings();
            });
          }),
        ],
      ),
      body: ListView(
        children: [
          ...VolumeNormalizationSettingsScreen.searchableSettingsChildren
              .sublist(0, 1),
          if (!Platform.isAndroid) const VolumeNormalizationIOSBaseGainEditor(),
          ...VolumeNormalizationSettingsScreen.searchableSettingsChildren
              .sublist(1),
        ],
      ),
    );
  }
}
