import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/network_manager.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../services/finamp_settings_helper.dart';

class HomeNetworkAddressSelector extends ConsumerStatefulWidget {
  const HomeNetworkAddressSelector({super.key});
  
  @override
  ConsumerState<HomeNetworkAddressSelector> createState() => _HomeNetworkAddressSelector();
}

class _HomeNetworkAddressSelector extends ConsumerState<HomeNetworkAddressSelector> {

  TextEditingController? _controller;
  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FinampUser? user = ref.watch(FinampUserHelper.finampCurrentUserProvider).valueOrNull;
    String address = user?.homeAddress ?? DefaultSettings.homeNetworkAddress;
    bool featureEnabled = user?.preferHomeNetwork ?? DefaultSettings.preferHomeNetwork;

    _controller = TextEditingController(
      text: address);

    return ListTile(
      enabled: featureEnabled,
      title: Text(AppLocalizations.of(context)!.preferHomeNetworkTargetAddressLocalSettingTitle),
      subtitle: Text(AppLocalizations.of(context)!.preferHomeNetworkTargetAddressLocalSettingDescription),
      trailing: SizedBox(
        width: 200 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          enabled: featureEnabled,
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.url,
          onSubmitted: (value) async {
            if (!value.startsWith("http")) return GlobalSnackbar.message((context) => AppLocalizations.of(context)!.urlDoesntStartWithHttp);
            GetIt.instance<FinampUserHelper>().currentUser?.update(newHomeAddress: value);
            await changeTargetUrl();
          },
        ),
      ),
    );
  }
}
