import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/ThemeModeHelper.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ThemeMode>>(
      valueListenable: ThemeModeHelper.themeModeListener,
      builder: (_, box, __) {
        return ListTile(
          title: const Text("Theme"),
          trailing: DropdownButton<ThemeMode>(
            value: box.get("ThemeMode"),
            items: ThemeMode.values
                .map((e) => DropdownMenuItem<ThemeMode>(
                      child: Text(
                        e.name.replaceFirst(
                          e.name.characters.first,
                          e.name.characters.first.toUpperCase(),
                        ),
                      ),
                      value: e,
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
