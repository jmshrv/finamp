import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class RemoveFromCurrentPlaylistMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;
  final BaseItemDto? parentItem;
  final VoidCallback? onRemove;
  final bool confirmRemoval;

  const RemoveFromCurrentPlaylistMenuEntry({
    super.key,
    required this.baseItem,
    required this.parentItem,
    this.onRemove,
    this.confirmRemoval = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
        visible:
            parentItem != null && !ref.watch(finampSettingsProvider.isOffline),
        child: MenuEntry(
          icon: TablerIcons.playlist_x,
          title: AppLocalizations.of(context)!.removeFromPlaylistTitle,
          enabled: parentItem != null,
          onTap: () async {
            Navigator.pop(context); // close menu
            var removed = await removeFromPlaylist(
                context, baseItem, parentItem!, baseItem.playlistItemId!,
                confirm: true);
            if (removed) {
              onRemove?.call();
              if (context.mounted) {
                Navigator.pop(context);
              }
            }
          },
        ));
  }
}
