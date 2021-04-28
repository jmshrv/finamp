import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../services/DownloadsHelper.dart';
import '../../models/FinampModels.dart';
import '../../models/JellyfinModels.dart';

class DownloadDialog extends StatefulWidget {
  DownloadDialog({Key key, @required this.parent, @required this.items})
      : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> items;

  @override
  _DownloadDialogState createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  DownloadLocation selectedDownloadLocation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Downloads"),
      content: DropdownButton(
        hint: Text("Location"),
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
              : () => downloadsHelper.addDownloads(
                    parent: widget.parent,
                    items: widget.items,
                    downloadBaseDir: Directory(selectedDownloadLocation.path),
                    useHumanReadableNames:
                        selectedDownloadLocation.useHumanReadableNames,
                  ),
        )
      ],
    );
  }
}
