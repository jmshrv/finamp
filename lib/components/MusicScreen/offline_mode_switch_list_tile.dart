import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class OfflineModeSwitchListTile extends ConsumerWidget {
  const OfflineModeSwitchListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.offlineMode),
      secondary: const Padding(
        padding: EdgeInsets.only(right: 16),
        child: Icon(Icons.cloud_off),
      ),
      inactiveTrackColor: Colors.transparent,
      value: ref.watch(finampSettingsProvider.isOffline),
      onChanged: (value) {
        // when offline mode is enabled manually,
        // prevent the auto offline feature from turning off
        // offline mode automatically. When offline mode
        // is manually turned off, reenable the listener.
        FinampSetters.setAutoOfflineListenerActive(!value);
        FinampSetters.setIsOffline(value);
      },
    );
  }
}
