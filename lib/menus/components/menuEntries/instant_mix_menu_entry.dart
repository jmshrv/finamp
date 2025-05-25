import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

/// Start Mix for Tracks, Add/Remove for item collections
class InstantMixMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const InstantMixMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    if (BaseItemDtoType.fromItem(baseItem) == BaseItemDtoType.track) {
      return MenuEntry(
        icon: TablerIcons.compass,
        title: AppLocalizations.of(context)!.instantMix,
        onTap: () async {
          Navigator.pop(context); // close menu
          await audioServiceHelper.startInstantMixForItem(baseItem);

          GlobalSnackbar.message(
              (context) => AppLocalizations.of(context)!.startingInstantMix,
              isConfirmation: true);
        },
      );
    }

    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final alreadyInMixBuilder = (switch (BaseItemDtoType.fromItem(baseItem)) {
      BaseItemDtoType.artist => jellyfinApiHelper.selectedMixArtists,
      BaseItemDtoType.album => jellyfinApiHelper.selectedMixAlbums,
      BaseItemDtoType.genre => jellyfinApiHelper.selectedMixGenres,
      _ => <BaseItemDto>[],
    })
        .map((e) => e.id)
        .contains(baseItem.id);
    return alreadyInMixBuilder
        ? MenuEntry(
            icon: TablerIcons.compass_off,
            title: AppLocalizations.of(context)!.removeFromMix,
            onTap: () {
              Navigator.pop(context); // close menu
              switch (BaseItemDtoType.fromItem(baseItem)) {
                case BaseItemDtoType.artist:
                  jellyfinApiHelper.removeArtistFromMixBuilderList(baseItem);
                  break;
                case BaseItemDtoType.album:
                  jellyfinApiHelper.removeAlbumFromMixBuilderList(baseItem);
                  break;
                case BaseItemDtoType.genre:
                  jellyfinApiHelper.removeGenreFromMixBuilderList(baseItem);
                  break;
                default:
                  GlobalSnackbar.message((context) =>
                      AppLocalizations.of(context)!.notImplementedYet);
              }
            },
          )
        : MenuEntry(
            icon: TablerIcons.compass,
            title: AppLocalizations.of(context)!.addToMix,
            onTap: () {
              Navigator.pop(context); // close menu
              switch (BaseItemDtoType.fromItem(baseItem)) {
                case BaseItemDtoType.artist:
                  jellyfinApiHelper.addArtistToMixBuilderList(baseItem);
                  break;
                case BaseItemDtoType.album:
                  jellyfinApiHelper.addAlbumToMixBuilderList(baseItem);
                  break;
                case BaseItemDtoType.genre:
                  jellyfinApiHelper.addGenreToMixBuilderList(baseItem);
                  break;
                default:
                  GlobalSnackbar.message((context) =>
                      AppLocalizations.of(context)!.notImplementedYet);
              }
            },
          );
  }
}
