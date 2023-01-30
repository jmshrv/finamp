import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class DisableGestureSelector extends StatelessWidget {
  const DisableGestureSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.disableGesture),
          subtitle: Text(AppLocalizations.of(context)!.disableGestureSubtitle),
          value: FinampSettingsHelper.finampSettings.disableGesture,
          onChanged: (value) => FinampSettingsHelper.setDisableGesture(value),
        );
      },
    );
  }
}
