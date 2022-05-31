import 'package:flutter/material.dart';

import 'AddDownloadLocationScreen.dart';
import '../components/DownloadLocationSettingsScreen/DownloadLocationList.dart';

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
