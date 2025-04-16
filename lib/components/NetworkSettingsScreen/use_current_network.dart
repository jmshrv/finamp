import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../../services/finamp_settings_helper.dart';

class UseCurrentNetworkButton extends ConsumerWidget {
  const UseCurrentNetworkButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(onPressed: () async {
      String? network = await NetworkInfo().getWifiName();
      if (network == null) return;
      FinampSetters.setHomeNetworkName(network);
    },
    child: Text("Use current network name"));
  }
}
