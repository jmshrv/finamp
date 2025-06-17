import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/genre_screen.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class GoToGenreMenuEntry extends ConsumerWidget implements HideableMenuEntry {
  final BaseItemDto baseItem;

  const GoToGenreMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    final canGoToGenre = (baseItem.genreItems?.isNotEmpty ?? false);

    return Visibility(
      visible: canGoToGenre,
      child: MenuEntry(
        icon: TablerIcons.color_swatch,
        title: AppLocalizations.of(context)!.goToGenre,
        onTap: () async {
          late BaseItemDto genre;
          try {
            if (FinampSettingsHelper.finampSettings.isOffline) {
              final downloadsService = GetIt.instance<DownloadsService>();
              genre = (await downloadsService.getCollectionInfo(id: baseItem.genreItems!.first.id))!.baseItem!;
            } else {
              genre = await jellyfinApiHelper.getItemById(baseItem.genreItems!.first.id);
            }
          } catch (e) {
            GlobalSnackbar.error(e);
            return;
          }
          if (context.mounted) {
            Navigator.pop(context);
            await Navigator.of(context).pushNamed(GenreScreen.routeName, arguments: genre);
          }
        },
      ),
    );
  }

  @override
  bool get isVisible => baseItem.genreItems?.isNotEmpty ?? false;
}
