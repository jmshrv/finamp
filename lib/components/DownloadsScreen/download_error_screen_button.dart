import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../screens/active_downloads_screen.dart';
import '../../services/downloads_service.dart';

class DownloadErrorScreenButton extends StatelessWidget {
  const DownloadErrorScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    final downloadsService = GetIt.instance<DownloadsService>();

    return StreamBuilder(
      stream: downloadsService.downloadStatusesStream,
      initialData: downloadsService.downloadStatuses,
      builder: (context, snapshot) {
        final downloadErrorsExist = (snapshot.data?[DownloadItemState.failed] ?? 0) != 0 ||
            (snapshot.data?[DownloadItemState.syncFailed] ?? 0) != 0;
        return IconButton(
          onPressed: () => Navigator.of(context).pushNamed(ActiveDownloadsScreen.routeName),
          icon: Icon(
            downloadErrorsExist ? TablerIcons.alert_circle : TablerIcons.arrows_transfer_down,
            color: downloadErrorsExist ? Theme.of(context).colorScheme.error : null,
          ),
          tooltip: AppLocalizations.of(context)!.activeDownloads,
        );
      },
    );
  }
}
