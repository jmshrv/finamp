import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';

class AlbumFileSize extends StatelessWidget {
  const AlbumFileSize({Key? key, required this.downloadedParent})
      : super(key: key);

  final DownloadedParent downloadedParent;

  @override
  Widget build(BuildContext context) {
    DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    int totalSize = 0;

    for (final item in downloadedParent.downloadedChildren.values) {
      DownloadedSong? downloadedSong =
          downloadsHelper.getDownloadedSong(item.id);

      if (downloadedSong?.mediaSourceInfo.size != null) {
        totalSize += downloadedSong!.mediaSourceInfo.size!;
      }
    }

    return Text(FileSize.getSize(totalSize));
  }
}
