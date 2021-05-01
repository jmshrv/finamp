import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';
import '../../generateMaterialColor.dart';

class AddDownloadLocationDialog extends StatefulWidget {
  const AddDownloadLocationDialog({Key key}) : super(key: key);

  @override
  _AddDownloadLocationDialogState createState() =>
      _AddDownloadLocationDialogState();
}

class _AddDownloadLocationDialogState extends State<AddDownloadLocationDialog> {
  final _formKey = GlobalKey<FormState>();
  Directory selectedDirectory;
  String name;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Download Location"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormField<Directory>(
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: Material(
                        color: generateMaterialColor(
                                Theme.of(context).dialogBackgroundColor)
                            .shade600,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  selectedDirectory == null
                                      ? "Select Directory"
                                      : selectedDirectory.path.replaceFirst(
                                          selectedDirectory.parent.path + "/",
                                          ""),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: selectedDirectory == null
                                      ? Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                            color: Theme.of(context).hintColor,
                                          )
                                      : Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.folder),
                                  onPressed: () async {
                                    String newPath = await FilePicker.platform
                                        .getDirectoryPath();

                                    print(newPath);

                                    if (newPath != null) {
                                      setState(() {
                                        selectedDirectory = Directory(newPath);
                                      });
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text(
                          field.errorText,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Theme.of(context).errorColor),
                        ),
                      ),
                  ],
                );
              },
              validator: (_) {
                if (selectedDirectory == null) {
                  return "Required";
                }

                if (selectedDirectory.path == "/") {
                  return "Paths that return \"/\" can't be used";
                }

                // This checks if the chosen directory is empty
                if (selectedDirectory
                        .listSync()
                        .where((event) => !event.path
                            .replaceFirst(selectedDirectory.path, "")
                            .contains("."))
                        .length >
                    0) {
                  return "Directory must be empty";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Name (required)"),
              validator: (value) {
                if (value.isEmpty) {
                  return "Required";
                }
                return null;
              },
              onSaved: (newValue) => name = newValue,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              FinampSettings finampSettings =
                  FinampSettingsHelper.finampSettings;
              finampSettings.downloadLocations.add(DownloadLocation(
                name: name,
                path: selectedDirectory.path,
                useHumanReadableNames: true,
                deletable: true,
              ));

              Hive.box<FinampSettings>("FinampSettings")
                  .put("FinampSettings", finampSettings);
              Navigator.of(context).pop();
            }
          },
          child: Text("ADD"),
        )
      ],
    );
  }
}
