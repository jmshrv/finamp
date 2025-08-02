import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class AutoExpandPlayerScreenSelector extends ConsumerWidget {
  const AutoExpandPlayerScreenSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.autoExpandPlayerScreenTitle),
      subtitle: Text(AppLocalizations.of(context)!.autoExpandPlayerScreenSubtitle),
      value: ref.watch(finampSettingsProvider.autoExpandPlayerScreen),
      onChanged: (value) => FinampSetters.setAutoExpandPlayerScreen(value),
    );
  }
}
