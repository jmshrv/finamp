import 'package:finamp/components/PlaybackReportingSettingsScreen/enabled_discord_rpc.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/discord_rpc.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';

import '../components/PlaybackReportingSettingsScreen/enable_playon_toggle.dart';
import '../components/PlaybackReportingSettingsScreen/periodic_playback_session_update_frequency_editor.dart';
import '../components/PlaybackReportingSettingsScreen/play_on_reconnection_delay_editor.dart';
import '../components/PlaybackReportingSettingsScreen/play_on_stale_delay_editor.dart';
import '../components/PlaybackReportingSettingsScreen/report_queue_to_server_toggle.dart';

class PlaybackReportingSettingsScreen extends StatefulWidget {
  const PlaybackReportingSettingsScreen({super.key});
  static const routeName = "/settings/playback-reporting";
  @override
  State<PlaybackReportingSettingsScreen> createState() => _PlaybackReportingSettingsScreenState();
}

class _PlaybackReportingSettingsScreenState extends State<PlaybackReportingSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.playbackReportingSettingsTitle),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(context, () {
            setState(() {
              FinampSettingsHelper.resetNormalizationSettings();
            });
          }),
        ],
      ),
      body: ListView(
        children: [
          const EnablePlayonToggle(),
          const PeriodicPlaybackSessionUpdateFrequencyEditor(),
          const ReportQueueToServerToggle(),
          const PlayOnStaleDelayEditor(),
          const PlayOnReconnectionDelayEditor(),
          const Divider(),
          const EnabledDiscordRpc()
        ],
      ),
    );
  }
}
