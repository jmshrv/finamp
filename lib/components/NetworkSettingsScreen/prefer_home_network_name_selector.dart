import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/auto_offline.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../services/finamp_settings_helper.dart';

class HomeNetworkNameSelector extends ConsumerStatefulWidget {
  const HomeNetworkNameSelector({super.key});

  @override
  ConsumerState<HomeNetworkNameSelector> createState() => _HomeNetworkNameSelector();
}

class _HomeNetworkNameSelector extends ConsumerState<HomeNetworkNameSelector> {
  TextEditingController? _controller; 

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FinampUser? user = ref.watch(FinampUserHelper.finampCurrentUserProvider).valueOrNull;
    String networkName = user?.homeNetworkName ?? DefaultSettings.homeNetworkName;
    bool featureEnabled = user?.preferHomeNetwork ?? DefaultSettings.preferHomeNetwork;

    _controller = TextEditingController(
        text: networkName.toString());

    return ListTile(
      enabled:  featureEnabled,
      title: Text(AppLocalizations.of(context)!.preferHomeNetworkSettingNetworkNameTitle),
      subtitle: Text(AppLocalizations.of(context)!.preferHomeNetworkSettingNetworkNameDescription),
      trailing: SizedBox(
        width: 200 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          enabled: featureEnabled,
          controller: _controller,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.text,
          onSubmitted: (value) async {
            GetIt.instance<FinampUserHelper>().currentUser?.update(newHomeNetworkName: value);
            await changeTargetUrl();
          },
        ),
      ),
    );
  }
}
