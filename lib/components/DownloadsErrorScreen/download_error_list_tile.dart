import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';
import '../../services/process_artist.dart';
import '../album_image.dart';

class DownloadErrorListTile extends StatelessWidget {
  const DownloadErrorListTile({Key? key, required this.downloadTask})
      : super(key: key);

  final DownloadItem downloadTask;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AlbumImage(item: downloadTask.baseItem),
      title: Text(downloadTask.name == null
          ? AppLocalizations.of(context)!.unknownName
          : downloadTask.name!),
      subtitle: Text(processArtist(downloadTask.baseItem?.albumArtist, context)),
      // trailing: IconButton(
      //   icon: Icon(Icons.refresh),
      //   onPressed: () {},
      //   tooltip: "Retry",
      // ),
    );
  }
}
