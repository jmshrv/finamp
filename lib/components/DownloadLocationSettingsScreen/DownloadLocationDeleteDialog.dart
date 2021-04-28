import 'package:flutter/material.dart';

import '../../services/FinampSettingsHelper.dart';

class DownloadLocationDeleteDialog extends StatelessWidget {
  const DownloadLocationDeleteDialog({Key key, @required this.index})
      : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      content: Text(
          "Deleting a download location doesn't actually delete any downloads. It just removes the menu entry."),
      actions: [
        TextButton(
          child: Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text("DELETE"),
          onPressed: () {
            FinampSettingsHelper.deleteDownloadLocation(index);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
