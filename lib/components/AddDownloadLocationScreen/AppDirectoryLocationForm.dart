import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class AppDirectoryLocationForm extends StatefulWidget {
  AppDirectoryLocationForm({Key key, @required this.formKey}) : super(key: key);

  final Key formKey;

  @override
  _AppDirectoryLocationFormState createState() =>
      _AppDirectoryLocationFormState();
}

class _AppDirectoryLocationFormState extends State<AppDirectoryLocationForm> {
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
    return Form(
      key: widget.formKey,
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
                return DropdownButtonFormField<Directory>(
                  items: dropdownButtonItems,
                  hint: Text("Location"),
                  isExpanded: true,
                  value: selectedDirectory,
                  onChanged: (value) {
                    setState(() {
                      selectedDirectory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Required";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    context.read<DownloadLocation>().path = newValue.path;
                  },
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
            onSaved: (newValue) =>
                context.read<DownloadLocation>().name = newValue,
          ),
          Padding(padding: const EdgeInsets.all(8.0)),
          Text(
            "If the path doesn't contain \"emulated\", it is proably external storage.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
