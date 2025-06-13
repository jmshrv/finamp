import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class OfflineModeSwitchListTile extends ConsumerWidget {
  const OfflineModeSwitchListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    AutoOfflineOption automation =
        ref.watch(finampSettingsProvider.autoOffline);
    bool overrideActive =
        !ref.watch(finampSettingsProvider.autoOfflineListenerActive);
    int activeDelays = ref.watch(autoOfflineStatusProvider);

    IconData getCurrentIcon() {
      if (overrideActive) {
        return TablerIcons.cloud_pause;
      } else if (automation == AutoOfflineOption.disabled) {
        return TablerIcons.cloud_off;
      } else if (activeDelays > 0) {
        return TablerIcons.cloud_search;
      } else {
        return Icons.cloud_sync_outlined;
      }
    }

    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.offlineMode),
      secondary: Padding(
        padding: const EdgeInsets.only(right: 16),
          child: Icon(getCurrentIcon())
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
