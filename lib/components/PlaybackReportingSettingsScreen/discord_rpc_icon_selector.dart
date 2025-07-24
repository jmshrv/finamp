import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';


class DiscordRpcIconSelector extends ConsumerWidget {
  const DiscordRpcIconSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DiscordRpcIcon option = ref.watch(finampSettingsProvider.rpcIcon);

    return ListTile(
      title: Text(AppLocalizations.of(context)!.discordRPCIconSettingTitle),
      subtitle: Text(AppLocalizations.of(context)!.discordRPCIconSettingDescription),
      trailing: DropdownButton<DiscordRpcIcon>(
        value: option,
        items: DiscordRpcIcon.values
            .map((e) => DropdownMenuItem<DiscordRpcIcon>(value: e, child: Text(e.toLocalisedString(context)) ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            FinampSetters.setRpcIcon(value);
          }
        },
      ),
    );
  }
}
