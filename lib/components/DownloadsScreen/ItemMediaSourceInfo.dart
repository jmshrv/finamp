import 'package:flutter/material.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';
import '../../models/JellyfinModels.dart';

class ItemMediaSourceInfo extends StatelessWidget {
  const ItemMediaSourceInfo({Key? key, required this.songId}) : super(key: key);

  final String songId;

  @override
  Widget build(BuildContext context) {
    DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    MediaSourceInfo? mediaSourceInfo =
        downloadsHelper.getDownloadedSong(songId)?.mediaSourceInfo;

    if (mediaSourceInfo == null) {
      return const Text("??? MB Unknown");
    } else {
      return Text(
          "${FileSize.getSize(mediaSourceInfo.size)} ${mediaSourceInfo.container?.toUpperCase()}");
    }
  }
}
