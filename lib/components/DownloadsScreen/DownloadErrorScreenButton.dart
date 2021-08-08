import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';

class DownloadErrorScreenButton extends StatefulWidget {
  const DownloadErrorScreenButton({Key? key}) : super(key: key);

  @override
  _DownloadErrorScreenButtonState createState() =>
      _DownloadErrorScreenButtonState();
}

class _DownloadErrorScreenButtonState extends State<DownloadErrorScreenButton> {
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  late Future<List<DownloadTask>?> downloadErrorScreenButtonFuture;

  @override
  void initState() {
    super.initState();
    downloadErrorScreenButtonFuture =
        downloadsHelper.getDownloadsWithStatus(DownloadTaskStatus.failed);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DownloadTask>?>(
      future: downloadErrorScreenButtonFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return generateButton(context: context, iconColor: Colors.red);
          } else {
            return generateButton(context: context);
          }
        } else {
          return generateButton(context: context);
        }
      },
    );
  }

  Widget generateButton({Color? iconColor, required BuildContext context}) {
    return IconButton(
      tooltip: "Open download error screen",
      icon: Icon(
        Icons.error,
        color: iconColor ?? Theme.of(context).iconTheme.color,
      ),
      onPressed: () => Navigator.of(context).pushNamed("/downloads/errors"),
    );
  }
}
