import 'package:file_sizes/file_sizes.dart';
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

enum DownloadChoice {
  original,
  transcoded,
}

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
    void checkIfDownloaded() {
      if (!mounted) return;
      setState(() {
        isDownloaded = _downloadsHelper.isAlbumDownloaded(widget.parent.id);
      });
    }

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        return PopupMenuButton<DownloadChoice>(
          icon: isDownloaded
              ? const Icon(Icons.delete)
              : const Icon(Icons.file_download),
          enabled: !FinampSettingsHelper.finampSettings.isOffline,
          itemBuilder: (context) {
            // To get the original file sizes, we just count up the given sizes
            final originalFileSize = widget.items
                .map((e) => e.mediaSources?.first.size ?? 0)
                .fold(0, (a, b) => a + b);

            final originalFileSizeFormatted = FileSize.getSize(
              originalFileSize,
              precision: PrecisionValue.None,
            );

            final formats = widget.items
                .map((e) => e.mediaSources?.first.mediaStreams.first.codec)
                .toSet();

            return [
              PopupMenuItem(
                value: DownloadChoice.original,
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.original),
                  // We don't want to show the format on items with multiple,
                  // since it's messy and there isn't a clean way to handle it
                  // in multiple languages.
                  subtitle: Text(formats.length == 1
                      ? AppLocalizations.of(context)!.fileSizeFormat(
                          originalFileSizeFormatted,
                          formats.first!.toUpperCase(),
                        )
                      : originalFileSizeFormatted),
                ),
              )
            ];
          },
          onSelected: (value) {},
          // If offline, we don't allow the user to delete items.
          // If we did, we'd have to implement listeners for MusicScreenTabView so that the user can't delete a parent, go back, and select the same parent.
          // If they did, AlbumScreen would show an error since the item no longer exists.
          // Also, the user could delete the parent and immediately redownload it, which will either cause unwanted network usage or cause more errors becuase the user is offline.
          // onPressed: isOffline ?? false
          //     ? null
          //     : () async {
          //       final transcodingChoice =
          //         if (isDownloaded) {
          //           _downloadsHelper
          //               .deleteDownloads(
          //             jellyfinItemIds: widget.items.map((e) => e.id).toList(),
          //             deletedFor: widget.parent.id,
          //           )
          //               .then((_) {
          //             checkIfDownloaded();
          //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //               content: Text(
          //                   AppLocalizations.of(context)!.downloadsDeleted),
          //             ));
          //           },
          //                   onError: (error, stackTrace) =>
          //                       errorSnackbar(error, context));
          //         } else {
          //           if (FinampSettingsHelper
          //                   .finampSettings.downloadLocationsMap.length ==
          //               1) {
          //             await checkedAddDownloads(
          //               context,
          //               downloadLocation: FinampSettingsHelper
          //                   .finampSettings.downloadLocationsMap.values.first,
          //               parents: [widget.parent],
          //               items: [widget.items],
          //               viewId: _finampUserHelper.currentUser!.currentViewId!,
          //             );
          //           } else {
          //             await showDialog(
          //               context: context,
          //               builder: (context) => DownloadDialog(
          //                 parents: [widget.parent],
          //                 items: [widget.items],
          //                 viewId: _finampUserHelper.currentUser!.currentViewId!,
          //               ),
          //             );
          //           }
          //           checkIfDownloaded();
          //         }
          //       },
        );
      },
    );
  }
}
