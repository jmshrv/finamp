import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class TranscodeSwitch extends StatelessWidget {
  const TranscodeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? shouldTranscode = box.get("FinampSettings")?.shouldTranscode;

        return SwitchListTile(
          title: Text(AppLocalizations.of(context)!.enableTranscoding),
          subtitle:
              Text(AppLocalizations.of(context)!.enableTranscodingSubtitle),
          value: shouldTranscode ?? false,
          onChanged: shouldTranscode == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.shouldTranscode = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
