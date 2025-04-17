import 'dart:io';

import 'package:finamp/components/NetworkSettingsScreen/active_network_display.dart';
import 'package:finamp/components/NetworkSettingsScreen/auto_offline_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_address_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_name_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/public_address_selector.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

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
        title: Text("Network"),
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
              subtitle: Text(
                  "This Feature requires Location permissions in order to access the network name. Additionally location needs to be enabled."),
            ),
          HomeNetworkSelector(),
          HomeNetworkNameSelector(),
          TextButton(
              onPressed: () async {
                //Check if location permission is granted
                if (Platform.isAndroid || Platform.isIOS) {
                  PermissionStatus status =
                      await Permission.locationWhenInUse.status;
                  if (status.isDenied) {
                    status = await Permission.locationWhenInUse.request();
                  }
                  if (!status.isGranted) {
                    GlobalSnackbar.error(
                        "Location Permission is denied but required for this feature");
                    return;
                  }
                }
                //Get the current network name
                String? network = await NetworkInfo().getWifiName();
                if (network == null) {
                  GlobalSnackbar.error("Failed to get current network name");
                  return;
                }
                // android returns the network name with quotes
                FinampSetters.setHomeNetworkName(network.replaceAll("\"", ""));
              },
              child: Text("Use current network name")),
          HomeNetworkAddressSelector(),
        ],
      ),
    );
  }
}
