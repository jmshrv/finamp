import 'package:flutter/material.dart';

import '../components/DownloadsScreen/DownloadsOverview.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloads"),
      ),
      body: ListView(
        children: [
          DownloadsOverview(),
        ],
      ),
    );
  }
}
