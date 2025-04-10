import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class DisableGestureSelector extends ConsumerWidget {
  const DisableGestureSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.disableGesture),
      subtitle: Text(AppLocalizations.of(context)!.disableGestureSubtitle),
      value: ref.watch(finampSettingsProvider.disableGesture),
      onChanged: (value) => FinampSetters.setDisableGesture(value),
    );
  }
}
