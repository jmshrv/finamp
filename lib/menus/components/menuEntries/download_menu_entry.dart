import 'package:finamp/components/AlbumScreen/download_dialog.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class DownloadMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const DownloadMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsService = GetIt.instance<DownloadsService>();

    final downloadStatus = downloadsService.getStatus(
        DownloadStub.fromItem(
            type: BaseItemDtoType.fromItem(baseItem) == BaseItemDtoType.track
                ? DownloadItemType.track
                : DownloadItemType.collection,
            item: baseItem),
        null);

    return Visibility(
        visible: !ref.watch(finampSettingsProvider.isOffline) &&
            downloadStatus == DownloadItemStatus.notNeeded,
        child: MenuEntry(
            icon: TablerIcons.download,
            title: AppLocalizations.of(context)!.downloadItem,
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
            }));
  }
}
