import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';
import '../../models/JellyfinModels.dart';
import '../AlbumImage.dart';

class DownloadErrorListTile extends StatelessWidget {
  const DownloadErrorListTile({Key key, @required this.downloadTask})
      : super(key: key);

  final DownloadTask downloadTask;

  @override
  Widget build(BuildContext context) {
    DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    DownloadedSong downloadedSong =
        downloadsHelper.getJellyfinItemFromDownloadId(downloadTask.taskId);

    return ListTile(
      leading: AlbumImage(itemId: downloadedSong.song.parentId),
      title: Text(downloadedSong != null ? downloadedSong.song.name : "???"),
      subtitle: Text(
          downloadedSong != null ? downloadedSong.song.albumArtist : "???"),
      trailing: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {},
        tooltip: "Retry",
      ),
    );
  }
}
