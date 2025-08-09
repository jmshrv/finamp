import 'dart:io';

import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/screens/settings_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';

import '../components/VolumeNormalizationSettingsScreen/volume_normalization_ios_base_gain_editor.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_mode_selector.dart';
import '../components/VolumeNormalizationSettingsScreen/volume_normalization_switch.dart';

class VolumeNormalizationSettingsScreen extends StatefulWidget
    implements CategorySettingsScreen {
  const VolumeNormalizationSettingsScreen({super.key});
  @override
  String get routeName => "/settings/volume-normalization";
  @override
  List<Widget> get searchableSettingsChildren => const [
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
          ...widget.searchableSettingsChildren.sublist(0, 1),
          if (!Platform.isAndroid) const VolumeNormalizationIOSBaseGainEditor(),
          ...widget.searchableSettingsChildren.sublist(1),
        ],
      ),
    );
  }
}
