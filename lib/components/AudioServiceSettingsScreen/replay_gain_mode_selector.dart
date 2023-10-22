import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/theme_mode_helper.dart';

extension LocalisedName on ReplayGainMode {
  String toLocalisedString(BuildContext context) =>
      _humanReadableLocalisedName(this, context);

  String _humanReadableLocalisedName(
      ReplayGainMode themeMode, BuildContext context) {
    switch (themeMode) {
      case ReplayGainMode.hybrid:
        return "Hybrid (Track + Album)";
      case ReplayGainMode.trackOnly:
        return "Tracks Only";
      case ReplayGainMode.albumOnly:
        return "Albums Only";
    }
  }
}

class ReplayGainModeSelector extends StatelessWidget {
  const ReplayGainModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        ReplayGainMode? replayGainMode = box.get("FinampSettings")?.replayGainMode;
        return ListTile(
          title: Text("Replay Gain Mode"),
          subtitle: Text("When and how to apply Replay Gain"),
          trailing: DropdownButton<ReplayGainMode>(
            value: replayGainMode,
            items: ReplayGainMode.values
                .map((e) => DropdownMenuItem<ReplayGainMode>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.replayGainMode = value;
                  box.put("FinampSettings", finampSettingsTemp);
              }
            },
          ),
        );
      },
    );
  }
}
