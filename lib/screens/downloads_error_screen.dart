import 'package:flutter/material.dart';

import '../components/DownloadsErrorScreen/download_error_list.dart';

class DownloadsErrorScreen extends StatelessWidget {
  const DownloadsErrorScreen({Key? key}) : super(key: key);

  static const routeName = "/downloads/errors";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download Errors"),
      ),
      body: const DownloadErrorList(),
    );
  }
}
