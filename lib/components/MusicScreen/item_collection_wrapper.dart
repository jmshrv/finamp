import 'dart:async';

import 'package:finamp/components/MusicScreen/item_collection_card.dart';
import 'package:finamp/components/MusicScreen/item_collection_list_tile.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/album_menu.dart';
import 'package:finamp/menus/artist_menu.dart';
import 'package:finamp/menus/genre_menu.dart';
import 'package:finamp/menus/playlist_menu.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/album_screen.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/screens/genre_screen.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

/// This widget is kind of a wrapper around ItemCollectionCard and ItemCollectionListTile.
/// It gets used for albums, artists, genres and playlists.
/// Depending on the values given, a list tile or a card will be returned. This
/// widget exists to handle the dropdown stuff and other stuff shared between
/// the two widgets.
class ItemCollectionWrapper extends ConsumerStatefulWidget {
  const ItemCollectionWrapper({
    super.key,
    required this.item,
    required this.isPlaylist,
    this.parentType,
    this.onTap,
    this.isGrid = false,
    this.genreFilter,
    this.albumShowsYearAndDurationInstead = false,
    this.showAdditionalInfoForSortBy,
    this.showFavoriteIconOnlyWhenFilterDisabled = false,
  });

  /// The item to show in the widget.
  final BaseItemDto item;

  /// The parent type of the item. Used to change onTap functionality for stuff
  /// like artists.
  final String? parentType;

  /// Used to differentiate between albums and playlists, since they use the same internal logic and widgets
  final bool isPlaylist;

  /// A custom onTap can be provided to override the default value, which is to
  /// open the item's album/artist/genre/playlist screen.
  final void Function()? onTap;

  /// If specified, use cards instead of list tiles. Use this if you want to use
  /// this widget in a grid view.
  final bool isGrid;

  /// If a genre filter is specified, it will propagate down to for example the ArtistScreen,
  /// showing only tracks and albums of that artist that match the genre filter
  final BaseItemDto? genreFilter;

  // If this is true and the item is an album, the release year and album duration
  // will be shown as subtitle instead of the album artists
  final bool albumShowsYearAndDurationInstead;

  // If a SortBy is passed, the subtitle row in list view will display the matching
  // info (i.e. runtime or release date) before the actual default subtitle.
  final SortBy? showAdditionalInfoForSortBy;

  // If this is true, the red favorite icon that marks your favorites will
  // only be shown when the favorite filter on the MusicScreen is disabled
  // We want to always display the favorite indicator icon on other screens
  // so this defaults to false.
  final bool showFavoriteIconOnlyWhenFilterDisabled;

  @override
  ConsumerState<ItemCollectionWrapper> createState() => _ItemCollectionWrapperState();
}

class _ItemCollectionWrapperState extends ConsumerState<ItemCollectionWrapper> {
  late BaseItemDto mutableItem;

  QueueService get _queueService => GetIt.instance<QueueService>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();

  late Function() onTap;
  late AppLocalizations local;

  @override
  void initState() {
    super.initState();
    mutableItem = widget.item;

    // this is jank lol
    onTap = widget.onTap ??
        () {
          if (mutableItem.type == "MusicArtist") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ArtistScreen(
                  widgetArtist: mutableItem,
                  genreFilter: (ref.watch(finampSettingsProvider.genreFilterArtistScreens)) ? widget.genreFilter : null,
                ),
              ),
            );
          } else if (mutableItem.type == "MusicGenre") {
            Navigator.of(context)
                .pushNamed(GenreScreen.routeName, arguments: mutableItem);
          } else if (mutableItem.type == "Playlist") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AlbumScreen(
                  parent: mutableItem,
                  genreFilter: (ref.watch(finampSettingsProvider.genreFilterPlaylists)) ? widget.genreFilter : null,
                ),
              ),
            );
          } else {
            Navigator.of(context)
                .pushNamed(AlbumScreen.routeName, arguments: mutableItem);
          }
        };
  }

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;

    final screenSize = MediaQuery.of(context).size;
    final library = finampUserHelper.currentUser?.currentView;

    final itemType = BaseItemDtoType.fromItem(widget.item);
    final isArtistOrGenre = (itemType == BaseItemDtoType.artist ||
            itemType == BaseItemDtoType.genre);
    final itemDownloadStub = isArtistOrGenre
          ? DownloadStub.fromFinampCollection(
                FinampCollection(
                  type: FinampCollectionType.collectionWithLibraryFilter,
                  library: library,
                  item: widget.item
                )
            )
          : DownloadStub.fromItem(
                type: DownloadItemType.collection,
                item: widget.item
            );

    void menuCallback() async {
      unawaited(Feedback.forLongPress(context));

      final downloadsService = GetIt.instance<DownloadsService>();
      final canDeleteFromServer = ref
          .watch(_jellyfinApiHelper.canDeleteFromServerProvider(widget.item));
      final isOffline = ref.watch(finampSettingsProvider.isOffline);
      final downloadStatus = downloadsService.getStatus(
          itemDownloadStub,
          null);
      final albumArtistId = widget.item.albumArtists?.firstOrNull?.id ??
          widget.item.artistItems?.firstOrNull?.id;
      String itemType;

      switch (BaseItemDtoType.fromItem(widget.item)) {
        case BaseItemDtoType.artist:
          await showModalArtistMenu(context: context, baseItem: widget.item);
          break;
        case BaseItemDtoType.genre:
          await showModalGenreMenu(context: context, baseItem: widget.item);
          break;
        case BaseItemDtoType.playlist:
          await showModalPlaylistMenu(context: context, baseItem: widget.item);
          break;
        default:
          await showModalAlbumMenu(context: context, baseItem: widget.item);
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
            ? ItemCollectionCard(
                item: mutableItem,
                onTap: onTap,
                parentType: widget.parentType,
              )
            : ItemCollectionListTile(
                item: mutableItem,
                onTap: onTap,
                parentType: widget.parentType,
                albumShowsYearAndDurationInstead: widget.albumShowsYearAndDurationInstead,
                showAdditionalInfoForSortBy: widget.showAdditionalInfoForSortBy,
                showFavoriteIconOnlyWhenFilterDisabled: widget.showFavoriteIconOnlyWhenFilterDisabled,
              ),
      ),
    );
  }
}
