import 'package:flutter/material.dart';

import '../components/DownloadLocationSettingsScreen/DownloadLocationList.dart';

class DownloadsSettingsScreen extends StatelessWidget {
  const DownloadsSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download Locations"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed("/settings/downloadlocations/add"),
      ),
      body: const DownloadLocationList(),
    );
  }
}
