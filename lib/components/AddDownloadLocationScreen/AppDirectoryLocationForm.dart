import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/FinampModels.dart';

class AppDirectoryLocationForm extends StatefulWidget {
  const AppDirectoryLocationForm({Key? key, required this.formKey})
      : super(key: key);

  final Key formKey;

  @override
  _AppDirectoryLocationFormState createState() =>
      _AppDirectoryLocationFormState();
}

class _AppDirectoryLocationFormState extends State<AppDirectoryLocationForm> {
  Directory? selectedDirectory;
  late Future<List<Directory>?> externalStorageListFuture;

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
          FutureBuilder<List<Directory>?>(
            future: externalStorageListFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Text("No external directories.");
                }
                List<DropdownMenuItem<Directory>> dropdownButtonItems =
                    snapshot.data!
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
                  hint: const Text("Location"),
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
                    if (newValue != null) {
                      context.read<NewDownloadLocation>().path = newValue.path;
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Name (required)"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              }
              return null;
            },
            onSaved: (newValue) {
              if (newValue != null) {
                context.read<NewDownloadLocation>().name = newValue;
              }
            },
          ),
          const Padding(padding: EdgeInsets.all(8.0)),
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
