import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class ClearQueueMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const ClearQueueMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    final canGoToGenre = (baseItem.genreItems?.isNotEmpty ?? false);

    return Visibility(
      visible: canGoToGenre,
      child: MenuEntry(
        icon: TablerIcons.clear_all,
        title: AppLocalizations.of(context)!.stopAndClearQueue,
        onTap: () async {
          if (context.mounted) Navigator.pop(context);
          await queueService.stopPlayback();
        },
      ),
    );
  }
}
