import 'dart:io';

import 'package:finamp/components/NetworkSettingsScreen/active_network_display.dart';
import 'package:finamp/components/NetworkSettingsScreen/auto_offline_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_address_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_name_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/public_address_selector.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkSettingsScreen extends StatefulWidget {
  const NetworkSettingsScreen({super.key});
  static const routeName = "/settings/network";

  @override
  State<NetworkSettingsScreen> createState() =>
      _NetworkSettingsScreenState();
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
              subtitle: Text("This Feature requires Location permissions in order to access the network name. Additionally location needs to be enabled."),
            ),
          HomeNetworkSelector(),
          HomeNetworkNameSelector(),
          TextButton(
            onPressed: () async {
              String? network = await NetworkInfo().getWifiName();
              if (network == null) return;
              // android returns the network name with quotes
              FinampSetters.setHomeNetworkName(network.replaceAll("\"", ""));
            },
            child: Text("Use current network name")
          ),
          HomeNetworkAddressSelector(),
        ],
      ),
    );
  }
}
