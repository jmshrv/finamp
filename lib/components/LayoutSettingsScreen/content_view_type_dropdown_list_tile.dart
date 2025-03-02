import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class ContentViewTypeDropdownListTile extends StatelessWidget {
  const ContentViewTypeDropdownListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return ListTile(
          title: Text(AppLocalizations.of(context)!.viewType),
          subtitle: Text(AppLocalizations.of(context)!.viewTypeSubtitle),
          trailing: DropdownButton<ContentViewType>(
            value: box.get("FinampSettings")?.contentViewType,
            items: ContentViewType.values
                .map((e) => DropdownMenuItem<ContentViewType>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettingsHelper.setContentViewType(value);
              }
            },
          ),
        );
      },
    );
  }
}
