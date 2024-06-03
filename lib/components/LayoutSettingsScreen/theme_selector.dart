import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/theme_mode_helper.dart';

extension LocalisedName on ThemeMode {
  String toLocalisedString(BuildContext context) =>
      _humanReadableLocalisedName(this, context);

  String _humanReadableLocalisedName(
      ThemeMode themeMode, BuildContext context) {
    switch (themeMode) {
      case ThemeMode.system:
        return AppLocalizations.of(context)!.system;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.light;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.dark;
    }
  }
}

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ThemeMode>>(
      valueListenable: ThemeModeHelper.themeModeListener,
      builder: (_, box, __) {
        return ListTile(
          title: Text(AppLocalizations.of(context)!.theme),
          trailing: DropdownButton<ThemeMode>(
            value: box.get("ThemeMode"),
            items: ThemeMode.values
                .map((e) => DropdownMenuItem<ThemeMode>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                ThemeModeHelper.setThemeMode(value);
              }
            },
          ),
        );
      },
    );
  }
}
