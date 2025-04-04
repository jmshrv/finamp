import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';


class ItemSwipeActionDropdownListTile extends StatelessWidget {
  final DismissDirection direction;
  const ItemSwipeActionDropdownListTile(this.direction, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        final currentSettings = FinampSettingsHelper.finampSettings;
        final text_title = (direction == DismissDirection.startToEnd)
            ? Text(AppLocalizations.of(context)!.swipeFromLeftAction)
            : Text(AppLocalizations.of(context)!.swipeFromRightAction);
        final text_subtitle = (direction == DismissDirection.startToEnd)
            ? Text(AppLocalizations.of(context)!.swipeFromLeftActionSubtitle)
            : Text(AppLocalizations.of(context)!.swipeFromRightActionSubtitle);
        final dropdownValue = (direction == DismissDirection.startToEnd) 
            ? currentSettings.itemSwipeActionLeft
            : currentSettings.itemSwipeActionRight;
         
        return ListTile(
          title: text_title,
          subtitle: text_subtitle,
          trailing: DropdownButton<ItemSwipeActions>(
            value: dropdownValue,
            items: ItemSwipeActions.values
                .map((e) => DropdownMenuItem<ItemSwipeActions>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettingsHelper.setItemSwipeAction(direction, value);
              }
            },
          ),
        );
      },
    );
  }
}
