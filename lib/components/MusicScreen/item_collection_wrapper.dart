import 'dart:async';

import 'package:finamp/components/MusicScreen/item_collection_list_tile.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/artist_screen_provider.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/album_screen.dart';
import '../../screens/artist_screen.dart';
import '../../screens/genre_screen.dart';
import '../../services/downloads_service.dart';
import '../../services/favorite_provider.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AddToPlaylistScreen/playlist_actions_menu.dart';
import '../AlbumScreen/download_dialog.dart';
import '../global_snackbar.dart';
import 'item_collection_card.dart';

enum _ItemCollectionListTileMenuItems {
  addFavorite,
  removeFavorite,
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

    void menuCallback({
      required Offset localPosition,
      required Offset globalPosition,
    }) async {
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

      switch (widget.item.type) {
        case "MusicAlbum":
          itemType = "album";
          break;
        case "MusicArtist":
          itemType = "artist";
          break;
        case "MusicGenre":
          itemType = "genre";
          break;
        case "Playlist":
          itemType = "playlist";
          break;
        default:
          itemType = "album";
      }

      final selection = await showMenu<_ItemCollectionListTileMenuItems>(
        context: context,
        position: RelativeRect.fromLTRB(
          globalPosition.dx,
          globalPosition.dy,
          screenSize.width - globalPosition.dx,
          screenSize.height - globalPosition.dy,
        ),
        items: [
          ref.watch(isFavoriteProvider(mutableItem))
              ? PopupMenuItem<_ItemCollectionListTileMenuItems>(
                  enabled: !isOffline,
                  value: _ItemCollectionListTileMenuItems.removeFavorite,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.favorite_border),
                    title: Text(local.removeFavorite),
                  ),
                )
              : PopupMenuItem<_ItemCollectionListTileMenuItems>(
                  enabled: !isOffline,
                  value: _ItemCollectionListTileMenuItems.addFavorite,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.favorite),
                    title: Text(local.addFavorite),
                  ),
                ),
          _jellyfinApiHelper.selectedMixAlbums
                  .map((e) => e.id)
                  .contains(mutableItem.id)
              ? PopupMenuItem<_ItemCollectionListTileMenuItems>(
                  enabled: !isOffline &&
                      ["MusicAlbum", "MusicArtist", "MusicGenre"]
                          .contains(mutableItem.type),
                  value: _ItemCollectionListTileMenuItems.removeFromMixList,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.explore_off),
                    title: Text(local.removeFromMix),
                  ),
                )
              : PopupMenuItem<_ItemCollectionListTileMenuItems>(
                  enabled: !isOffline &&
                      ["MusicAlbum", "MusicArtist", "MusicGenre"]
                          .contains(mutableItem.type),
                  value: _ItemCollectionListTileMenuItems.addToMixList,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.explore),
                    title: Text(local.addToMix),
                  ),
                ),
          if (_queueService.getQueue().nextUp.isNotEmpty)
            PopupMenuItem<_ItemCollectionListTileMenuItems>(
              enabled: (BaseItemDtoType.fromItem(mutableItem) != BaseItemDtoType.genre),
              value: _ItemCollectionListTileMenuItems.playNext,
              child: ListTile(
                leading: const Icon(TablerIcons.corner_right_down),
                title: Text(local.playNext),
              ),
            ),
          PopupMenuItem<_ItemCollectionListTileMenuItems>(
            enabled: (BaseItemDtoType.fromItem(mutableItem) != BaseItemDtoType.genre),
            value: _ItemCollectionListTileMenuItems.addToNextUp,
            child: ListTile(
              leading: const Icon(TablerIcons.corner_right_down_double),
              title: Text(local.addToNextUp),
            ),
          ),
          if (_queueService.getQueue().nextUp.isNotEmpty)
            PopupMenuItem<_ItemCollectionListTileMenuItems>(
              enabled: (BaseItemDtoType.fromItem(mutableItem) != BaseItemDtoType.genre),
              value: _ItemCollectionListTileMenuItems.shuffleNext,
              child: ListTile(
                leading: const Icon(TablerIcons.corner_right_down),
                title: Text(local.shuffleNext),
              ),
            ),
          PopupMenuItem<_ItemCollectionListTileMenuItems>(
            enabled: (BaseItemDtoType.fromItem(mutableItem) != BaseItemDtoType.genre),
            value: _ItemCollectionListTileMenuItems.shuffleToNextUp,
            child: ListTile(
              leading: const Icon(TablerIcons.corner_right_down_double),
              title: Text(local.shuffleToNextUp),
            ),
          ),
          PopupMenuItem<_ItemCollectionListTileMenuItems>(
            enabled: (BaseItemDtoType.fromItem(mutableItem) != BaseItemDtoType.genre),
            value: _ItemCollectionListTileMenuItems.addToQueue,
            child: ListTile(
              leading: const Icon(TablerIcons.playlist),
              title: Text(local.addToQueue),
            ),
          ),
          PopupMenuItem<_ItemCollectionListTileMenuItems>(
            enabled: (BaseItemDtoType.fromItem(mutableItem) != BaseItemDtoType.genre),
            value: _ItemCollectionListTileMenuItems.shuffleToQueue,
            child: ListTile(
              leading: const Icon(TablerIcons.playlist),
              title: Text(local.shuffleToQueue),
            ),
          ),
          PopupMenuItem<_ItemCollectionListTileMenuItems>(
            value: _ItemCollectionListTileMenuItems.addToPlaylist,
            child: ListTile(
              leading: const Icon(Icons.playlist_add),
              title: Text(local.addToPlaylistTitle),
            ),
          ),
          downloadStatus.isRequired
              ? PopupMenuItem<_ItemCollectionListTileMenuItems>(
                  value: _ItemCollectionListTileMenuItems.deleteFromDevice,
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text(AppLocalizations.of(context)!
                        .deleteFromTargetConfirmButton("")),
                  ),
                )
              : PopupMenuItem<_ItemCollectionListTileMenuItems>(
                  enabled: !isOffline,
                  value: _ItemCollectionListTileMenuItems.download,
                  child: ListTile(
                    leading: const Icon(Icons.file_download),
                    title: Text(AppLocalizations.of(context)!.downloadItem),
                    enabled: !isOffline,
                  ),
                ),
          //TODO handle multiple artists
          // Only show goToArtist on albums, not artists/genres/playlists
          if (widget.item.type == "MusicAlbum" && albumArtistId != null)
            PopupMenuItem<_ItemCollectionListTileMenuItems>(
              value: _ItemCollectionListTileMenuItems.goToArtist,
              child: ListTile(
                leading: const Icon(TablerIcons.user),
                title: Text(AppLocalizations.of(context)!.goToArtist),
              ),
            ),
          if (canDeleteFromServer)
            PopupMenuItem<_ItemCollectionListTileMenuItems>(
              value: _ItemCollectionListTileMenuItems.deleteFromServer,
              enabled: canDeleteFromServer,
              child: ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: Text(AppLocalizations.of(context)!
                      .deleteFromTargetConfirmButton("server"))),
            ),
        ],
      );
      if (!context.mounted) return;
      
      final itemDtoType = BaseItemDtoType.fromItem(widget.item);

      switch (selection) {
        case _ItemCollectionListTileMenuItems.addFavorite:
          ref
              .read(isFavoriteProvider(mutableItem).notifier)
              .updateFavorite(true);
          break;
        case _ItemCollectionListTileMenuItems.removeFavorite:
          ref
              .read(isFavoriteProvider(mutableItem).notifier)
              .updateFavorite(false);
          break;
        case _ItemCollectionListTileMenuItems.addToMixList:
          try {
            if (mutableItem.type == "MusicArtist") {
              _jellyfinApiHelper.addArtistToMixBuilderList(mutableItem);
            } else if (mutableItem.type == "MusicAlbum") {
              _jellyfinApiHelper.addAlbumToMixBuilderList(mutableItem);
            } else if (mutableItem.type == "MusicGenre") {
              _jellyfinApiHelper.addGenreToMixBuilderList(mutableItem);
            }
            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ItemCollectionListTileMenuItems.removeFromMixList:
          try {
            if (mutableItem.type == "MusicArtist") {
              _jellyfinApiHelper.removeArtistFromMixBuilderList(mutableItem);
            } else if (mutableItem.type == "MusicAlbum") {
              _jellyfinApiHelper.removeAlbumFromMixBuilderList(mutableItem);
            } else if (mutableItem.type == "MusicGenre") {
              _jellyfinApiHelper.removeGenreFromMixBuilderList(mutableItem);
            }
            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ItemCollectionListTileMenuItems.playNext:
          try {
            List<BaseItemDto>? collectionTracks;
            if (itemDtoType == BaseItemDtoType.artist) {
              final artistTracks = await ref.read(getAllTracksProvider(
                widget.item, finampUserHelper.currentUser?.currentView,
                widget.genreFilter).future);
              collectionTracks = artistTracks;
            } else {
              if (isOffline) {
                collectionTracks = await downloadsService
                    .getCollectionTracks(widget.item, playable: true);
              } else {
                collectionTracks = await _jellyfinApiHelper.getItems(
                  parentItem: mutableItem,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );
              }
            }

            if (collectionTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addNext(
                items: collectionTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.nextUpPlaylist
                      : (itemDtoType == BaseItemDtoType.artist) 
                        ? QueueItemSourceType.nextUpArtist
                        : (itemDtoType == BaseItemDtoType.genre)
                          ? QueueItemSourceType.nextUpGenre
                          : QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableItem.name ?? local.placeholderSource),
                  id: mutableItem.id,
                  item: mutableItem,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableItem.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) =>
                    AppLocalizations.of(scaffold)!.confirmPlayNext(itemType),
                isConfirmation: true);

            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ItemCollectionListTileMenuItems.addToNextUp:
          try {
            List<BaseItemDto>? collectionTracks;
            if (BaseItemDtoType.fromItem(widget.item) == BaseItemDtoType.artist) {
              final artistTracks = await ref.read(getAllTracksProvider(
                widget.item, finampUserHelper.currentUser?.currentView,
                widget.genreFilter).future);
              collectionTracks = artistTracks;
            } else {
              if (isOffline) {
                collectionTracks = await downloadsService
                    .getCollectionTracks(widget.item, playable: true);
              } else {
                collectionTracks = await _jellyfinApiHelper.getItems(
                  parentItem: mutableItem,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );
              }
            }

            if (collectionTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addToNextUp(
                items: collectionTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.nextUpPlaylist
                      : (itemDtoType == BaseItemDtoType.artist) 
                        ? QueueItemSourceType.nextUpArtist
                        : (itemDtoType == BaseItemDtoType.genre)
                          ? QueueItemSourceType.nextUpGenre
                          : QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableItem.name ?? local.placeholderSource),
                  id: mutableItem.id,
                  item: mutableItem,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableItem.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) =>
                    AppLocalizations.of(scaffold)!.confirmAddToNextUp(itemType),
                isConfirmation: true);

            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ItemCollectionListTileMenuItems.shuffleNext:
          try {
            List<BaseItemDto>? collectionTracks;
            if (BaseItemDtoType.fromItem(widget.item) == BaseItemDtoType.artist) {
              final artistTracks = await ref.read(getAllTracksProvider(
                widget.item, finampUserHelper.currentUser?.currentView,
                widget.genreFilter).future);
              collectionTracks = artistTracks;
              collectionTracks.shuffle();
            } else {
              if (isOffline) {
                collectionTracks = await downloadsService
                    .getCollectionTracks(widget.item, playable: true);
                collectionTracks.shuffle();
              } else {
                collectionTracks = await _jellyfinApiHelper.getItems(
                  parentItem: mutableItem,
                  sortBy: "Random",
                  includeItemTypes: "Audio",
                );
              }
            }

            if (collectionTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addNext(
                items: collectionTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.nextUpPlaylist
                      : (itemDtoType == BaseItemDtoType.artist) 
                        ? QueueItemSourceType.nextUpArtist
                        : (itemDtoType == BaseItemDtoType.genre)
                          ? QueueItemSourceType.nextUpGenre
                          : QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableItem.name ?? local.placeholderSource),
                  id: mutableItem.id,
                  item: mutableItem,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableItem.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) =>
                    AppLocalizations.of(scaffold)!.confirmPlayNext(itemType),
                isConfirmation: true);

            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ItemCollectionListTileMenuItems.shuffleToNextUp:
          try {
            List<BaseItemDto>? collectionTracks;
            if (BaseItemDtoType.fromItem(widget.item) == BaseItemDtoType.artist) {
              final artistTracks = await ref.read(getAllTracksProvider(
                widget.item, finampUserHelper.currentUser?.currentView,
                widget.genreFilter).future);
              collectionTracks = artistTracks;
              collectionTracks.shuffle();
            } else {
              if (isOffline) {
                collectionTracks = await downloadsService
                    .getCollectionTracks(widget.item, playable: true);
                collectionTracks.shuffle();
              } else {
                collectionTracks = await _jellyfinApiHelper.getItems(
                  parentItem: mutableItem,
                  sortBy: "Random",
                  includeItemTypes: "Audio",
                );
              }
            }

            if (collectionTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addToNextUp(
                items: collectionTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.nextUpPlaylist
                      : (itemDtoType == BaseItemDtoType.artist) 
                        ? QueueItemSourceType.nextUpArtist
                        : (itemDtoType == BaseItemDtoType.genre)
                          ? QueueItemSourceType.nextUpGenre
                          : QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableItem.name ?? local.placeholderSource),
                  id: mutableItem.id,
                  item: mutableItem,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableItem.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) =>
                    AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
                isConfirmation: true);

            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ItemCollectionListTileMenuItems.addToQueue:
          try {
            List<BaseItemDto>? collectionTracks;
            if (BaseItemDtoType.fromItem(widget.item) == BaseItemDtoType.artist) {
              final artistTracks = await ref.read(getAllTracksProvider(
                widget.item, finampUserHelper.currentUser?.currentView,
                widget.genreFilter).future);
              collectionTracks = artistTracks;
            } else {
              if (isOffline) {
                collectionTracks = await downloadsService
                    .getCollectionTracks(widget.item, playable: true);
              } else {
                collectionTracks = await _jellyfinApiHelper.getItems(
                  parentItem: mutableItem,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );
              }
            }

            if (collectionTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addToQueue(
                items: collectionTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.playlist
                      : (itemDtoType == BaseItemDtoType.artist) 
                        ? QueueItemSourceType.artist
                        : (itemDtoType == BaseItemDtoType.genre)
                          ? QueueItemSourceType.genre
                          : QueueItemSourceType.album,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableItem.name ?? local.placeholderSource),
                  id: mutableItem.id,
                  item: mutableItem,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableItem.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) =>
                    AppLocalizations.of(scaffold)!.confirmAddToQueue(itemType),
                isConfirmation: true);

            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ItemCollectionListTileMenuItems.shuffleToQueue:
          try {
            List<BaseItemDto>? collectionTracks;
            if (BaseItemDtoType.fromItem(widget.item) == BaseItemDtoType.artist) {
              final artistTracks = await ref.read(getAllTracksProvider(
                widget.item, finampUserHelper.currentUser?.currentView,
                widget.genreFilter).future);
              collectionTracks = artistTracks;
              collectionTracks.shuffle();
            } else {
              if (isOffline) {
                collectionTracks = await downloadsService
                    .getCollectionTracks(widget.item, playable: true);
                collectionTracks.shuffle();
              } else {
                collectionTracks = await _jellyfinApiHelper.getItems(
                  parentItem: mutableItem,
                  sortBy: "Random",
                  includeItemTypes: "Audio",
                );
              }
            }

            if (collectionTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addToQueue(
                items: collectionTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.playlist
                      : (itemDtoType == BaseItemDtoType.artist) 
                        ? QueueItemSourceType.artist
                        : (itemDtoType == BaseItemDtoType.genre)
                          ? QueueItemSourceType.genre
                          : QueueItemSourceType.album,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableItem.name ?? local.placeholderSource),
                  id: mutableItem.id,
                  item: mutableItem,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableItem.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) =>
                    AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
                isConfirmation: true);

            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ItemCollectionListTileMenuItems.goToArtist:
          late BaseItemDto artist;
          try {
            if (FinampSettingsHelper.finampSettings.isOffline) {
              final downloadsService = GetIt.instance<DownloadsService>();
              artist = (await downloadsService.getCollectionInfo(
                      id: albumArtistId!))!
                  .baseItem!;
            } else {
              artist = await _jellyfinApiHelper.getItemById(albumArtistId!);
            }
          } catch (e) {
            GlobalSnackbar.error(e);
            return;
          }
          if (context.mounted) {
            await Navigator.of(context)
                .pushNamed(ArtistScreen.routeName, arguments: artist);
          }
        case null:
          break;
        case _ItemCollectionListTileMenuItems.download:
          await DownloadDialog.show(context, itemDownloadStub, null);
        case _ItemCollectionListTileMenuItems.deleteFromDevice:
          await askBeforeDeleteDownloadFromDevice(context, itemDownloadStub);
        case _ItemCollectionListTileMenuItems.deleteFromServer:
          await askBeforeDeleteFromServerAndDevice(context, itemDownloadStub,
              refresh: () => musicScreenRefreshStream
                  .add(null)); // trigger a refresh of the music screen
        case _ItemCollectionListTileMenuItems.addToPlaylist:
          if (context.mounted) {
            await showPlaylistActionsMenu(
              context: context,
              item: widget.item,
              parentPlaylist: null,
            );
          }
      }
    }

    return Padding(
      padding: widget.isGrid
          ? Theme.of(context).cardTheme.margin ?? const EdgeInsets.all(4.0)
          : EdgeInsets.zero,
      child: GestureDetector(
        onLongPressStart: (details) => menuCallback(
            localPosition: details.localPosition,
            globalPosition: details.globalPosition),
        onSecondaryTapDown: (details) => menuCallback(
            localPosition: details.localPosition,
            globalPosition: details.globalPosition),
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
