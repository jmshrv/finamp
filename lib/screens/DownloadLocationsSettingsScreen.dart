import 'package:flutter/material.dart';

import '../components/DownloadLocationSettingsScreen/DownloadLocationList.dart';
import '../components/DownloadLocationSettingsScreen/AddDownloadLocationDialog.dart';
import '../components/DownloadLocationSettingsScreen/NewAddDownloadLocationDialog.dart';

class DownloadsSettingsScreen extends StatelessWidget {
  const DownloadsSettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download Locations"),
        actions: [
          IconButton(
            icon: Icon(Icons.sd_storage),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => NewAddDownloadLocationDialog(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddDownloadLocationDialog(),
        ),
      ),
      body: DownloadLocationList(),
    );
  }
}
