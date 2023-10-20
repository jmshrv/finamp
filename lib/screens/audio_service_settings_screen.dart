import 'dart:io';

import 'package:finamp/components/AudioServiceSettingsScreen/replay_gain_normalization_factor_editor.dart';
import 'package:finamp/components/AudioServiceSettingsScreen/replay_gain_target_lufs_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/AudioServiceSettingsScreen/buffer_duration_list_tile.dart';
import '../components/AudioServiceSettingsScreen/stop_foreground_selector.dart';
import '../components/AudioServiceSettingsScreen/song_shuffle_item_count_editor.dart';

class AudioServiceSettingsScreen extends StatelessWidget {
  const AudioServiceSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/audioservice";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.audioService),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            if (Platform.isAndroid) const StopForegroundSelector(),
            const SongShuffleItemCountEditor(),
            const BufferDurationListTile(),
            const ReplayGainTargetLufsEditor(),
            const ReplayGainNormalizationFactorEditor(),
          ],
        ),
      ),
    );
  }
}
