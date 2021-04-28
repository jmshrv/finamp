import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../services/DownloadsHelper.dart';
import '../../services/FinampSettingsHelper.dart';
import '../../models/JellyfinModels.dart';
import '../../models/FinampModels.dart';
import '../errorSnackbar.dart';
import 'DownloadDialog.dart';

class DownloadButton extends StatefulWidget {
  DownloadButton({Key key, @required this.parent, @required this.items})
      : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> items;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  bool isDownloaded;

  @override
  void initState() {
    super.initState();
    isDownloaded = downloadsHelper.isAlbumDownloaded(widget.parent.id);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool isOffline = box.get("FinampSettings").isOffline;

        return IconButton(
          icon: isDownloaded ? Icon(Icons.delete) : Icon(Icons.file_download),
          // If offline, we don't allow the user to delete items.
          // If we did, we'd have to implement listeners for MusicScreenTabView so that the user can't delete a parent, go back, and select the same parent.
          // If they did, AlbumScreen would show an error since the item no longer exists.
          // Also, the user could delete the parent and immediately redownload it, which will either cause unwanted network usage or cause more errors becuase the user is offline.
          onPressed: isOffline
              ? null
              : () {
                  if (isDownloaded) {
                    downloadsHelper
                        .deleteDownloads(
                          widget.items.map((e) => e.id).toList(),
                          widget.parent.id,
                        )
                        .then(
                            (_) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Downloads deleted"))),
                            onError: (error, stackTrace) =>
                                errorSnackbar(error, context));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => DownloadDialog(
                        parent: widget.parent,
                        items: widget.items,
                      ),
                    );
                  }
                },
        );
      },
    );
  }
}
