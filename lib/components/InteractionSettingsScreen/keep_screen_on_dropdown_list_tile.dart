import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class KeepScreenOnDropdownListTile extends ConsumerWidget {
  const KeepScreenOnDropdownListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.keepScreenOn),
      subtitle: Text(AppLocalizations.of(context)!.keepScreenOnSubtitle),
      trailing: DropdownButton<KeepScreenOnOption>(
        value: ref.watch(finampSettingsProvider.keepScreenOnOption),
        items: KeepScreenOnOption.values
            .map((e) => DropdownMenuItem<KeepScreenOnOption>(value: e, child: Text(e.toLocalisedString(context))))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            FinampSetters.setKeepScreenOnOption(value);
          }
        },
      ),
    );
  }
}
