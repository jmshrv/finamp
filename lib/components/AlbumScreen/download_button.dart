import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/downloads_service.dart';
import '../../services/jellyfin_api_helper.dart';
import '../MusicScreen/music_screen_tab_view.dart';
import '../confirmation_prompt_dialog.dart';
import 'download_dialog.dart';

class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    super.key,
    required this.item,
    this.children,
    this.isLibrary = false,
  });

  final DownloadStub item;
  final List<BaseItemDto>? children;
  final bool isLibrary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsService = GetIt.instance<DownloadsService>();
    DownloadItemStatus? status = ref
        .watch(downloadsService.statusProvider((item, children?.length)))
        .value;
    var isOffline = ref.watch(
        finampSettingsProvider.select((value) => value.requireValue.isOffline));
    bool canDeleteFromServer = false;
    if (item.type.requiresItem) {
      canDeleteFromServer = ref.watch(GetIt.instance<JellyfinApiHelper>()
          .canDeleteFromServerProvider(item.baseItem!));
    }
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
          int? trackCount = switch (item.baseItemType) {
            BaseItemDtoType.album ||
            BaseItemDtoType.playlist =>
              children?.length,
            BaseItemDtoType.artist || BaseItemDtoType.genre => children
                ?.fold<int>(0, (count, item) => count + (item.childCount ?? 0)),
            _ => null
          };
          await DownloadDialog.show(context, item, viewId,
              trackCount: trackCount);
        }
      },
      tooltip: parentTooltip,
    );
    var deleteButton = IconButton(
      icon: const Icon(Icons.delete),
      tooltip: AppLocalizations.of(context)!.deleteFromTargetConfirmButton(""),
      onPressed: () {
        askBeforeDeleteDownloadFromDevice(context, item);
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
    var serverDeleteButton = IconButton(
      icon: const Icon(Icons.delete_forever),
      tooltip:
          AppLocalizations.of(context)!.deleteFromTargetConfirmButton("server"),
      onPressed: () {
        askBeforeDeleteFromServerAndDevice(context, item,
            popIt: true,
            refresh: () => musicScreenRefreshStream
                .add(null)); // trigger a refresh of the music screen
      },
    );

    var deleteFromServerCombo = PopupMenuButton<Null>(
      enableFeedback: true,
      icon: const Icon(TablerIcons.dots_vertical),
      onOpened: () => {},
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              value: null,
              child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text(AppLocalizations.of(context)!
                      .deleteFromTargetConfirmButton("")),
                  enabled: true,
                  onTap: () {
                    askBeforeDeleteDownloadFromDevice(context, item);
                  })),
          PopupMenuItem(
              value: null,
              child: ListTile(
                  leading: Icon(Icons.delete_forever),
                  title: Text(AppLocalizations.of(context)!
                      .deleteFromTargetConfirmButton("server")),
                  enabled: true,
                  onTap: () {
                    askBeforeDeleteFromServerAndDevice(context, item,
                        popIt: true,
                        refresh: () => musicScreenRefreshStream.add(
                            null)); // trigger a refresh of the music screen
                  }))
        ];
      },
    );

    if (isOffline) {
      if (status.isRequired) {
        return deleteButton;
      } else {
        return const SizedBox.shrink();
      }
    }

    List<Widget> buttons;
    if (canDeleteFromServer && status.isRequired) {
      buttons = [deleteFromServerCombo];
    } else if (canDeleteFromServer) {
      buttons = [serverDeleteButton, downloadButton];
    } else {
      buttons = [downloadButton];
    }
    // Only show sync on album/track if there we know we are outdated due to failed downloads or the like.
    // On playlists/artists/genres, always show if downloaded.
    if (status != DownloadItemStatus.notNeeded &&
        ((item.baseItemType != BaseItemDtoType.album &&
                item.baseItemType != BaseItemDtoType.track) ||
            status.outdated) &&
        !isLibrary) {
      buttons.insert(0, syncButton);
    }

    if (buttons.length == 1) {
      return buttons.first;
    } else {
      return Row(mainAxisSize: MainAxisSize.min, children: buttons);
    }
  }
}
