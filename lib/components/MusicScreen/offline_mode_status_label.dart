import 'dart:async';
import 'dart:ffi';

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

    String displayText = "Automation disabled";

    if (automation != AutoOfflineOption.disabled) {
        bool override = !ref.watch(finampSettingsProvider.autoOfflineListenerActive);

        displayText = "${override ? "Override" : "Automation"} active";
    }

    return ListTile(
      autofocus: false,
      title: Text(displayText),
    );
  }
}
