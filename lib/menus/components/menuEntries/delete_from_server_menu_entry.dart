import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class DeleteFromServerMenuEntry extends ConsumerWidget implements HideableMenuEntry {
  final BaseItemDto baseItem;

  const DeleteFromServerMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    final canDelete = ref.watch(jellyfinApiHelper.canDeleteFromServerProvider(baseItem));

    return Visibility(
      visible: canDelete,
      child: MenuEntry(
        icon: TablerIcons.trash_x,
        title: AppLocalizations.of(context)!.deleteFromTargetConfirmButton("server"),
        onTap: () async {
          var item = DownloadStub.fromItem(
              type: BaseItemDtoType.fromItem(baseItem) == BaseItemDtoType.track
                  ? DownloadItemType.track
                  : DownloadItemType.collection,
              item: baseItem);
          await askBeforeDeleteFromServerAndDevice(context, item);
          Navigator.pop(context); // close popup
          musicScreenRefreshStream.add(null);
        },
      ),
    );
  }

  @override
  bool get isVisible {
    if (FinampSettingsHelper.finampSettings.isOffline) {
      return false;
    }
    var itemType = BaseItemDtoType.fromItem(baseItem);
    var isPlaylist = itemType == BaseItemDtoType.playlist;
    bool deleteEnabled = FinampSettingsHelper.finampSettings.allowDeleteFromServer;

    // always check if a playlist is deletable
    if (!deleteEnabled && !isPlaylist) {
      return false;
    }

    // do not bother checking server for item types known to not be deletable
    if (![BaseItemDtoType.album, BaseItemDtoType.playlist, BaseItemDtoType.track].contains(itemType)) {
      return false;
    }
    return baseItem.canDelete ?? true;
  }
}
