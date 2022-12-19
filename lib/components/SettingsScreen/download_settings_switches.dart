import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/finamp_models.dart';

class DownloadSettingsSwitches extends StatefulWidget {
  const DownloadSettingsSwitches({Key? key}) : super(key: key);

  @override
  State<DownloadSettingsSwitches> createState() =>
      _DownloadSettingsSwitchesState();
}

class _DownloadSettingsSwitchesState extends State<DownloadSettingsSwitches> {
  bool onlyDownloadWithWifi = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          value: FinampSettingsHelper.finampSettings.onlyDownloadWithWifi,
          onChanged: (value) =>
              FinampSettingsHelper.setOnlyDownloadWithWifi(value),
        );
      },
    );
  }
}
