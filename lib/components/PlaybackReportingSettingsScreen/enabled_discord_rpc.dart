import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class EnabledDiscordRpc extends ConsumerWidget {
  const EnabledDiscordRpc({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text("Discord RPC"),
      subtitle: Text(""),
      value: ref.watch(finampSettingsProvider.rpcEnabled),
      onChanged: FinampSetters.setRpcEnabled,
    );
  }
}
