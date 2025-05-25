import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/album_screen.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class GoToAlbumMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const GoToAlbumMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    final canGoToAlbum = baseItem.parentId != null;

    return Visibility(
      visible: canGoToAlbum,
      child: MenuEntry(
        icon: TablerIcons.disc,
        title: AppLocalizations.of(context)!.goToAlbum,
        onTap: () async {
          late BaseItemDto album;
          try {
            if (FinampSettingsHelper.finampSettings.isOffline) {
              final downloadsService = GetIt.instance<DownloadsService>();
              album = (await downloadsService.getCollectionInfo(
                      id: baseItem.albumId!))!
                  .baseItem!;
            } else {
              album = await jellyfinApiHelper.getItemById(baseItem.albumId!);
            }
          } catch (e) {
            GlobalSnackbar.error(e);
            return;
          }
          if (context.mounted) {
            Navigator.pop(context);
            await Navigator.of(context)
                .pushNamed(AlbumScreen.routeName, arguments: album);
          }
        },
      ),
    );
  }
}
