import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/network_manager.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class LocalNetworkAddressSelector extends ConsumerStatefulWidget {
  const LocalNetworkAddressSelector({super.key});

  @override
  ConsumerState<LocalNetworkAddressSelector> createState() => _LocalNetworkAddressSelector();
}

class _LocalNetworkAddressSelector extends ConsumerState<LocalNetworkAddressSelector> {
  TextEditingController? _controller;
  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FinampUser? user = ref.watch(FinampUserHelper.finampCurrentUserProvider).valueOrNull;
    String address = user?.localAddress ?? DefaultSettings.localNetworkAddress;
    bool featureEnabled = user?.preferLocalNetwork ?? DefaultSettings.preferLocalNetwork;

    _controller ??= TextEditingController(text: address);

    return ListTile(
      enabled: featureEnabled,
      title: Text(AppLocalizations.of(context)!.preferLocalNetworkTargetAddressLocalSettingTitle),
      subtitle: Text(AppLocalizations.of(context)!.preferLocalNetworkTargetAddressLocalSettingDescription),
      trailing: SizedBox(
        width: 200 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          enabled: featureEnabled,
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.url,
          onSubmitted: (value) async {
            if (!value.startsWith("http")) {
              return GlobalSnackbar.message((context) => AppLocalizations.of(context)!.missingSchemaError);
            }
            GetIt.instance<FinampUserHelper>().currentUser?.update(newLocalAddress: value);
            await changeTargetUrl();
          },
        ),
      ),
    );
  }
}
