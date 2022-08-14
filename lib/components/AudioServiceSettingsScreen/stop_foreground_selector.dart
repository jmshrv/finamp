import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class StopForegroundSelector extends StatelessWidget {
  const StopForegroundSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) {
      // This setting is only available on Android
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          title:
              Text(AppLocalizations.of(context)!.enterLowPriorityStateOnPause),
          subtitle: Text(AppLocalizations.of(context)!
              .enterLowPriorityStateOnPauseSubtitle),
          value:
              FinampSettingsHelper.finampSettings.androidStopForegroundOnPause,
          onChanged: (value) =>
              FinampSettingsHelper.setAndroidStopForegroundOnPause(value),
        );
      },
    );
  }
}
