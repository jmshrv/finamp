import 'dart:io';

import 'package:finamp/components/ensure_location_permission_prompt.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/services/auto_offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class HomeNetworkSelector extends ConsumerWidget {
  const HomeNetworkSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preferLocalNetwork = ref.watch(finampSettingsProvider.preferHomeNetwork);

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, __) {
        return SwitchListTile.adaptive(
          title: Text("Prefer Home Network"), // TODO TRANSLATION
          subtitle: Text("When your home network is detected the local IP you give will be used."),
          value: preferLocalNetwork,
          onChanged: (value) async {
            if (value) {
              value = await ensureLocationPermissions(context);
            }
            FinampSetters.setPreferHomeNetwork(value);
            // go back to public url
            if (!value) await changeTargetUrl(isLocal: false);
          },
        );
      }
    );
  }
}
