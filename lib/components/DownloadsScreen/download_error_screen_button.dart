import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../screens/downloads_error_screen.dart';
import '../../services/downloads_helper.dart';

class DownloadErrorScreenButton extends StatefulWidget {
  const DownloadErrorScreenButton({Key? key}) : super(key: key);

  @override
  State<DownloadErrorScreenButton> createState() =>
      _DownloadErrorScreenButtonState();
}

class _DownloadErrorScreenButtonState extends State<DownloadErrorScreenButton> {
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  late Future<List<DownloadTask>?> downloadErrorScreenButtonFuture;

  @override
  void initState() {
    super.initState();
    downloadErrorScreenButtonFuture =
        _downloadsHelper.getDownloadsWithStatus(DownloadTaskStatus.failed);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DownloadTask>?>(
      future: downloadErrorScreenButtonFuture,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(DownloadsErrorScreen.routeName),
          icon: Icon(
            Icons.error,
            color: snapshot.data?.isNotEmpty ?? false
                ? Theme.of(context).colorScheme.error
                : null,
          ),
          tooltip: AppLocalizations.of(context)!.downloadErrors,
        );
      },
    );
  }
}