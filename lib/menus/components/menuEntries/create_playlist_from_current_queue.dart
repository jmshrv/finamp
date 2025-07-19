import 'package:finamp/components/AddToPlaylistScreen/new_playlist_dialog.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class CreatePlaylistFromCurrentQueueMenuEntry extends ConsumerWidget implements HideableMenuEntry {

  const CreatePlaylistFromCurrentQueueMenuEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    return MenuEntry(
      icon: TablerIcons.list_tree,
      title: AppLocalizations.of(context)!.createPlaylistFromCurrentQueue,
      onTap: () async {
        final currentQueue = queueService.getQueue();

        if (context.mounted) Navigator.pop(context);
        var dialogResult = await showDialog<(Future<BaseItemId>, String?)?>(
          context: context,
          builder: (context) => NewPlaylistDialog(
            itemsToAdd: currentQueue.fullQueue.map((item) => item.baseItemId).toList(),
            initialName: currentQueue.source.name.getLocalized(context),
          ),
        );
      },
    );
  }

  @override
  bool get isVisible => true;
}
