import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class StopForegroundSelector extends StatelessWidget {
  const StopForegroundSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
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
