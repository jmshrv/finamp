import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/menus/playlist_actions_menu.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class AddToPlaylistMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const AddToPlaylistMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
        visible: !ref.watch(finampSettingsProvider.isOffline),
        child: MenuEntry(
          icon: TablerIcons.playlist_add,
          title: AppLocalizations.of(context)!.addToPlaylistTitle,
          onTap: () {
            Navigator.pop(context); // close menu
            showPlaylistActionsMenu(
              context: context,
              item: baseItem,
            );
          },
        ));
  }
}
