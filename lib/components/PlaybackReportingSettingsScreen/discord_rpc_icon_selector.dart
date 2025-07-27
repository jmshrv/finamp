import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            .map(
              (e) => DropdownMenuItem<DiscordRpcIcon>(
                value: e,
                child: Row(
                  children: [
                    Image.asset(e.toImage(), width: 32, height: 32),
                    const SizedBox(width: 12),
                    Text(e.toLocalisedString(context)),
                  ],
                ),
              ),
            )
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
