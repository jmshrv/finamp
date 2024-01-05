import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';
import 'downloads_location_screen.dart';

class DownloadsSettingsScreen extends StatelessWidget {
  const DownloadsSettingsScreen({super.key});

  static const routeName = "/settings/downloads";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.downloadSettings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.folder),
            title: Text(AppLocalizations.of(context)!.downloadLocations),
            onTap: () => Navigator.of(context)
                .pushNamed(DownloadsLocationScreen.routeName),
          ),
          const RequireWifiSwitch(),
          const ShowPlaylistSongsSwitch(),
          const ConcurentDownloadsSelector(),
        ],
      ),
    );
  }
}

class RequireWifiSwitch extends StatelessWidget {
  const RequireWifiSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? requireWifi = box.get("FinampSettings")?.requireWifiForDownloads;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.requireWifiForDownloads),
          value: requireWifi ?? false,
          onChanged: requireWifi == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.requireWifiForDownloads = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class ShowPlaylistSongsSwitch extends StatelessWidget {
  const ShowPlaylistSongsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? showUnknownItems =
            box.get("FinampSettings")?.showDownloadsWithUnknownLibrary;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.showPlaylistSongs),
          subtitle:
              Text(AppLocalizations.of(context)!.showPlaylistSongsSubtitle),
          value: showUnknownItems ?? true,
          onChanged: showUnknownItems == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.showDownloadsWithUnknownLibrary = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class ConcurentDownloadsSelector extends StatelessWidget {
  const ConcurentDownloadsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.maxConcurrentDownloads),
          subtitle: Text(
              AppLocalizations.of(context)!.maxConcurrentDownloadsSubtitle),
        ),
        ValueListenableBuilder<Box<FinampSettings>>(
          valueListenable: FinampSettingsHelper.finampSettingsListener,
          builder: (context, box, child) {
            final finampSettings = box.get("FinampSettings")!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  min: 3,
                  max: 200,
                  value: finampSettings.maxConcurrentDownloads.toDouble(),
                  label: AppLocalizations.of(context)!
                      .maxConcurrentDownloadsLabel(
                          finampSettings.maxConcurrentDownloads.toString()),
                  onChanged: (value) {
                    FinampSettings finampSettingsTemp =
                        box.get("FinampSettings")!;
                    finampSettingsTemp.maxConcurrentDownloads = value.toInt();
                    box.put("FinampSettings", finampSettingsTemp);
                  },
                ),
                Text(
                  AppLocalizations.of(context)!.maxConcurrentDownloadsLabel(
                      finampSettings.maxConcurrentDownloads.toString()),
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
