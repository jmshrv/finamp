import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class HomeNetworkAddressSelector extends ConsumerWidget {
  const HomeNetworkAddressSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preferLocalNetwork = ref.watch(finampSettingsProvider.preferHomeNetwork);
    String localNetworkAddress = ref.watch(finampSettingsProvider.homeNetworkAddress);

    final _controller = TextEditingController(
        text: localNetworkAddress.toString());

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return ListTile(
          enabled: preferLocalNetwork,
          title: Text("Home address"), // TODO TRANSLATION
          subtitle: Text("Address to use to connect to your Jellyfin Server when being at home"),
          trailing: SizedBox(
            width: 200 * MediaQuery.of(context).textScaleFactor,
            child: TextField(
              enabled: preferLocalNetwork,
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.url,
              onChanged: (value) {
                FinampSetters.setHomeNetworkAddress(value);
              },
            ),
          ),
        );
      }
    );
  }
}
