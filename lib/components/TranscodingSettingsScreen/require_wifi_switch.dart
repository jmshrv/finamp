import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class RequireWifiSwitch extends StatelessWidget {
  const RequireWifiSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? shouldTranscode = box.get("FinampSettings")?.requireWifiForDownloads;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.requireWifiForDownloads),
          value: shouldTranscode ?? false,
          onChanged: shouldTranscode == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.requireWifiForDownloads = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
