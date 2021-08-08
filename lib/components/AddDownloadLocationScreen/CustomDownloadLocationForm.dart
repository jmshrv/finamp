import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/FinampModels.dart';
import '../../generateMaterialColor.dart';

class CustomDownloadLocationForm extends StatefulWidget {
  const CustomDownloadLocationForm({Key? key, required this.formKey})
      : super(key: key);

  final Key formKey;

  @override
  _CustomDownloadLocationFormState createState() =>
      _CustomDownloadLocationFormState();
}

class _CustomDownloadLocationFormState
    extends State<CustomDownloadLocationForm> {
  Directory? selectedDirectory;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormField<Directory>(
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
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
                                    : selectedDirectory!.path.replaceFirst(
                                        selectedDirectory!.parent.path + "/",
                                        ""),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: selectedDirectory == null
                                    ? Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                          color: Theme.of(context).hintColor,
                                        )
                                    : Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.folder),
                                onPressed: () async {
                                  String? newPath = await FilePicker.platform
                                      .getDirectoryPath();

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
                        field.errorText ?? "Unknown Error",
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: Theme.of(context).errorColor),
                      ),
                    ),
                ],
              );
            },
            validator: (_) {
              if (selectedDirectory == null) {
                return "Required";
              }

              // There are a load of null checks here, but since we've already
              // checked if selectedDirectory is null we should be fine.

              if (selectedDirectory!.path == "/") {
                return "Paths that return \"/\" can't be used";
              }

              // This checks if the chosen directory is empty
              if (selectedDirectory!
                      .listSync()
                      .where((event) => !event.path
                          .replaceFirst(selectedDirectory!.path, "")
                          .contains("."))
                      .length >
                  0) {
                return "Directory must be empty";
              }
              return null;
            },
            onSaved: (_) {
              if (selectedDirectory != null) {
                context.read<NewDownloadLocation>().path =
                    selectedDirectory!.path;
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
          if (Platform.isAndroid)
            Text(
              "Custom locations can be buggy regarding permissions. If they don't work, use an app directory location instead.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
        ],
      ),
    );
  }
}
