import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../../services/finamp_settings_helper.dart';
import '../../services/downloads_helper.dart';
import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/isar_downloads.dart';
import '../error_snackbar.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({
    Key? key,
    required this.item,
  })  : super(key: key);

  final DownloadStub item;

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  DownloadLocation? selectedDownloadLocation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.addDownloads),
      content: DropdownButton<DownloadLocation>(
          hint: Text(AppLocalizations.of(context)!.location),
          isExpanded: true,
          onChanged: (value) => setState(() {
                selectedDownloadLocation = value;
              }),
          value: selectedDownloadLocation,
          items: FinampSettingsHelper.finampSettings.downloadLocationsMap.values
              .map((e) => DropdownMenuItem<DownloadLocation>(
                    value: e,
                    child: Text(e.name),
                  ))
              .toList()),
      actions: [
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: selectedDownloadLocation == null
              ? null
              : () async {
                  await checkedAddDownloads(
                    context,
                    downloadLocation: selectedDownloadLocation!,
                    item: widget.item,
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)!.downloadsAdded),
                  ));
                  Navigator.of(context).pop();
                },
          child: Text(AppLocalizations.of(context)!.addButtonLabel),
        )
      ],
    );
  }
}

/// This function is used by DownloadDialog to check/add downloads.
Future<void> checkedAddDownloads(
  BuildContext context, {
  required DownloadLocation downloadLocation,
  required DownloadStub item,
}) async {
  final isarDownloads = GetIt.instance<IsarDownloads>();
  final checkedAddDownloadsLogger = Logger("CheckedAddDownloads");

  // If the default "internal storage" path is set and doesn't
  // exist, it may have been moved by an iOS update.
  if (downloadLocation.useHumanReadableNames == false &&
      !await Directory(downloadLocation.path).exists()) {
    checkedAddDownloadsLogger
        .warning("Internal storage path doesn't exist! Resetting.");
    await FinampSettingsHelper.resetDefaultDownloadLocation();
  }

  await isarDownloads.addDownload(stub: item, downloadLocation: downloadLocation).onError((error, stackTrace) => errorSnackbar(error, context));
}
