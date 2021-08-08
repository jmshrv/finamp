import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class OfflineModeSwitchListTile extends StatelessWidget {
  const OfflineModeSwitchListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, widget) {
        return SwitchListTile(
          title: const Text("Offline Mode"),
          secondary: const Icon(Icons.cloud_off),
          value: box.get("FinampSettings")?.isOffline ?? false,
          onChanged: (value) {
            FinampSettingsHelper.setIsOffline(value);
          },
        );
      },
    );
  }
}
