import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class StopForegroundSelector extends StatelessWidget {
  const StopForegroundSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          title: const Text("Enter low-priority state on pause"),
          subtitle: const Text(
              "When enabled, the notification can be swiped away when paused. Enabling this also allows Android to kill the service when paused. Has no effect on iOS."),
          value:
              FinampSettingsHelper.finampSettings.androidStopForegroundOnPause,
          onChanged: (value) =>
              FinampSettingsHelper.setAndroidStopForegroundOnPause(value),
        );
      },
    );
  }
}
