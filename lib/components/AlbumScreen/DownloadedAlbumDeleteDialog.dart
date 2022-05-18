import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/DownloadsHelper.dart';
import '../errorSnackbar.dart';

class DownloadedAlbumDeleteDialog extends StatelessWidget {
  const DownloadedAlbumDeleteDialog({
    Key? key,
    required this.items,
    required this.parent,
  }) : super(key: key);

  final List<BaseItemDto> items;
  final BaseItemDto parent;

  // used to make sure isDownloaded in DownloadButton is checked after downloads
  // actually get deleted
  void exitDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Downloads deleted.")));
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    final _downloadsHelper = GetIt.instance<DownloadsHelper>();
    return AlertDialog(
      title: const Text("Are you sure?"),
      actions: [
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("DELETE"),
          onPressed: () {
            _downloadsHelper.deleteDownloads(
                jellyfinItemIds: items.map((e) => e.id).toList(),
                deletedFor: parent.id
            ).whenComplete(() => exitDialog(context))
            .onError((error, stackTrace) => errorSnackbar(error, context));
          },
        ),
      ],
    );
  }
}
