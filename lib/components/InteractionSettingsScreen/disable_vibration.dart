import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class DisableVibrationSelector extends StatelessWidget {
  const DisableVibrationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.enableVibration),
          subtitle: Text(AppLocalizations.of(context)!.enableVibrationSubtitle),
          value: FinampSettingsHelper.finampSettings.enableVibration,
          onChanged: (value) => FinampSetters.setEnableVibration(value),
        );
      },
    );
  }
}
