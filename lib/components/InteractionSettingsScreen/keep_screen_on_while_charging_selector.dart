import 'package:finamp/builders/annotations.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

part "keep_screen_while_charging_selector.g.dart";

@Searchable()
class KeepScreenOnWhilePluggedInSelector extends ConsumerWidget {
  const KeepScreenOnWhilePluggedInSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.keepScreenOnWhilePluggedIn),
      subtitle: Text(AppLocalizations.of(context)!.keepScreenOnWhilePluggedInSubtitle),
      value: ref.watch(finampSettingsProvider.keepScreenOnWhilePluggedIn),
      onChanged: (value) {
        FinampSetters.setKeepScreenOnWhilePluggedIn(value);
      },
    );
  }
}
