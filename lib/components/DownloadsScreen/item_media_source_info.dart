import 'package:flutter/material.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_helper.dart';
import '../../models/jellyfin_models.dart';
import '../../services/isar_downloads.dart';

class ItemMediaSourceInfo extends StatelessWidget {
  const ItemMediaSourceInfo({Key? key, required this.item}) : super(key: key);

  final DownloadItem item;

  @override
  Widget build(BuildContext context) {
    MediaSourceInfo? mediaSourceInfo = item?.mediaSourceInfo;

    if (mediaSourceInfo == null) {
      return const Text("??? MB Unknown");
    } else {
      return Text(
          "${FileSize.getSize(mediaSourceInfo.size)} ${mediaSourceInfo.container?.toUpperCase()}");
    }
  }
}
