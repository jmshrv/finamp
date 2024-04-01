import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class ResumeOnBluetoothConnectToggle extends StatelessWidget {
  const ResumeOnBluetoothConnectToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title:
              Text(AppLocalizations.of(context)!.resumeOnBluetoothConnect),
          subtitle: Text(AppLocalizations.of(context)!
              .resumeOnBluetoothConnectSubtitle),
          value:
              FinampSettingsHelper.finampSettings.resumeOnBluetoothConnect,
          onChanged: (value) =>
              FinampSettingsHelper.setResumeOnBluetoothConnect(value),
        );
      },
    );
  }
}
