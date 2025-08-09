import 'package:finamp/components/NetworkSettingsScreen/active_network_display.dart';
import 'package:finamp/components/NetworkSettingsScreen/auto_offline_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_local_network_address_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_local_network_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/public_address_selector.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/screens/settings_screen.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NetworkSettingsScreen extends StatefulWidget implements CategorySettingsScreen {
  NetworkSettingsScreen({super.key});
  String get routeName => "/settings/network";

  List<Widget> get searchableSettingsChildren => const [
    AutoOfflineSelector(),
    PublicAddressSelector(),
    LocalNetworkSelector(),
    LocalNetworkAddressSelector(),
  ];

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
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(context, FinampSettingsHelper.resetNetworkSettings),
        ],
      ),
      body: ListView(
        children: [
          widget.searchableSettingsChildren[0],
          Divider(),
          ActiveNetworkDisplay(),
          ...widget.searchableSettingsChildren.sublist(1),
          TextButton(
            onPressed: () async {
              final [public, private] = await Future.wait([
                GetIt.instance<JellyfinApiHelper>().pingPublicServer(),
                GetIt.instance<JellyfinApiHelper>().pingLocalServer(),
              ]);

              GlobalSnackbar.message(
                (context) => AppLocalizations.of(context)!.ping("${public.toString()}_${private.toString()}"),
              );
            },
            child: Text(AppLocalizations.of(context)!.testConnectionButtonLabel),
          ),
        ],
      ),
    );
  }
}
