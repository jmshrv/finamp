import 'dart:io';

import "package:super_sliver_list/super_sliver_list.dart";
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';

import '../components/VolumeNormalizationSettingsScreen/volume_normalization_ios_base_gain_editor.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_mode_selector.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_switch.dart';

class VolumeNormalizationSettingsScreen extends StatefulWidget {
  const VolumeNormalizationSettingsScreen({super.key});
  static const routeName = "/settings/volume-normalization";
  @override
  State<VolumeNormalizationSettingsScreen> createState() => _VolumeNormalizationSettingsScreenState();
}

class _VolumeNormalizationSettingsScreenState extends State<VolumeNormalizationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.volumeNormalizationSettingsTitle),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(context, () {
            setState(() {
              FinampSettingsHelper.resetNormalizationSettings();
            });
          }),
        ],
      ),
      body: SuperListView(
        children: [
          const VolumeNormalizationSwitch(),
          if (!Platform.isAndroid) const VolumeNormalizationIOSBaseGainEditor(),
          const VolumeNormalizationModeSelector(),
        ],
      ),
    );
  }
}
