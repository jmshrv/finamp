import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/finamp_models.dart';
import '../../generate_material_color.dart';

class CustomDownloadLocationForm extends StatefulWidget {
  const CustomDownloadLocationForm({Key? key, required this.formKey})
      : super(key: key);

  final Key formKey;

  @override
  State<CustomDownloadLocationForm> createState() =>
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
                                    ? AppLocalizations.of(context)!
                                        .selectDirectory
                                    : selectedDirectory!.path.replaceFirst(
                                        "${selectedDirectory!.parent.path}/",
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
                        field.errorText ??
                            AppLocalizations.of(context)!.unknownError,
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
                return AppLocalizations.of(context)!.required;
              }

              // There are a load of null checks here, but since we've already
              // checked if selectedDirectory is null we should be fine.

              if (selectedDirectory!.path == "/") {
                return AppLocalizations.of(context)!
                    .pathReturnSlashErrorMessage;
              }

              // This checks if the chosen directory is empty
              if (selectedDirectory!
                  .listSync()
                  .where((event) => !event.path
                      .replaceFirst(selectedDirectory!.path, "")
                      .contains("."))
                  .isNotEmpty) {
                return AppLocalizations.of(context)!.directoryMustBeEmpty;
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
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context)!.name),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.required;
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
          Text(AppLocalizations.of(context)!.customLocationsBuggy,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
