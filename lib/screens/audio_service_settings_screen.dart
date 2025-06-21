import 'dart:io';

import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/AudioServiceSettingsScreen/buffer_duration_list_tile.dart';
import '../components/AudioServiceSettingsScreen/loadQueueOnStartup_selector.dart';
import '../components/AudioServiceSettingsScreen/stop_foreground_selector.dart';
import '../components/AudioServiceSettingsScreen/track_shuffle_item_count_editor.dart';

class AudioServiceSettingsScreen extends StatefulWidget {
  const AudioServiceSettingsScreen({super.key});
  static const routeName = "/settings/audioservice";
  @override
  State<AudioServiceSettingsScreen> createState() => _AudioServiceSettingsScreenState();
}

class _AudioServiceSettingsScreenState extends State<AudioServiceSettingsScreen> {
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
          AudioFadeInDurationListTile(key: _updateChildren),
          AudioFadeOutDurationListTile(key: _updateChildren),
          if (Platform.isAndroid) BufferSizeListTile(key: _updateChildren),
          BufferDurationListTile(key: _updateChildren),
          BufferDisableSizeConstraintsSelector(key: _updateChildren),
          const LoadQueueOnStartupSelector(),
          const AutoReloadQueueToggle(),
        ],
      ),
    );
  }
}

class BufferDisableSizeConstraintsSelector extends ConsumerWidget {
  const BufferDisableSizeConstraintsSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.bufferDisableSizeConstraintsTitle),
      subtitle: Text(AppLocalizations.of(context)!.bufferDisableSizeConstraintsSubtitle),
      value: ref.watch(finampSettingsProvider.bufferDisableSizeConstraints),
      onChanged: FinampSetters.setBufferDisableSizeConstraints,
    );
  }
}

class BufferSizeListTile extends StatefulWidget {
  const BufferSizeListTile({super.key});

  @override
  State<BufferSizeListTile> createState() => _BufferSizeListTileState();
}

class _BufferSizeListTileState extends State<BufferSizeListTile> {
  final _controller = TextEditingController(text: FinampSettingsHelper.finampSettings.bufferSizeMegabytes.toString());

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

class AudioFadeInDurationListTile extends StatefulWidget {
  const AudioFadeInDurationListTile({super.key});

  @override
  State<AudioFadeInDurationListTile> createState() => _AudioFadeInDurationListTileState();
}

class _AudioFadeInDurationListTileState extends State<AudioFadeInDurationListTile> {
  final _controller =
      TextEditingController(text: FinampSettingsHelper.finampSettings.audioFadeInDuration.inMilliseconds.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.audioFadeInDurationSettingTitle),
      subtitle: Text(AppLocalizations.of(context)!.audioFadeInDurationSettingSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueInt = int.tryParse(value);

            if (valueInt != null && !valueInt.isNegative) {
              FinampSetters.setAudioFadeInDuration(Duration(milliseconds: valueInt));
            }
          },
        ),
      ),
    );
  }
}

class AudioFadeOutDurationListTile extends StatefulWidget {
  const AudioFadeOutDurationListTile({super.key});

  @override
  State<AudioFadeOutDurationListTile> createState() => _AudioFadeOutDurationListTileState();
}

class _AudioFadeOutDurationListTileState extends State<AudioFadeOutDurationListTile> {
  final _controller =
      TextEditingController(text: FinampSettingsHelper.finampSettings.audioFadeOutDuration.inMilliseconds.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.audioFadeOutDurationSettingTitle),
      subtitle: Text(AppLocalizations.of(context)!.audioFadeOutDurationSettingSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueInt = int.tryParse(value);

            if (valueInt != null && !valueInt.isNegative) {
              FinampSetters.setAudioFadeOutDuration(Duration(milliseconds: valueInt));
            }
          },
        ),
      ),
    );
  }
}

class AutoReloadQueueToggle extends ConsumerWidget {
  const AutoReloadQueueToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.autoReloadQueueTitle),
      subtitle: Text(AppLocalizations.of(context)!.autoReloadQueueSubtitle),
      value: ref.watch(finampSettingsProvider.autoReloadQueue),
      onChanged: FinampSetters.setAutoReloadQueue,
    );
  }
}
