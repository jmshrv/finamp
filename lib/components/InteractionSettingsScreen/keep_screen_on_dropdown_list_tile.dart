import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class KeepScreenOnDropdownListTile extends StatelessWidget {
  const KeepScreenOnDropdownListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return ListTile(
          title: Text(AppLocalizations.of(context)!.keepScreenOn),
          subtitle: Text(AppLocalizations.of(context)!.keepScreenOnSubtitle),
          trailing: DropdownButton<KeepScreenOnOption>(
            value: box.get("FinampSettings")?.keepScreenOnOption,
            items: KeepScreenOnOption.values
                .map((e) => DropdownMenuItem<KeepScreenOnOption>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettingsHelper.setKeepScreenOnOption(value);
              }
            },
          ),
        );
      },
    );
  }
}
