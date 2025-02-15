import 'package:flutter/material.dart';

import '../../services/finamp_settings_helper.dart';

class DownloadLocationDeleteDialog extends StatelessWidget {
  const DownloadLocationDeleteDialog({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure?"),
      content: const Text(
          "Deleting a download location doesn't actually delete any downloads. It just removes the menu entry."),
      actions: [
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("DELETE"),
          onPressed: () {
            FinampSettingsHelper.deleteDownloadLocation(id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
