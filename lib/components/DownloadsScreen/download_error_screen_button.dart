import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../screens/downloads_error_screen.dart';
import '../../services/isar_downloads.dart';

class DownloadErrorScreenButton extends StatelessWidget {
  const DownloadErrorScreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isarDownloads = GetIt.instance<IsarDownloads>();

    return StreamBuilder(
      stream: isarDownloads.downloadStatusesStream,
      initialData: isarDownloads.downloadStatuses,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(DownloadsErrorScreen.routeName),
          icon: Icon(
            Icons.error,
            color: (snapshot.data?[DownloadItemState.failed]??0)==0
                ? Theme.of(context).colorScheme.error
                : null,
          ),
          tooltip: AppLocalizations.of(context)!.downloadErrors,
        );
      },
    );
  }
}