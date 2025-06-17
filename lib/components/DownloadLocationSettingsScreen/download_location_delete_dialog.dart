import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';

class DownloadLocationDeleteDialog extends StatelessWidget {
  const DownloadLocationDeleteDialog({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    var downloads = GetIt.instance<DownloadsService>().getDownloadsForLocation(id, false);
    if (downloads.isEmpty) {
      return AlertDialog(
        title: const Text("Are you sure?"),
        content: Text("No downloads are currently present in this location."),
        actions: [
          TextButton(
            child: const Text("CANCEL"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("DELETE"),
            onPressed: () {
              var fileDownloads = GetIt.instance<DownloadsService>().getDownloadsForLocation(id, true);
              if (fileDownloads.isNotEmpty) {
                Navigator.of(context).pop();
                GlobalSnackbar.message((_) =>
                    "Could not delete download location - unexpected downloads found in location.  Try running a downloads repair.");
              } else {
                FinampSettingsHelper.deleteDownloadLocation(id);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    } else {
      return AlertDialog(
          title: const Text("Cannot delete location"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text(
                "This location currently contains downloads and cannot be deleted.  Remove these downloads first:"),
            ...downloads
                .map((stub) => Text(AppLocalizations.of(context)!.itemTypeSubtitle(stub.baseItemType.name, stub.name)))
          ]));
    }
  }
}
