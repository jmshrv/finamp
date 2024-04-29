import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/ReplayGainSettingsScreen/replay_gain_ios_base_gain_editor.dart';
import '../components/ReplayGainSettingsScreen/replay_gain_switch.dart';
import '../components/ReplayGainSettingsScreen/replay_gain_mode_selector.dart';

class ReplayGainSettingsScreen extends StatelessWidget {
  const ReplayGainSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/replaygain";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.replayGainSettingsTitle),
      ),
      body: Scrollbar(
        child: ListView(
          children: const [
            ReplayGainSwitch(),
            ReplayGainIOSBaseGainEditor(),
            ReplayGainModeSelector(),
          ],
        ),
      ),
    );
  }
}
