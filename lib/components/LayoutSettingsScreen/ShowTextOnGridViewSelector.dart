import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/FinampModels.dart';
import '../../services/FinampSettingsHelper.dart';

class ShowTextOnGridViewSelector extends StatelessWidget {
  const ShowTextOnGridViewSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          title: const Text("Show Text on Grid View"),
          subtitle: const Text(
              "Whether or not to show the text (title, artist etc) on the grid music screen."),
          value: FinampSettingsHelper.finampSettings.showTextOnGridView,
          onChanged: (value) =>
              FinampSettingsHelper.setShowTextOnGridView(value),
        );
      },
    );
  }
}
