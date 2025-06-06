import 'package:finamp/l10n/app_localizations.dart';
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
        // when using the switch it toggles the automation on and off again
        // this is so the user can overwrite the automation at any time with
        // any value.
        bool currentValue = FinampSettingsHelper.finampSettings.autoOfflineListenerActive;
        FinampSetters.setAutoOfflineListenerActive(!currentValue);
        FinampSetters.setIsOffline(value);
      },
    );
  }
}
