import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/auto_offline.dart';
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

    DateTime lastSave = DateTime.now();
    
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return ListTile(
          title: Text(AppLocalizations.of(context)!.preferHomeNetworkPublicAddressSettingTitle),
          subtitle: Text(AppLocalizations.of(context)!.preferHomeNetworkPublicAddressSettingDescription),
          trailing: SizedBox(
            width: 200 * MediaQuery.of(context).textScaleFactor,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.url,
              onChanged: (value) {
                Future.delayed(Duration(milliseconds: 500), () async {
                    if (DateTime.now().millisecondsSinceEpoch - lastSave.millisecondsSinceEpoch > 480 ) {
                      FinampSetters.setPublicAddress(value);
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
