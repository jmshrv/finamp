import 'package:flutter/material.dart';

import '../components/DownloadLocationSettingsScreen/DownloadLocationList.dart';

class DownloadsSettingsScreen extends StatelessWidget {
  const DownloadsSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download Locations"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed("/settings/downloadlocations/add"),
      ),
      body: DownloadLocationList(),
    );
  }
}
