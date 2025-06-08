import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class EnablePlayonToggle extends ConsumerWidget {
  const EnablePlayonToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.enablePlayonTitle),
      subtitle: Text(AppLocalizations.of(context)!.enablePlayonSubtitle),
      value: ref.watch(finampSettingsProvider.enablePlayon),
      onChanged: FinampSetters.setEnablePlayon,
    );
  }
}
