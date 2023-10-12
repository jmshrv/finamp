import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/downloads_helper.dart';
import '../error_snackbar.dart';

class DownloadedAlbumDeleteDialog extends AlertDialog {
  const DownloadedAlbumDeleteDialog({
    Key? key,
    required this.onConfirmed,
    required this.onAborted,
  }) : super(key: key);

  final void Function()? onConfirmed;
  final void Function()? onAborted;

  // used to make sure isDownloaded in DownloadButton is checked after downloads
  // actually get deleted
  void exitDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Downloads deleted.")));
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure?"),
      actions: [
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () {
            Navigator.of(context).pop();
            onAborted?.call();
          },
        ),
        TextButton(
          child: const Text("DELETE"),
          onPressed: () {
            exitDialog(context);
            onConfirmed?.call();
          },
        ),
      ],
    );
  }
}
