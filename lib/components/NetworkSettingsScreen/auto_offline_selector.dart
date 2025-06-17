import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class AutoOfflineSelector extends ConsumerWidget {
  const AutoOfflineSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AutoOfflineOption option = ref.watch(finampSettingsProvider.autoOffline);

    return ListTile(
      title: Text(AppLocalizations.of(context)!.autoOfflineSettingTitle),
      subtitle: Text(AppLocalizations.of(context)!.autoOfflineSettingDescription),
      trailing: DropdownButton<AutoOfflineOption>(
        value: option,
        items: AutoOfflineOption.values
            .map((e) => DropdownMenuItem<AutoOfflineOption>(
                  value: e,
                  child: Text(e.toLocalisedString(context)),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            FinampSetters.setAutoOffline(value);
          }
        },
      ),
    );
  }
}
