import 'dart:io';

import 'package:finamp/components/NetworkSettingsScreen/active_network_display.dart';
import 'package:finamp/components/NetworkSettingsScreen/auto_offline_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_address_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/public_address_selector.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
          HomeNetworkSelector(),
          HomeNetworkAddressSelector(),
          TextButton(
            onPressed: () async {
              final user = GetIt.instance<FinampUserHelper>().currentUser!;
              final active = user.baseURL;
              final local = user.homeAddress;
              await GetIt.instance<JellyfinApiHelper>().pingActiveServer()
                .then((available) {
                  if (available) {
                    GlobalSnackbar.message((context) => AppLocalizations.of(context)!.pingSuccessful(active));
                  } else {
                    GlobalSnackbar.message((context) => AppLocalizations.of(context)!.pingFailed(active));
                  }
                });
              if (active != local) {
                await GetIt.instance<JellyfinApiHelper>().pingLocalServer()
                  .then((available) {
                    if (available) {
                      GlobalSnackbar.message((context) => AppLocalizations.of(context)!.pingSuccessful(local));
                    } else {
                      GlobalSnackbar.message((context) => AppLocalizations.of(context)!.pingFailed(local));
                    }
                  });
              }
            },
            child: Text(AppLocalizations.of(context)!.testConnectionButtonLabel))
        ],
      ),
    );
  }
}
