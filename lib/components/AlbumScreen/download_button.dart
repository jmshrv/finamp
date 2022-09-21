import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/finamp_user_helper.dart';
import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../error_snackbar.dart';
import 'download_dialog.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton({
    Key? key,
    required this.parent,
    required this.items,
  }) : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> items;

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  late bool isDownloaded;

  @override
  void initState() {
    super.initState();
    isDownloaded = _downloadsHelper.isAlbumDownloaded(widget.parent.id);
  }

  @override
  Widget build(BuildContext context) {
    void _checkIfDownloaded() {
      if (!mounted) return;
      setState(() {
        isDownloaded = _downloadsHelper.isAlbumDownloaded(widget.parent.id);
      });
    }

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? isOffline = box.get("FinampSettings")?.isOffline;

        return IconButton(
          icon: isDownloaded
              ? const Icon(Icons.delete)
              : const Icon(Icons.file_download),
          // If offline, we don't allow the user to delete items.
          // If we did, we'd have to implement listeners for MusicScreenTabView so that the user can't delete a parent, go back, and select the same parent.
          // If they did, AlbumScreen would show an error since the item no longer exists.
          // Also, the user could delete the parent and immediately redownload it, which will either cause unwanted network usage or cause more errors becuase the user is offline.
          onPressed: isOffline ?? false
              ? null
              : () {
                  if (isDownloaded) {
                    _downloadsHelper
                        .deleteDownloads(
                      jellyfinItemIds: widget.items.map((e) => e.id).toList(),
                      deletedFor: widget.parent.id,
                    )
                        .then((_) {
                      _checkIfDownloaded();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.downloadsDeleted),
                      ));
                    },
                            onError: (error, stackTrace) =>
                                errorSnackbar(error, context));
                  } else {
                    if (FinampSettingsHelper
                            .finampSettings.downloadLocationsMap.length ==
                        1) {
                      checkedAddDownloads(
                        context,
                        downloadLocation: FinampSettingsHelper
                            .finampSettings.downloadLocationsMap.values.first,
                        parents: [widget.parent],
                        items: [widget.items],
                        viewId: _finampUserHelper.currentUser!.currentViewId!,
                      ).whenComplete(() => _checkIfDownloaded());
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => DownloadDialog(
                          parents: [widget.parent],
                          items: [widget.items],
                          viewId: _finampUserHelper.currentUser!.currentViewId!,
                        ),
                      ).whenComplete(() => _checkIfDownloaded());
                    }
                  }
                },
        );
      },
    );
  }
}
