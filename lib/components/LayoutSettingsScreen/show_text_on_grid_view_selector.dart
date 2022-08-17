import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class ShowTextOnGridViewSelector extends StatelessWidget {
  const ShowTextOnGridViewSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          title: Text(AppLocalizations.of(context)!.showTextOnGridView),
          subtitle:
              Text(AppLocalizations.of(context)!.showTextOnGridViewSubtitle),
          value: FinampSettingsHelper.finampSettings.showTextOnGridView,
          onChanged: (value) =>
              FinampSettingsHelper.setShowTextOnGridView(value),
        );
      },
    );
  }
}
