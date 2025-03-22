import 'dart:io';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

import '../components/AudioServiceSettingsScreen/buffer_duration_list_tile.dart';
import '../components/AudioServiceSettingsScreen/loadQueueOnStartup_selector.dart';
import '../components/AudioServiceSettingsScreen/periodic_playback_session_update_frequency_editor.dart';
import '../components/AudioServiceSettingsScreen/report_queue_to_server_toggle.dart';
import '../components/AudioServiceSettingsScreen/stop_foreground_selector.dart';
import '../components/AudioServiceSettingsScreen/track_shuffle_item_count_editor.dart';

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
          TrackShuffleItemCountEditor(key: _updateChildren),
          if (Platform.isAndroid) BufferSizeListTile(key: _updateChildren),
          BufferDurationListTile(key: _updateChildren),
          BufferDisableSizeConstraintsSelector(key: _updateChildren),
          const LoadQueueOnStartupSelector(),
          PeriodicPlaybackSessionUpdateFrequencyEditor(key: _updateChildren),
          const ReportQueueToServerToggle(),
        ],
      ),
    );
  }
}

class BufferDisableSizeConstraintsSelector extends ConsumerWidget {
  const BufferDisableSizeConstraintsSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title: Text(
              AppLocalizations.of(context)!.bufferDisableSizeConstraintsTitle),
          subtitle: Text(AppLocalizations.of(context)!
              .bufferDisableSizeConstraintsSubtitle),
          value: ref.watch(finampSettingsProvider.bufferDisableSizeConstraints),
          onChanged: FinampSetters.setBufferDisableSizeConstraints,
        );
      },
    );
  }
}

class BufferSizeListTile extends StatefulWidget {
  const BufferSizeListTile({super.key});

  @override
  State<BufferSizeListTile> createState() => _BufferSizeListTileState();
}

class _BufferSizeListTileState extends State<BufferSizeListTile> {
  final _controller = TextEditingController(
      text: FinampSettingsHelper.finampSettings.bufferSizeMegabytes.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.bufferSizeTitle),
      subtitle: Text(AppLocalizations.of(context)!.bufferSizeSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            var valueInt = int.tryParse(value);

            if (valueInt != null && !valueInt.isNegative) {
              // minimum buffer size is 60, if we go below that, the player will crash
              if (valueInt < 60) {
                _controller.text = "60";
                valueInt = 60;
              }
              FinampSetters.setBufferSizeMegabytes(valueInt);
            }
          },
        ),
      ),
    );
  }
}
