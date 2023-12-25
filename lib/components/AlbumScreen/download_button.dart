import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';
import '../global_snackbar.dart';
import 'download_dialog.dart';
import '../confirmation_prompt_dialog.dart';

class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    Key? key,
    required this.item,
    this.children,
  }) : super(key: key);

  final DownloadStub item;
  final int? children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarDownloads = GetIt.instance<IsarDownloads>();
    var status = ref.watch(isarDownloads.statusProvider((item, children)));

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        if (FinampSettingsHelper.finampSettings.isOffline){
          return const SizedBox.shrink();
        }

        var downloadButton = IconButton(
          icon: status == DownloadItemStatus.notNeeded
              ? const Icon(Icons.file_download)
              : const Icon(Icons.lock),//TODO get better icon
          onPressed: () {
            if (FinampSettingsHelper
                    .finampSettings.downloadLocationsMap.length ==
                1) {
              isarDownloads.addDownload(
                  stub: item,
                  downloadLocation: FinampSettingsHelper
                      .finampSettings.downloadLocationsMap.values.first);
            } else {
              showDialog(
                context: context,
                builder: (context) => DownloadDialog(
                  item: item,
                ),
              );
            }
          },
        );
        var deleteButton = IconButton(
          icon: const Icon(Icons.delete),
          // If offline, we don't allow the user to delete items.
          // If we did, we'd have to implement listeners for MusicScreenTabView so that the user can't delete a parent, go back, and select the same parent.
          // If they did, AlbumScreen would show an error since the item no longer exists.
          // Also, the user could delete the parent and immediately redownload it, which will either cause unwanted network usage or cause more errors because the user is offline.
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ConfirmationPromptDialog(
                promptText: AppLocalizations.of(context)!.deleteDownloadsPrompt(
                    item.baseItem?.name ?? "", item.type.name),
                confirmButtonText: AppLocalizations.of(context)!
                    .deleteDownloadsConfirmButtonText,
                abortButtonText: AppLocalizations.of(context)!
                    .deleteDownloadsAbortButtonText,
                onConfirmed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final text = AppLocalizations.of(context)!.downloadsDeleted;
                  try {
                    await isarDownloads.deleteDownload(stub: item);
                    messenger.showSnackBar(SnackBar(content: Text(text)));
                  } catch (error) {
                    GlobalSnackbar.error(error);
                  }
                },
                onAborted: () {},
              ),
            );
            // .whenComplete(() => checkIfDownloaded());
          },
        );
        //TODO make more prominent - still show but less prominent when not outdated?
        var syncButton = IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () {
            isarDownloads.resync(item);
          },
        );
        var coreButton = status.isRequired ? deleteButton : downloadButton;
        if (status.outdated) {
          return Row(children: [syncButton, coreButton]);
        }
        return coreButton;
      },
    );
  }
}
