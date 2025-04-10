import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class StopForegroundSelector extends ConsumerWidget {
  const StopForegroundSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.enterLowPriorityStateOnPause),
      subtitle: Text(
          AppLocalizations.of(context)!.enterLowPriorityStateOnPauseSubtitle),
      value: ref.watch(finampSettingsProvider.androidStopForegroundOnPause),
      onChanged: (value) =>
          FinampSetters.setAndroidStopForegroundOnPause(value),
    );
  }
}
