import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/auto_offline.dart';
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
      builder: (context, box, __) {
        return ListTile(
          enabled:  preferLocalNetwork,
          title: Text(AppLocalizations.of(context)!.preferHomeNetworkSettingNetworkNameTitle), // TODO TRANSLATION
          subtitle: Text(AppLocalizations.of(context)!.preferHomeNetworkSettingNetworkNameDescription),
          trailing: SizedBox(
            width: 200 * MediaQuery.of(context).textScaleFactor,
            child: TextField(
              enabled: preferLocalNetwork,
              controller: _controller,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                // only save after 500 ms of inactivity
                Future.delayed(Duration(milliseconds: 500), () async {
                  if (DateTime.now().millisecondsSinceEpoch - lastSave.millisecondsSinceEpoch > 480 ) {
                    FinampSetters.setHomeNetworkName(value);
                    await changeTargetUrl();
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
