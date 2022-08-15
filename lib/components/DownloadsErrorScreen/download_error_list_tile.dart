import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/downloads_helper.dart';
import '../../services/process_artist.dart';
import '../album_image.dart';

class DownloadErrorListTile extends StatelessWidget {
  const DownloadErrorListTile({Key? key, required this.downloadTask})
      : super(key: key);

  final DownloadTask downloadTask;

  @override
  Widget build(BuildContext context) {
    DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    DownloadedSong? downloadedSong =
        downloadsHelper.getJellyfinItemFromDownloadId(downloadTask.taskId);

    if (downloadedSong == null) {
      return ListTile(
        title: Text(downloadTask.taskId),
        subtitle:
            Text(AppLocalizations.of(context)!.failedToGetSongFromDownloadId),
      );
    }

    return ListTile(
      leading: AlbumImage(item: downloadedSong.song),
      title: Text(downloadedSong.song.name == null
          ? AppLocalizations.of(context)!.unknownName
          : downloadedSong.song.name!),
      subtitle: Text(processArtist(downloadedSong.song.albumArtist)),
      // trailing: IconButton(
      //   icon: Icon(Icons.refresh),
      //   onPressed: () {},
      //   tooltip: "Retry",
      // ),
    );
  }
}
