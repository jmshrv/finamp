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

class InstantMixMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const InstantMixMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final downloadsService = GetIt.instance<DownloadsService>();
    final queueService = GetIt.instance<QueueService>();
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    return Visibility(
        visible: !ref.watch(finampSettingsProvider.isOffline),
        child: MenuEntry(
          icon: TablerIcons.corner_right_down,
          title: AppLocalizations.of(context)!.instantMix,
          onTap: () async {
            await audioServiceHelper.startInstantMixForItem(baseItem);

            if (!context.mounted) return;

            GlobalSnackbar.message(
                (context) => AppLocalizations.of(context)!.startingInstantMix,
                isConfirmation: true);
            Navigator.pop(context);
          },
        ));
  }
}
