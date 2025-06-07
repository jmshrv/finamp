import 'package:finamp/components/AlbumScreen/download_dialog.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/delete_from_device_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/download_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class AdaptiveDownloadLockDeleteMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const AdaptiveDownloadLockDeleteMenuEntry({
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

    if (!ref.watch(finampSettingsProvider.isOffline) &&
        downloadStatus == DownloadItemStatus.notNeeded) {
      return DownloadMenuEntry(baseItem: baseItem);
    } else if (downloadStatus.isRequired) {
      return DeleteFromDeviceMenuEntry(baseItem: baseItem);
    } else if (!ref.watch(finampSettingsProvider.isOffline) &&
        downloadStatus.isIncidental) {
      return DownloadMenuEntry(baseItem: baseItem);
    } else {
      return SizedBox.shrink();
    }
  }
}
