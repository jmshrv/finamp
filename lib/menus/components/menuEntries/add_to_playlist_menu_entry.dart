import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/menus/playlist_actions_menu.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class AddToPlaylistMenuEntry extends ConsumerWidget implements HideableMenuEntry {
  final BaseItemDto baseItem;
  final FinampQueueItem? queueItem;

  const AddToPlaylistMenuEntry({
    super.key,
    required this.baseItem,
    this.queueItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
        visible: !ref.watch(finampSettingsProvider.isOffline),
        child: MenuEntry(
          icon: TablerIcons.playlist_add,
          title: queueItemInPlaylist(queueItem)
              ? AppLocalizations.of(context)!.addToMorePlaylistsTitle
              : AppLocalizations.of(context)!.addToPlaylistTitle,
          onTap: () {
            Navigator.pop(context); // close menu
            bool inPlaylist = queueItemInPlaylist(queueItem);
            showPlaylistActionsMenu(
              context: context,
              item: baseItem,
              parentPlaylist: inPlaylist ? queueItem!.source.item : null,
            );
          },
        ));
  }

  @override
  bool get isVisible => !FinampSettingsHelper.finampSettings.isOffline;
}
