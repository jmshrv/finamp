import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class EnabledDiscordRpc extends ConsumerWidget {
  const EnabledDiscordRpc({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text("Discord RPC"),
      subtitle: Text(
        "Enable Discord Rich Presence to show what you are playing in your discord status. Wont connect to discord if Offline Mode is enabled. May consume more resources than you expect.",
      ),
      value: ref.watch(finampSettingsProvider.rpcEnabled),
      onChanged: FinampSetters.setRpcEnabled,
    );
  }
}
