import 'dart:io';

import 'package:finamp/components/NetworkSettingsScreen/active_network_display.dart';
import 'package:finamp/components/NetworkSettingsScreen/auto_offline_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_address_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_name_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/public_address_selector.dart';
import 'package:finamp/components/ensure_location_permission_prompt.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/jellyfin_api.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/network_manager.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkSettingsScreen extends StatefulWidget {
  const NetworkSettingsScreen({super.key});
  static const routeName = "/settings/network";

  @override
  State<NetworkSettingsScreen> createState() => _NetworkSettingsScreenState();
}

class _NetworkSettingsScreenState extends State<NetworkSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.networkSettingsTitle),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetNetworkSettings)
        ],
      ),
      body: ListView(
        children: [
          AutoOfflineSelector(),
          Divider(),
          ActiveNetworkDisplay(),
          PublicAddressSelector(),
          if (Platform.isAndroid || Platform.isIOS)
            ListTile(
              leading: Icon(Icons.info_outline),
              subtitle: Text(AppLocalizations.of(context)!.preferHomeNetworkInfoBox),
            ),
          HomeNetworkSelector(),
          HomeNetworkNameSelector(),
          TextButton(
              onPressed: () async {
                bool allowed = await ensureLocationPermissions(context);
                if (!allowed) return;

                // Get the current network name
                String? network = await NetworkInfo().getWifiName();
                if (network == null) {
                  GlobalSnackbar.message((context) => AppLocalizations.of(context)!.preferHomeNetworkFailedToReadNetworkNameError);
                  return;
                }

                // android returns the network name with quotes
                GetIt
                  .instance<FinampUserHelper>()
                  .currentUser
                  ?.update(
                    newHomeNetworkName: network.replaceAll("\"", ""));
                await changeTargetUrl();
              },
              child: Text(AppLocalizations.of(context)!.preferHomeNetworkGetNetworkNameButton)),
          HomeNetworkAddressSelector(),
          TextButton(
            onPressed: () async {
              await GetIt.instance<JellyfinApiHelper>().pingServer()
                .then((available) {
                  if (available) {
                    GlobalSnackbar.message((context) => AppLocalizations.of(context)!.pingSuccessful);
                  } else {
                    GlobalSnackbar.message((context) => AppLocalizations.of(context)!.pingFailed);
                  }
                });
            },
            child: Text(AppLocalizations.of(context)!.testConnectionButtonLabel))
        ],
      ),
    );
  }
}
