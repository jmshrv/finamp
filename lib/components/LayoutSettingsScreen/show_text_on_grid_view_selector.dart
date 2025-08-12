import 'package:finamp/builders/annotations.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

part "show_text_on_grid_view_selector.g.dart";

@Searchable()
class ShowTextOnGridViewSelector extends ConsumerWidget {
  const ShowTextOnGridViewSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.showTextOnGridView),
      subtitle: Text(AppLocalizations.of(context)!.showTextOnGridViewSubtitle),
      value: ref.watch(finampSettingsProvider.showTextOnGridView),
      onChanged: (value) => FinampSetters.setShowTextOnGridView(value),
    );
  }
}
