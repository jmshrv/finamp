import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PluginSettingsScreen extends StatefulWidget {
  const PluginSettingsScreen({super.key});
  static const routeName = "/settings/plugins";
  @override
  State<PluginSettingsScreen> createState() => _PluginSettingsScreenState();
}

class _PluginSettingsScreenState extends State<PluginSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pluginSettingsTitle),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(context, () {
            setState(() {
              FinampSettingsHelper.resetPluginSettings();
            });
          }),
        ],
      ),
      body: ListView(
        children: [
          const UseAudioMuseMixesSwitch(),
        ],
      ),
    );
  }
}

class UseAudioMuseMixesSwitch extends ConsumerWidget {
  const UseAudioMuseMixesSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.useAudioMuseMixesSwitchTitle),
      subtitle: Text(AppLocalizations.of(context)!.useAudioMuseMixesSwitchSubtitle),
      value: ref.watch(finampSettingsProvider.useAudioMuseMixes),
      onChanged: FinampSetters.setUseAudioMuseMixes,
    );
  }
}
