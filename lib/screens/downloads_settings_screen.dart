import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/SettingsScreen/download_settings_switches.dart';
import 'add_download_location_screen.dart';
import '../components/DownloadLocationSettingsScreen/download_location_list.dart';

class DownloadsSettingsScreen extends StatelessWidget {
  const DownloadsSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/downloadlocations";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.downloadLocations),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .pushNamed(AddDownloadLocationScreen.routeName),
      ),
      body: ListView(
          children: const [DownloadSettingsSwitches(), DownloadLocationList()]),
    );
  }
}
