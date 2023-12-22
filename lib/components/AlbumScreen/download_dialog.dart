import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../../services/finamp_settings_helper.dart';
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
  DownloadLocation? selectedDownloadLocation;

  @override
  Widget build(BuildContext context) {
    var scaffold = ScaffoldMessenger.of(context);
    var snackbarText = AppLocalizations.of(context)!.downloadsAdded;
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
                  Navigator.of(context).pop();
                  final isarDownloads = GetIt.instance<IsarDownloads>();
                  await isarDownloads.addDownload(stub: widget.item, downloadLocation: selectedDownloadLocation!).onError((error, stackTrace) => errorSnackbar(error, context));

                  scaffold.showSnackBar(SnackBar(
                    content: Text(snackbarText),
                  ));
                },
          child: Text(AppLocalizations.of(context)!.addButtonLabel),
        )
      ],
    );
  }
}
