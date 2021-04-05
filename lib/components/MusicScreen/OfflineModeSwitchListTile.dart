import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class OfflineModeSwitchListTile extends StatelessWidget {
  const OfflineModeSwitchListTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.settingsListener,
      builder: (context, box, widget) {
        return SwitchListTile(
          title: Text("Offline Mode"),
          secondary: Icon(Icons.cloud_off),
          value: box.get("FinampSettings").isOffline,
          onChanged: (value) {
            FinampSettings finampSettingsTemp = box.get("FinampSettings");
            finampSettingsTemp.isOffline = value;
            box.put("FinampSettings", finampSettingsTemp);
          },
        );
      },
    );
  }
}
