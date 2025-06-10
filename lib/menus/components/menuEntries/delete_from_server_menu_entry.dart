import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class DeleteFromServerMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const DeleteFromServerMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final downloadsService = GetIt.instance<DownloadsService>();
    final queueService = GetIt.instance<QueueService>();

    final canDelete =
        ref.watch(jellyfinApiHelper.canDeleteFromServerProvider(baseItem));

    return Visibility(
      visible: canDelete,
      child: MenuEntry(
        icon: TablerIcons.trash_x,
        title: AppLocalizations.of(context)!
            .deleteFromTargetConfirmButton("server"),
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
}
