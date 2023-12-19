import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_helper.dart';
import '../../services/isar_downloads.dart';

class AlbumFileSize extends StatelessWidget {
  const AlbumFileSize({Key? key, required this.downloadedParent})
      : super(key: key);

  final DownloadStub downloadedParent;

  @override
  Widget build(BuildContext context) {
    final isarDownloader = GetIt.instance<IsarDownloads>();
    return FutureBuilder(future: isarDownloader.getFileSize(downloadedParent), builder: (context, snapshot) {
      if (snapshot.hasData){
        return Text(FileSize.getSize(snapshot.data));
      }
      return const Text("");
      });
  }
}
