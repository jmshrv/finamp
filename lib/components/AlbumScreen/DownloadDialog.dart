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
  DownloadDialog({
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

  final _downloadDialogLogger = Logger("DownloadDialog");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Downloads"),
      content: DropdownButton<DownloadLocation>(
        hint: Text("Location"),
        isExpanded: true,
        onChanged: (value) => setState(() {
          selectedDownloadLocation = value;
        }),
        value: selectedDownloadLocation,
        items: FinampSettingsHelper.finampSettings.downloadLocations
            .map((e) => DropdownMenuItem<DownloadLocation>(
                  child: Text(e.name),
                  value: e,
                ))
            .toList(),
      ),
      actions: [
        TextButton(
          child: Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text("ADD"),
          onPressed: selectedDownloadLocation == null
              ? null
              : () async {
                  // If the default "internal storage" path is set and doesn't
                  // exist, it may have been moved by an iOS update.
                  if (selectedDownloadLocation!.useHumanReadableNames ==
                          false &&
                      !await Directory(selectedDownloadLocation!.path)
                          .exists()) {
                    _downloadDialogLogger.warning(
                        "Internal storage path doesn't exist! Resetting.");
                    await FinampSettingsHelper.resetDefaultDownloadLocation();
                  }
                  for (int i = 0; i < widget.parents.length; i++) {
                    downloadsHelper
                        .addDownloads(
                          parent: widget.parents[i],
                          items: widget.items[i],
                          downloadBaseDir:
                              Directory(selectedDownloadLocation!.path),
                          useHumanReadableNames:
                              selectedDownloadLocation!.useHumanReadableNames,
                          viewId: widget.viewId,
                        )
                        .onError((error, stackTrace) =>
                            errorSnackbar(error, context));
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Downloads added.")));
                  Navigator.of(context).pop();
                },
        )
      ],
    );
  }
}
