import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class UseCoverAsBackgroundToggle extends StatelessWidget {
  const UseCoverAsBackgroundToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.useCoverAsBackground),
          subtitle:
              Text(AppLocalizations.of(context)!.useCoverAsBackgroundSubtitle),
          value: FinampSettingsHelper.finampSettings.useCoverAsBackground,
          onChanged: (value) => FinampSetters.setUseCoverAsBackground(value),
        );
      },
    );
  }
}
