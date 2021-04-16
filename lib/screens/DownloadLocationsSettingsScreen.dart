import 'package:flutter/material.dart';

import '../components/DownloadLocationSettingsScreen/DownloadLocationList.dart';

class DownloadsSettingsScreen extends StatelessWidget {
  const DownloadsSettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download Locations"),
      ),
      body: DownloadLocationList(),
    );
  }
}
