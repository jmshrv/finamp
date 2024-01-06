import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/isar_downloads.dart';

class ItemMediaSourceInfo extends StatelessWidget {
  const ItemMediaSourceInfo({super.key, required this.item});

  final DownloadItem item;

  @override
  Widget build(BuildContext context) {
    if (item.type != DownloadItemType.song) {
      final isarDownloads = GetIt.instance<IsarDownloads>();
      return FutureBuilder(
          future: isarDownloads.getFileSize(item),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Text("??? MB Unknown");
            } else {
              return Text(FileSize.getSize(snapshot.data));
            }
          });
    } else {
      MediaSourceInfo? mediaSourceInfo = item.mediaSourceInfo;

      if (mediaSourceInfo == null) {
        return const Text("??? MB Unknown");
      } else {
        return Text(
            "${FileSize.getSize(mediaSourceInfo.size)} ${mediaSourceInfo.container?.toUpperCase()}");
      }
    }
  }
}
