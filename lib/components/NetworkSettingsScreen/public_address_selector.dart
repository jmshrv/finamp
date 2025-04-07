import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class PublicAddressSelector extends ConsumerWidget {
  const PublicAddressSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String publicAddress = ref.watch(finampSettingsProvider.publicAddress);

    final _controller = TextEditingController(
        text: publicAddress.toString());

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return ListTile(
          title: Text("Public Address"), // TODO TRANSLATION
          subtitle: Text("The is the primary address to use to connect to your jellyfin Server"),
          trailing: SizedBox(
            width: 200 * MediaQuery.of(context).textScaleFactor,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.url,
              onChanged: (value) {
                FinampSetters.setPublicAddress(value);
              },
            ),
          ),
        );
      }
    );
  }
}
