import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/finamp_settings_helper.dart';
import 'transcoding_settings_screen.dart';
import 'downloads_settings_screen.dart';
import 'audio_service_settings_screen.dart';
import 'layout_settings_screen.dart';
import '../components/SettingsScreen/logout_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();

              showAboutDialog(
                context: context,
                applicationName: packageInfo.appName,
                applicationVersion: packageInfo.version,
                applicationLegalese:
                    "Licensed with the Mozilla Public License 2.0. Source code available at:\n\ngithub.com/UnicornsOnLSD/finamp",
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
              title: const Text("Transcoding"),
              onTap: () => Navigator.of(context)
                  .pushNamed(TranscodingSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Download Locations"),
              onTap: () => Navigator.of(context)
                  .pushNamed(DownloadsSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text("Audio Service"),
              onTap: () => Navigator.of(context)
                  .pushNamed(AudioServiceSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text("Layout & Theme"),
              onTap: () => Navigator.of(context)
                  .pushNamed(LayoutSettingsScreen.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.library_music),
              title: const Text("Select Music Libraries"),
              subtitle: FinampSettingsHelper.finampSettings.isOffline
                  ? const Text("Not available in offline mode")
                  : null,
              enabled: !FinampSettingsHelper.finampSettings.isOffline,
              onTap: () => Navigator.of(context).pushNamed("/settings/views"),
            ),
            const LogoutListTile(),
          ],
        ),
      ),
    );
  }
}
