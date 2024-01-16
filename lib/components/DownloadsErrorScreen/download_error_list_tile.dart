import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/finamp_models.dart';
import '../../services/process_artist.dart';
import '../album_image.dart';

class DownloadErrorListTile extends StatelessWidget {
  const DownloadErrorListTile(
      {super.key, required this.downloadTask, required this.showType});

  final DownloadStub downloadTask;
  final bool showType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AlbumImage(item: downloadTask.baseItem),
      title: Text(downloadTask.name),
      subtitle: Text(showType
          ? AppLocalizations.of(context)!
              .itemTypeSubtitle(downloadTask.baseItemType.name)
          : processArtist(downloadTask.baseItem?.albumArtist, context)),
      // trailing: IconButton(
      //   icon: Icon(Icons.refresh),
      //   onPressed: () {},
      //   tooltip: "Retry",
      // ),
    );
  }
}
