import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class NewAddDownloadLocationDialog extends StatefulWidget {
  NewAddDownloadLocationDialog({Key key}) : super(key: key);

  @override
  _NewAddDownloadLocationDialogState createState() =>
      _NewAddDownloadLocationDialogState();
}

class _NewAddDownloadLocationDialogState
    extends State<NewAddDownloadLocationDialog> {
  final _formKey = GlobalKey<FormState>();
  Directory selectedDirectory;
  String name;
  Future<List<Directory>> externalStorageListFuture;

  @override
  void initState() {
    super.initState();
    externalStorageListFuture = getExternalStorageDirectories();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Download Location"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<List<Directory>>(
              future: externalStorageListFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DropdownMenuItem<Directory>> dropdownButtonItems =
                      snapshot.data
                          .map((e) => DropdownMenuItem(
                                child: Text(
                                  e.path,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                value: e,
                              ))
                          .toList();
                  return DropdownButton(
                    items: dropdownButtonItems,
                    hint: Text("Location"),
                    isExpanded: true,
                    value: selectedDirectory,
                    onChanged: (value) => setState(() {
                      selectedDirectory = value;
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return CircularProgressIndicator();
                }
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
                useHumanReadableNames: false,
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
