import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:super_sliver_list/super_sliver_list.dart";
import '../services/finamp_settings_helper.dart';

import "package:super_sliver_list/super_sliver_list.dart";

class AlbumSettingsScreen extends StatefulWidget {
  const AlbumSettingsScreen({super.key});
  static const routeName = "/settings/layout/album";
  @override
  State<AlbumSettingsScreen> createState() => _AlbumSettingsScreenState();
}

class _AlbumSettingsScreenState extends State<AlbumSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.albumScreen),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
            context,
            FinampSettingsHelper.resetAlbumSettings,
          ),
        ],
      ),
      body: SuperListView(children: const [ShowCoversOnAlbumScreenToggle()]),
    );
  }
}

class ShowCoversOnAlbumScreenToggle extends ConsumerWidget {
  const ShowCoversOnAlbumScreenToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.showCoversOnAlbumScreenTitle),
      subtitle: Text(
        AppLocalizations.of(context)!.showCoversOnAlbumScreenSubtitle,
      ),
      value: ref.watch(finampSettingsProvider.showCoversOnAlbumScreen),
      onChanged: FinampSetters.setShowCoversOnAlbumScreen,
    );
  }
}
