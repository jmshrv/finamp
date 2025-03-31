import 'package:flutter/material.dart';
// import 'package:finamp/l10n/app_localizations.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class AutoOfflineSelector extends StatelessWidget {
  const AutoOfflineSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title: Text("Auto Offline Mode"),
          subtitle: Text("Automatically turn on offline mode when switching to a cellular connection, turns off automatically when establishing a wifi connection. If you manually enable offline mode it wont be turned off automatically."),
          value: FinampSettingsHelper.finampSettings.autoOffline,
          onChanged: (value) => FinampSetters.setAutoOffline(value),
        );
      },
    );
  }
}
