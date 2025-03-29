import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class OfflineModeSwitchListTile extends StatelessWidget {
  const OfflineModeSwitchListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, widget) {
        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.offlineMode),
          secondary: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.cloud_off),
          ),
          inactiveTrackColor: Colors.transparent,
          value: box.get("FinampSettings")?.isOffline ?? false,
          onChanged: (value) {
            FinampSetters.setIsOffline(value);
          },
        );
      },
    );
  }
}
