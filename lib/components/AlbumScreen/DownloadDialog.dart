import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../services/DownloadsHelper.dart';
import '../../models/FinampModels.dart';
import '../../models/JellyfinModels.dart';
import '../errorSnackbar.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({
    Key? key,
    required this.parents,
    required this.items,
    required this.viewId,
  })  : assert(parents.length == items.length),
        super(key: key);

  final List<BaseItemDto> parents;
  final List<List<BaseItemDto>> items;
  final String viewId;

  @override
  _DownloadDialogState createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  DownloadLocation? selectedDownloadLocation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Downloads"),
      content: DropdownButton<DownloadLocation>(
          hint: const Text("Location"),
          isExpanded: true,
          onChanged: (value) => setState(() {
                selectedDownloadLocation = value;
              }),
          value: selectedDownloadLocation,
          items: FinampSettingsHelper.finampSettings.downloadLocationsMap.values
              .map((e) => DropdownMenuItem<DownloadLocation>(
                    child: Text(e.name),
                    value: e,
                  ))
              .toList()),
      actions: [
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("ADD"),
          onPressed: selectedDownloadLocation == null
              ? null
              : () async {
                  await checkedAddDownloads(
                    context,
                    downloadLocation: selectedDownloadLocation!,
                    parents: widget.parents,
                    items: widget.items,
                    viewId: widget.viewId,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Downloads added.")));
                  Navigator.of(context).pop();
                },
        )
      ],
    );
  }
}

/// This function is used by DownloadDialog to check/add downloads.
Future<void> checkedAddDownloads(
  BuildContext context, {
  required DownloadLocation downloadLocation,
  required List<BaseItemDto> parents,
  required List<List<BaseItemDto>> items,
  required String viewId,
}) async {
  final downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _checkedAddDownloadsLogger = Logger("CheckedAddDownloads");

  // If the default "internal storage" path is set and doesn't
  // exist, it may have been moved by an iOS update.
  if (downloadLocation.useHumanReadableNames == false &&
      !await Directory(downloadLocation.path).exists()) {
    _checkedAddDownloadsLogger
        .warning("Internal storage path doesn't exist! Resetting.");
    await FinampSettingsHelper.resetDefaultDownloadLocation();
  }

  for (int i = 0; i < parents.length; i++) {
    downloadsHelper
        .addDownloads(
          parent: parents[i],
          items: items[i],
          useHumanReadableNames: downloadLocation.useHumanReadableNames,
          viewId: viewId,
          downloadLocation: downloadLocation,
        )
        .onError((error, stackTrace) => errorSnackbar(error, context));
  }

  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Downloads added.")));
}
