import 'dart:async';
import 'dart:ffi';

import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:finamp/components/MusicScreen/offline_mode_switch_list_tile.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class OfflineModeStatusLabel extends ConsumerWidget {
  const OfflineModeStatusLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {    
    AutoOfflineOption automation = ref.watch(finampSettingsProvider.autoOffline);

    if (automation == AutoOfflineOption.disabled) {
      return SizedBox.shrink();
    }
    bool override = !ref.watch(finampSettingsProvider.autoOfflineListenerActive);
    if (!override) {
      return SizedBox.shrink();
    }

    return ListTile(
      autofocus: false,
      title: Text("Automatic switching paused"),
      subtitle: Text("Tap to reenable automatic switching"),
      onTap: () {
            FinampSetters.setAutoOfflineListenerActive(true);
      }
    );
  }
}
