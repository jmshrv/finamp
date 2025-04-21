import 'dart:async';

import 'package:finamp/menus/album_menu.dart';
import 'package:finamp/menus/artist_menu.dart';
import 'package:finamp/menus/genre_menu.dart';
import 'package:finamp/menus/playlist_menu.dart';
import 'package:finamp/components/MusicScreen/album_item_list_tile.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/album_screen.dart';
import '../../screens/artist_screen.dart';
import '../../services/downloads_service.dart';
import '../../services/favorite_provider.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../menus/playlist_actions_menu.dart';
import '../AlbumScreen/download_dialog.dart';
import '../global_snackbar.dart';
import 'album_item_card.dart';

enum _AlbumListTileMenuItems {
  addFavourite,
  removeFavourite,
  addToMixList,
  removeFromMixList,
  download,
  deleteFromDevice,
  playNext,
  addToNextUp,
  shuffleNext,
  shuffleToNextUp,
  addToQueue,
  shuffleToQueue,
  goToArtist,
  deleteFromServer,
  addToPlaylist,
}

//TODO should this be unified with artist screen version?
/// This widget is kind of a shell around AlbumItemCard and AlbumItemListTile.
/// Depending on the values given, a list tile or a card will be returned. This
/// widget exists to handle the dropdown stuff and other stuff shared between
/// the two widgets.
class AlbumItem extends ConsumerStatefulWidget {
  const AlbumItem({
    super.key,
    required this.album,
    required this.isPlaylist,
    this.parentType,
    this.onTap,
    this.isGrid = false,
  });

  /// The album (or item, I just used to call items albums before Finamp
  /// supported other types) to show in the widget.
  final BaseItemDto album;

  /// The parent type of the item. Used to change onTap functionality for stuff
  /// like artists.
  final String? parentType;

  /// Used to differentiate between albums and playlists, since they use the same internal logic and widgets
  final bool isPlaylist;

  /// A custom onTap can be provided to override the default value, which is to
  /// open the item's album/artist screen.
  final void Function()? onTap;

  /// If specified, use cards instead of list tiles. Use this if you want to use
  /// this widget in a grid view.
  final bool isGrid;

  @override
  ConsumerState<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends ConsumerState<AlbumItem> {
  late BaseItemDto mutableAlbum;

  QueueService get _queueService => GetIt.instance<QueueService>();

  late Function() onTap;
  late AppLocalizations local;

  @override
  void initState() {
    super.initState();
    mutableAlbum = widget.album;

    // this is jank lol
    onTap = widget.onTap ??
        () {
          if (mutableAlbum.type == "MusicArtist" ||
              mutableAlbum.type == "MusicGenre") {
            Navigator.of(context)
                .pushNamed(ArtistScreen.routeName, arguments: mutableAlbum);
          } else {
            Navigator.of(context)
                .pushNamed(AlbumScreen.routeName, arguments: mutableAlbum);
          }
        };
  }

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;

    final screenSize = MediaQuery.of(context).size;

    void menuCallback() async {
      unawaited(Feedback.forLongPress(context));

      switch (BaseItemDtoType.fromItem(mutableAlbum)) {
        case BaseItemDtoType.artist:
          await showModalArtistMenu(context: context, item: mutableAlbum);
          break;
        case BaseItemDtoType.genre:
          await showModalGenreMenu(context: context, item: mutableAlbum);
          break;
        case BaseItemDtoType.playlist:
          await showModalPlaylistMenu(context: context, item: mutableAlbum);
          break;
        default:
          await showModalAlbumMenu(context: context, baseItem: mutableAlbum);
      }
    }

    return Padding(
      padding: widget.isGrid
          ? Theme.of(context).cardTheme.margin ?? const EdgeInsets.all(4.0)
          : EdgeInsets.zero,
      child: GestureDetector(
        onLongPressStart: (details) => menuCallback(),
        onSecondaryTapDown: (details) => menuCallback(),
        child: widget.isGrid
            ? AlbumItemCard(
                item: mutableAlbum,
                onTap: onTap,
                parentType: widget.parentType,
              )
            : AlbumItemListTile(
                item: mutableAlbum,
                onTap: onTap,
                parentType: widget.parentType,
              ),
      ),
    );
  }
}
