import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class AddDownloadLocationDialog extends StatefulWidget {
  const AddDownloadLocationDialog({Key key}) : super(key: key);

  @override
  _AddDownloadLocationDialogState createState() =>
      _AddDownloadLocationDialogState();
}

class _AddDownloadLocationDialogState extends State<AddDownloadLocationDialog> {
  Directory selectedDirectory;
  bool useHumanReadableNames = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Download Location"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedDirectory == null
                      ? "Select Directory"
                      : selectedDirectory.path,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.folder),
                  onPressed: () async {
                    String newPath =
                        await FilePicker.platform.getDirectoryPath();
                    if (newPath != null) {
                      setState(() {
                        selectedDirectory = Directory(newPath);
                      });
                    }
                  }),
            ],
          ),
          SwitchListTile(
            title: Text("Human readable file names"),
            subtitle: Text("If true, use song names instead of IDs for files"),
            value: useHumanReadableNames,
            onChanged: (value) => setState(() {
              useHumanReadableNames = value;
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            FinampSettings finampSettings = FinampSettingsHelper.finampSettings;
            finampSettings.downloadLocations.add(DownloadLocation(
              name: "Test",
              path: selectedDirectory.path,
              useHumanReadableNames: useHumanReadableNames,
              deletable: true,
            ));

            Hive.box<FinampSettings>("FinampSettings")
                .put("FinampSettings", finampSettings);
            Navigator.of(context).pop();
          },
          child: Text("ADD"),
        )
      ],
    );
  }
}
