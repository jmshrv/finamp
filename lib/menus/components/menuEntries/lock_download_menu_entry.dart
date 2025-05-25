import 'package:finamp/components/AlbumScreen/download_dialog.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class LockDownloadMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const LockDownloadMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final downloadsService = GetIt.instance<DownloadsService>();
    final queueService = GetIt.instance<QueueService>();
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    final downloadStatus = downloadsService.getStatus(
        DownloadStub.fromItem(
            type: BaseItemDtoType.fromItem(baseItem) == BaseItemDtoType.track
                ? DownloadItemType.track
                : DownloadItemType.collection,
            item: baseItem),
        null);

    String? parentTooltip;
    if (downloadStatus.isIncidental) {
      var parent = downloadsService.getFirstRequiringItem(DownloadStub.fromItem(
          type: BaseItemDtoType.fromItem(baseItem) == BaseItemDtoType.track
              ? DownloadItemType.track
              : DownloadItemType.collection,
          item: baseItem));
      if (parent != null) {
        var parentName = AppLocalizations.of(context)!
            .itemTypeSubtitle(parent.baseItemType.name, parent.name);
        parentTooltip =
            AppLocalizations.of(context)!.incidentalDownloadTooltip(parentName);
      }
    }

    return Visibility(
        visible: !ref.watch(finampSettingsProvider.isOffline) &&
            downloadStatus.isIncidental,
        child: Tooltip(
          message: parentTooltip ?? "Widget shouldn't be visible",
          child: MenuEntry(
              icon: Icons.lock_outlined,
              title: AppLocalizations.of(context)!.lockDownload,
              onTap: () async {
                var item = DownloadStub.fromItem(
                    type: BaseItemDtoType.fromItem(baseItem) ==
                            BaseItemDtoType.track
                        ? DownloadItemType.track
                        : DownloadItemType.collection,
                    item: baseItem);
                await DownloadDialog.show(context, item, null);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }),
        ));
  }
}
