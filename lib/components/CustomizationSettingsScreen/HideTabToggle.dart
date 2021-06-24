import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class HideTabToggle extends StatelessWidget {
  final String tabTitle;

  const HideTabToggle({Key? key, required this.tabTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          title: Text('Show ' + this.tabTitle),
          value: FinampSettingsHelper.finampSettings.showTabs[this.tabTitle],
          onChanged: (value) => 
              FinampSettingsHelper.setShowTab(this.tabTitle, value),
        );
      },
    );
  }
}
