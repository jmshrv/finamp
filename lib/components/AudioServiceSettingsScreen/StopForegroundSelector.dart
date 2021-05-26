import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class StopForegroundSelector extends StatelessWidget {
  const StopForegroundSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          title: Text("Enter low-priority state on pause"),
          subtitle: Text(
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
