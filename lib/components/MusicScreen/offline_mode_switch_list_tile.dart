import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class OfflineModeSwitchListTile extends StatelessWidget {
  const OfflineModeSwitchListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, widget) {
        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.offlineMode),
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
