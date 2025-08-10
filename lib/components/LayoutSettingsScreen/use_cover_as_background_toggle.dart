import 'package:finamp/builders/annotations.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

part "use_cover_as_background_toggle.dart";

@Searchable()
class UseCoverAsBackgroundToggle extends ConsumerWidget {
  const UseCoverAsBackgroundToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.useCoverAsBackground),
      subtitle: Text(AppLocalizations.of(context)!.useCoverAsBackgroundSubtitle),
      value: ref.watch(finampSettingsProvider.useCoverAsBackground),
      onChanged: (value) => FinampSetters.setUseCoverAsBackground(value),
    );
  }
}
