import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';

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
              context, FinampSettingsHelper.resetAlbumSettings)
        ],
      ),
      body: ListView(
        children: const [
          ShowCoversOnAlbumScreenToggle(),
        ],
      ),
    );
  }
}

class ShowCoversOnAlbumScreenToggle extends StatelessWidget {
  const ShowCoversOnAlbumScreenToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? showCoversOnAlbumScreen =
            box.get("FinampSettings")?.showCoversOnAlbumScreen;

        return SwitchListTile.adaptive(
          title:
              Text(AppLocalizations.of(context)!.showCoversOnAlbumScreenTitle),
          subtitle: Text(
              AppLocalizations.of(context)!.showCoversOnAlbumScreenSubtitle),
          value: showCoversOnAlbumScreen ?? false,
          onChanged: showCoversOnAlbumScreen == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.showCoversOnAlbumScreen = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
