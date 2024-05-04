import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class VolumeNormalizationSwitch extends StatelessWidget {
  const VolumeNormalizationSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? volumeNormalizationActive =
            box.get("FinampSettings")?.volumeNormalizationActive;

        return SwitchListTile.adaptive(
          title: Text(
              AppLocalizations.of(context)!.volumeNormalizationSwitchTitle),
          subtitle: Text(
              AppLocalizations.of(context)!.volumeNormalizationSwitchSubtitle),
          value: volumeNormalizationActive ?? false,
          onChanged: volumeNormalizationActive == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.volumeNormalizationActive = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
