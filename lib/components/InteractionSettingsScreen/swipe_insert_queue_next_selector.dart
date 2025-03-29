import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class SwipeInsertQueueNextSelector extends StatelessWidget {
  const SwipeInsertQueueNextSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.swipeInsertQueueNext),
          subtitle:
              Text(AppLocalizations.of(context)!.swipeInsertQueueNextSubtitle),
          value: FinampSettingsHelper.finampSettings.swipeInsertQueueNext,
          onChanged: (value) => FinampSetters.setSwipeInsertQueueNext(value),
        );
      },
    );
  }
}
