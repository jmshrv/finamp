import 'package:finamp/components/NetworkSettingsScreen/active_network_display.dart';
import 'package:finamp/components/NetworkSettingsScreen/auto_offline_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_local_network_address_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/prefer_local_network_selector.dart';
import 'package:finamp/components/NetworkSettingsScreen/public_address_selector.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(context, FinampSettingsHelper.resetNetworkSettings),
        ],
      ),
      body: ListView(
        children: [
          AutoOfflineSelector(),
          Divider(),
          ActiveNetworkDisplay(),
          PublicAddressSelector(),
          LocalNetworkSelector(),
          LocalNetworkAddressSelector(),
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
          AudioMuseAddressSelector(),
        ],
      ),
    );
  }
}


class AudioMuseAddressSelector extends ConsumerStatefulWidget {
  const AudioMuseAddressSelector({super.key});

  @override
  ConsumerState<AudioMuseAddressSelector> createState() => _AudioMuseAddressSelector();
}

class _AudioMuseAddressSelector extends ConsumerState<AudioMuseAddressSelector> {
  TextEditingController? _controller;
  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String audioMuseAddress = ref.watch(finampSettingsProvider.audioMuseBaseAddress);

    _controller ??= TextEditingController(text: audioMuseAddress);

    return ListTile(
      enabled: true,
      title: Text("AudioMuse Address"),
      subtitle: Text("The base URL for the AudioMuse server, including the port"),
      trailing: SizedBox(
        width: 200 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          enabled: true,
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.url,
          onSubmitted: (value) async {
            if (!value.startsWith("http")) {
              return GlobalSnackbar.message((context) => AppLocalizations.of(context)!.missingSchemaError);
            }
            FinampSetters.setAudioMuseBaseAddress(value);
          },
        ),
      ),
    );
  }
}
