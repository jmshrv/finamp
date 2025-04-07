import 'dart:io';


import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';

import '../components/PlaybackReportingSettingsScreen/periodic_playback_session_update_frequency_editor.dart';
import '../components/PlaybackReportingSettingsScreen/report_queue_to_server_toggle.dart';
import '../components/PlaybackReportingSettingsScreen/play_on_stale_delay_editor.dart';
import '../components/PlaybackReportingSettingsScreen/play_on_reconnection_delay_editor.dart';

class PlaybackReportingSettingsScreen extends StatefulWidget {
  const PlaybackReportingSettingsScreen({super.key});
  static const routeName = "/settings/playback-reporting";
  @override
  State<PlaybackReportingSettingsScreen> createState() =>
      _PlaybackReportingSettingsScreenState();
}

class _PlaybackReportingSettingsScreenState
    extends State<PlaybackReportingSettingsScreen> {
  // Overwriting this value causes the childrens to update
  // this is a required workaround because some input fields
  // might not update when resetting to defaults
  Key _updateChildren = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.playbackReportingSettingsTitle),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(context, () {
            setState(() {
              FinampSettingsHelper.resetNormalizationSettings();
              _updateChildren = UniqueKey(); // Trigger rebuilding of Children
            });
          })
        ],
      ),
      body: ListView(
        children: [
          const PeriodicPlaybackSessionUpdateFrequencyEditor(),
          const ReportQueueToServerToggle(),
          const PlayOnStaleDelayEditor(),
          const PlayOnReconnectionDelayEditor()
        ],
      ),
    );
  }
}
