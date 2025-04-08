import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class HomeNetworkSelector extends ConsumerWidget {
  const HomeNetworkSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preferLocalNetwork = ref.watch(finampSettingsProvider.preferHomeNetwork);

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title: Text("Prefer Home Network"), // TODO TRANSLATION
          subtitle: Text("When your home network is detected the local IP you give will be used."),
          value: preferLocalNetwork,
          onChanged: (value) => FinampSetters.setPreferHomeNetwork(value),
        );
      }
    );
  }
}
