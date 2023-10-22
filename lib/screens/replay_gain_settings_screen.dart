import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/ReplayGainSettingsScreen/replay_gain_switch.dart';
import '../components/ReplayGainSettingsScreen/replay_gain_mode_selector.dart';
import '../components/ReplayGainSettingsScreen/replay_gain_normalization_factor_editor.dart';
import '../components/ReplayGainSettingsScreen/replay_gain_target_lufs_editor.dart';

class ReplayGainSettingsScreen extends StatelessWidget {
  const ReplayGainSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/replaygain";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Replay Gain"),
      ),
      body: Scrollbar(
        child: ListView(
          children: const [
            ReplayGainSwitch(),
            ReplayGainTargetLufsEditor(),
            ReplayGainNormalizationFactorEditor(),
            ReplayGainModeSelector(),
          ],
        ),
      ),
    );
  }
}
