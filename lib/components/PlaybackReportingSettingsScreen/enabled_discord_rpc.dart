import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class EnabledDiscordRpc extends ConsumerWidget {
  const EnabledDiscordRpc({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.discordRPCSettingTitle),
      subtitle: Text(AppLocalizations.of(context)!.discordRPCSettingDescription),
      value: ref.watch(finampSettingsProvider.rpcEnabled),
      onChanged: FinampSetters.setRpcEnabled,
    );
  }
}
