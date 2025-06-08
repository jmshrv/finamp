import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class OfflineModeSwitchListTile extends ConsumerWidget {
  const OfflineModeSwitchListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    int activeDelays = ref.watch(autoOfflineStatusProvider);

    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.offlineMode),
      secondary: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Icon(activeDelays == 0 ? Icons.cloud_off : Icons.cloud_sync_outlined)
      ),
      inactiveTrackColor: Colors.transparent,
      value: ref.watch(finampSettingsProvider.isOffline),
      onChanged: (value) {

        AutoOfflineOption automationStatus = FinampSettingsHelper.finampSettings.autoOffline;

        if (automationStatus != AutoOfflineOption.disabled) {
          // Pause Automation
          FinampSetters.setAutoOfflineListenerActive(false);
        }
        FinampSetters.setIsOffline(value);
      },
    );
  }
}
