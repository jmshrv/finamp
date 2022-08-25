import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/finamp_settings_helper.dart';
import 'transcoding_settings_screen.dart';
import 'downloads_settings_screen.dart';
import 'audio_service_settings_screen.dart';
import 'layout_settings_screen.dart';
import '../components/SettingsScreen/logout_list_tile.dart';
import 'view_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () async {
              final applicationLegalese =
                  AppLocalizations.of(context)!.applicationLegalese;
              PackageInfo packageInfo = await PackageInfo.fromPlatform();

              showAboutDialog(
                context: context,
                applicationName: packageInfo.appName,
                applicationVersion: packageInfo.version,
                applicationLegalese: applicationLegalese,
              );
            },
          )
        ],
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.compress),
              title: Text(AppLocalizations.of(context)!.transcoding),
              onTap: () => Navigator.of(context)
                  .pushNamed(TranscodingSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: Text(AppLocalizations.of(context)!.downloadLocations),
              onTap: () => Navigator.of(context)
                  .pushNamed(DownloadsSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: Text(AppLocalizations.of(context)!.audioService),
              onTap: () => Navigator.of(context)
                  .pushNamed(AudioServiceSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: Text(AppLocalizations.of(context)!.layoutAndTheme),
              onTap: () => Navigator.of(context)
                  .pushNamed(LayoutSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.library_music),
              title: Text(AppLocalizations.of(context)!.selectMusicLibraries),
              subtitle: FinampSettingsHelper.finampSettings.isOffline
                  ? Text(
                      AppLocalizations.of(context)!.notAvailableInOfflineMode)
                  : null,
              enabled: !FinampSettingsHelper.finampSettings.isOffline,
              onTap: () =>
                  Navigator.of(context).pushNamed(ViewSelector.routeName),
            ),
            const LogoutListTile(),
          ],
        ),
      ),
    );
  }
}
