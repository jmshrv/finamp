import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';

class AlbumFileSize extends StatelessWidget {
  const AlbumFileSize({Key key, @required this.downloadedAlbum})
      : super(key: key);

  final DownloadedAlbum downloadedAlbum;

  @override
  Widget build(BuildContext context) {
    DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    int totalSize = 0;

    for (final item in downloadedAlbum.downloadedChildren.values) {
      DownloadedSong downloadedSong =
          downloadsHelper.getDownloadedSong(item.id);

      if (downloadedSong != null) {
        totalSize += downloadedSong.mediaSourceInfo.size;
      }
    }

    return Container(
      child: Text(FileSize().getSize(totalSize)),
    );
  }
}
