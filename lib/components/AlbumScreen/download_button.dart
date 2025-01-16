import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_service.dart';
import '../confirmation_prompt_dialog.dart';
import '../global_snackbar.dart';
import 'download_dialog.dart';

class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    super.key,
    required this.item,
    this.children,
    this.isLibrary = false,
  });

  final DownloadStub item;
  final int? children;
  final bool isLibrary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsService = GetIt.instance<DownloadsService>();
    DownloadItemStatus? status =
        ref.watch(downloadsService.statusProvider((item, children))).value;
    var isOffline = ref.watch(finampSettingsProvider
            .select((value) => value.valueOrNull?.isOffline)) ??
        true;
    String? parentTooltip;
    if (status == null) {
      return const SizedBox.shrink();
    }
    if (status.isIncidental) {
      var parent = downloadsService.getFirstRequiringItem(item);
      if (parent != null) {
        var parentName = AppLocalizations.of(context)!
            .itemTypeSubtitle(parent.baseItemType.name, parent.name);
        parentTooltip =
            AppLocalizations.of(context)!.incidentalDownloadTooltip(parentName);
      }
    }
    String viewId;
    if (isLibrary) {
      viewId = item.id;
    } else {
      final finampUserHelper = GetIt.instance<FinampUserHelper>();
      viewId = finampUserHelper.currentUser!.currentViewId!;
    }

    var downloadButton = IconButton(
      icon: status == DownloadItemStatus.notNeeded
          ? const Icon(Icons.file_download)
          : const Icon(Icons.lock), //TODO get better icon
      onPressed: () async {
        if (isLibrary) {
          await showDialog(
              context: context,
              builder: (context) => ConfirmationPromptDialog(
                    promptText: AppLocalizations.of(context)!
                        .downloadLibraryPrompt(item.name),
                    confirmButtonText:
                        AppLocalizations.of(context)!.addButtonLabel,
                    abortButtonText:
                        MaterialLocalizations.of(context).cancelButtonLabel,
                    onConfirmed: () =>
                        DownloadDialog.show(context, item, viewId),
                    onAborted: () {},
                  ));
        } else {
          await DownloadDialog.show(context, item, viewId);
        }
      },
      tooltip: parentTooltip,
    );
    var deleteButton = IconButton(
      icon: const Icon(Icons.delete),
      tooltip: AppLocalizations.of(context)!.deleteItem,
      // If offline, we don't allow the user to delete items.
      // If we did, we'd have to implement listeners for MusicScreenTabView so that the user can't delete a parent, go back, and select the same parent.
      // If they did, AlbumScreen would show an error since the item no longer exists.
      // Also, the user could delete the parent and immediately redownload it, which will either cause unwanted network usage or cause more errors because the user is offline.
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ConfirmationPromptDialog(
            promptText: AppLocalizations.of(context)!.deleteDownloadsPrompt(
                item.baseItem?.name ?? "", item.baseItemType.name),
            confirmButtonText:
                AppLocalizations.of(context)!.deleteDownloadsConfirmButtonText,
            abortButtonText:
                AppLocalizations.of(context)!.genericCancel,
            onConfirmed: () async {
              try {
                await downloadsService.deleteDownload(stub: item);
                GlobalSnackbar.message((scaffold) =>
                    AppLocalizations.of(scaffold)!.downloadsDeleted);
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
    var syncButton = IconButton(
      icon: const Icon(Icons.sync),
      tooltip: AppLocalizations.of(context)!.syncDownloads,
      onPressed: () {
        downloadsService.resync(item, viewId);
      },
      color: status.outdated ? Colors.orange : null,
    );
    if (isOffline) {
      if (status.isRequired) {
        return deleteButton;
      } else {
        return const SizedBox.shrink();
      }
    }
    var coreButton = status.isRequired ? deleteButton : downloadButton;
    // Only show sync on album/song if there we know we are outdated due to failed downloads or the like.
    // On playlists/artists/genres, always show if downloaded.
    List<Widget> buttons;
    if (status == DownloadItemStatus.notNeeded ||
        ((item.baseItemType == BaseItemDtoType.album ||
                item.baseItemType == BaseItemDtoType.song) &&
            !status.outdated) ||
        isLibrary) {
      buttons = [coreButton];
      return coreButton;
    } else {
      buttons = [syncButton, coreButton];
    }
    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }
}
