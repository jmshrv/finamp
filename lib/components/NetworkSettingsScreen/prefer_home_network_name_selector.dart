import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class HomeNetworkNameSelector extends ConsumerWidget {
  const HomeNetworkNameSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preferLocalNetwork = ref.watch(finampSettingsProvider.preferHomeNetwork);
    String localNetworkName = ref.watch(finampSettingsProvider.homeNetworkName);

    final _controller = TextEditingController(
        text: localNetworkName.toString());

    DateTime lastSave = DateTime.now();

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return ListTile(
          enabled:  preferLocalNetwork,
          title: Text("Home Network Name"), // TODO TRANSLATION
          subtitle: Text("This name will be used to decide if you are in your home network or not."),
          trailing: SizedBox(
            width: 200 * MediaQuery.of(context).textScaleFactor,
            child: TextField(
              enabled: preferLocalNetwork,
              controller: _controller,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                // only save after 500 ms of inactivity
                Future.delayed(Duration(milliseconds: 500), () {
                  if (DateTime.now().millisecondsSinceEpoch - lastSave.millisecondsSinceEpoch > 480 ) {
                    FinampSetters.setHomeNetworkName(value);
                  }
                });

                lastSave = DateTime.now();
              },
            ),
          ),
        );
      }
    );
  }
}
