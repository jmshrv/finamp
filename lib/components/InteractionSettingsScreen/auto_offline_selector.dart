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
        return ListTile(
          title: Text("Auto Offline Mode"),
          subtitle: Text(
            "Automatically enable Offline Mode.\n" +
            "Disabled: Wont Automatically turn on Offline Mode. May save battery.\n" +
            "Network: Turn Offline Mode on when not being connected to wifi or ethernet.\n" +
            "Disconnected: Turn Offline Mode on when not being connected to anything.\n\n" +
            "You can always manually turn on offline mode and it will stay on until turned off."),
          trailing: DropdownButton<AutoOfflineOption>(
            value: box.get("FinampSettings")?.autoOffline,
            items: AutoOfflineOption.values
                .map((e) => DropdownMenuItem<AutoOfflineOption>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSetters.setAutoOffline(value);
              }
            },
          ),
        );
      },
    );
  }
}
