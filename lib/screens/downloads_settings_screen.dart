import 'package:flutter/material.dart';

import 'add_download_location_screen.dart';
import '../components/DownloadLocationSettingsScreen/download_location_list.dart';

class DownloadsSettingsScreen extends StatelessWidget {
  const DownloadsSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/downloadlocations";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download Locations"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .pushNamed(AddDownloadLocationScreen.routeName),
      ),
      body: const DownloadLocationList(),
    );
  }
}
