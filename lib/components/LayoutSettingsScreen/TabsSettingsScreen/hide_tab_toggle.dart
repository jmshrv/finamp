import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../services/finamp_settings_helper.dart';
import '../../../models/finamp_models.dart';

class HideTabToggle extends StatelessWidget {
  const HideTabToggle({
    Key? key,
    required this.index,
    required this.tabContentType,
  }) : super(key: key);

  final TabContentType tabContentType;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title: Text(tabContentType.toLocalisedString(context)),
          secondary: ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle),
          ),
          // This should never be null, but it gets set to true if it is.
          value: FinampSettingsHelper.finampSettings.showTabs[tabContentType] ??
              true,
          onChanged: (value) =>
              FinampSettingsHelper.setShowTab(tabContentType, value),
        );
      },
    );
  }
}
