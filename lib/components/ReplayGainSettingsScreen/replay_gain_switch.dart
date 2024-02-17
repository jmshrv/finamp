import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class ReplayGainSwitch extends StatelessWidget {
  const ReplayGainSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? replayGainActive = box.get("FinampSettings")?.replayGainActive;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.replayGainSwitchTitle),
          subtitle:
              Text(AppLocalizations.of(context)!.replayGainSwitchSubtitle),
          value: replayGainActive ?? false,
          onChanged: replayGainActive == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.replayGainActive = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
