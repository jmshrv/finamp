import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/DownloadsErrorScreen/download_error_list.dart';

class DownloadsErrorScreen extends StatelessWidget {
  DownloadsErrorScreen({Key? key}) : super(key: key);

  static const routeName = "/downloads/errors";

  final DownloadErrorController downloadErrorController =
      DownloadErrorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.downloadErrorsTitle),
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  downloadErrorController.redownloadFailed();
                })
          ]),
      body: DownloadErrorList(downloadErrorController: downloadErrorController),
    );
  }
}
