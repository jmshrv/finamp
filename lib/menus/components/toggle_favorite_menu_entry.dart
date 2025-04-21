import 'package:finamp/components/AlbumScreen/download_dialog.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/favorite_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class ToggleFavoriteMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const ToggleFavoriteMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final downloadsService = GetIt.instance<DownloadsService>();
    final queueService = GetIt.instance<QueueService>();
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    bool isFav = ref.watch(isFavoriteProvider(baseItem));

    return Visibility(
        visible: !ref.watch(finampSettingsProvider.isOffline),
        child: MenuEntry(
            icon: isFav ? TablerIcons.heart_filled : TablerIcons.heart,
            title: isFav
                ? AppLocalizations.of(context)!.removeFavourite
                : AppLocalizations.of(context)!.addFavourite,
            onTap: () async {
              ref
                  .read(isFavoriteProvider(baseItem).notifier)
                  .updateFavorite(!isFav);
              if (context.mounted) Navigator.pop(context);
            }));
  }
}
