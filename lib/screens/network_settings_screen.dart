import 'package:finamp/components/NetworkSettingsScreen/active_network_display.dart';
import 'package:finamp/components/NetworkSettingsScreen/auto_offline_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_address_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_name_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_home_network_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/public_address_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/use_current_network.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';

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
        title: Text("Downloads"),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetNetworkSettings)
        ],
      ),
      body: ListView(
        children: const [
          AutoOfflineSelector(),
          ActiveNetworkDisplay(),
          PublicAddressSelector(),
          HomeNetworkSelector(),
          HomeNetworkNameSelector(),
          UseCurrentNetworkButton(),
          HomeNetworkAddressSelector(),
        ],
      ),
    );
  }
}
