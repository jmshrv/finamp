import 'dart:io';

import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/AudioServiceSettingsScreen/buffer_duration_list_tile.dart';
import '../components/AudioServiceSettingsScreen/loadQueueOnStartup_selector.dart';
import '../components/AudioServiceSettingsScreen/periodic_playback_session_update_frequency_editor.dart';
import '../components/AudioServiceSettingsScreen/report_queue_to_server_toggle.dart';
import '../components/AudioServiceSettingsScreen/song_shuffle_item_count_editor.dart';
import '../components/AudioServiceSettingsScreen/stop_foreground_selector.dart';

class AudioServiceSettingsScreen extends StatefulWidget {
  const AudioServiceSettingsScreen({super.key});
  static const routeName = "/settings/audioservice";
  @override
  State<AudioServiceSettingsScreen> createState() =>
      _AudioServiceSettingsScreenState();
}

class _AudioServiceSettingsScreenState
    extends State<AudioServiceSettingsScreen> {
  // Overwriting this value causes the childrens to update
  // this is a required workaround because some input fields
  // might not update when resetting to defaults
  Key _updateChildren = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.audioService),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(context, () {
            setState(() {
              FinampSettingsHelper.resetAudioServiceSettings();
              _updateChildren = UniqueKey(); // Trigger rebuilding of Children
            });
          })
        ],
      ),
      body: ListView(
        children: [
          if (Platform.isAndroid) StopForegroundSelector(key: _updateChildren),
          SongShuffleItemCountEditor(key: _updateChildren),
          BufferDurationListTile(key: _updateChildren),
          const LoadQueueOnStartupSelector(),
          PeriodicPlaybackSessionUpdateFrequencyEditor(key: _updateChildren),
          const ReportQueueToServerToggle(),
        ],
      ),
    );
  }
}
