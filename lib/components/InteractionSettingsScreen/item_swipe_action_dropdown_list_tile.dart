import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class ItemSwipeLeftToRightActionDropdownListTile extends ConsumerWidget {
  const ItemSwipeLeftToRightActionDropdownListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var action = ref.watch(finampSettingsProvider.itemSwipeActionLeftToRight);
    return ListTile(
      title: Text(AppLocalizations.of(context)!.swipeLeftToRightAction),
      subtitle: Text(AppLocalizations.of(context)!.swipeLeftToRightActionSubtitle),
      trailing: DropdownButton<ItemSwipeActions>(
        value: action,
        items: ItemSwipeActions.values
            .map((e) => DropdownMenuItem<ItemSwipeActions>(value: e, child: Text(e.toLocalisedString(context))))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            FinampSetters.setItemSwipeActionLeftToRight(value);
          }
        },
      ),
    );
  }
}

class ItemSwipeRightToLeftActionDropdownListTile extends ConsumerWidget {
  const ItemSwipeRightToLeftActionDropdownListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var action = ref.watch(finampSettingsProvider.itemSwipeActionRightToLeft);
    return ListTile(
      title: Text(AppLocalizations.of(context)!.swipeRightToLeftAction),
      subtitle: Text(AppLocalizations.of(context)!.swipeRightToLeftActionSubtitle),
      trailing: DropdownButton<ItemSwipeActions>(
        value: action,
        items: ItemSwipeActions.values
            .map((e) => DropdownMenuItem<ItemSwipeActions>(value: e, child: Text(e.toLocalisedString(context))))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            FinampSetters.setItemSwipeActionRightToLeft(value);
          }
        },
      ),
    );
  }
}
