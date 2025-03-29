import 'dart:async';

import 'package:finamp/components/MusicScreen/album_item_list_tile.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/album_screen.dart';
import '../../screens/artist_screen.dart';
import '../../services/downloads_service.dart';
import '../../services/favorite_provider.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AddToPlaylistScreen/playlist_actions_menu.dart';
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
    this.gridAddSettingsListener = false,
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

  /// If true, the grid item will use a ValueListenableBuilder to check whether
  /// or not to show the text. You'll want to set this to false if the
  /// [AlbumItem] would be rebuilt by FinampSettings anyway.
  final bool gridAddSettingsListener;

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

    void menuCallback({
      required Offset localPosition,
      required Offset globalPosition,
    }) async {
      unawaited(Feedback.forLongPress(context));

      final downloadsService = GetIt.instance<DownloadsService>();
      final canDeleteFromServer = ref
          .watch(_jellyfinApiHelper.canDeleteFromServerProvider(widget.album));
      final isOffline = ref.watch(finampSettingsProvider.isOffline);
      final downloadStatus = downloadsService.getStatus(
          DownloadStub.fromItem(
              type: DownloadItemType.collection, item: widget.album),
          null);
      final albumArtistId = widget.album.albumArtists?.firstOrNull?.id ??
          widget.album.artistItems?.firstOrNull?.id;
      String itemType;

      switch (widget.album.type) {
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

      final selection = await showMenu<_AlbumListTileMenuItems>(
        context: context,
        position: RelativeRect.fromLTRB(
          globalPosition.dx,
          globalPosition.dy,
          screenSize.width - globalPosition.dx,
          screenSize.height - globalPosition.dy,
        ),
        items: [
          ref.watch(isFavoriteProvider(mutableAlbum))
              ? PopupMenuItem<_AlbumListTileMenuItems>(
                  enabled: !isOffline,
                  value: _AlbumListTileMenuItems.removeFavourite,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.favorite_border),
                    title: Text(local.removeFavourite),
                  ),
                )
              : PopupMenuItem<_AlbumListTileMenuItems>(
                  enabled: !isOffline,
                  value: _AlbumListTileMenuItems.addFavourite,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.favorite),
                    title: Text(local.addFavourite),
                  ),
                ),
          _jellyfinApiHelper.selectedMixAlbums
                  .map((e) => e.id)
                  .contains(mutableAlbum.id)
              ? PopupMenuItem<_AlbumListTileMenuItems>(
                  enabled: !isOffline &&
                      ["MusicAlbum", "MusicArtist", "MusicGenre"]
                          .contains(mutableAlbum.type),
                  value: _AlbumListTileMenuItems.removeFromMixList,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.explore_off),
                    title: Text(local.removeFromMix),
                  ),
                )
              : PopupMenuItem<_AlbumListTileMenuItems>(
                  enabled: !isOffline &&
                      ["MusicAlbum", "MusicArtist", "MusicGenre"]
                          .contains(mutableAlbum.type),
                  value: _AlbumListTileMenuItems.addToMixList,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.explore),
                    title: Text(local.addToMix),
                  ),
                ),
          if (_queueService.getQueue().nextUp.isNotEmpty)
            PopupMenuItem<_AlbumListTileMenuItems>(
              value: _AlbumListTileMenuItems.playNext,
              child: ListTile(
                leading: const Icon(TablerIcons.corner_right_down),
                title: Text(local.playNext),
              ),
            ),
          PopupMenuItem<_AlbumListTileMenuItems>(
            value: _AlbumListTileMenuItems.addToNextUp,
            child: ListTile(
              leading: const Icon(TablerIcons.corner_right_down_double),
              title: Text(local.addToNextUp),
            ),
          ),
          if (_queueService.getQueue().nextUp.isNotEmpty)
            PopupMenuItem<_AlbumListTileMenuItems>(
              value: _AlbumListTileMenuItems.shuffleNext,
              child: ListTile(
                leading: const Icon(TablerIcons.corner_right_down),
                title: Text(local.shuffleNext),
              ),
            ),
          PopupMenuItem<_AlbumListTileMenuItems>(
            value: _AlbumListTileMenuItems.shuffleToNextUp,
            child: ListTile(
              leading: const Icon(TablerIcons.corner_right_down_double),
              title: Text(local.shuffleToNextUp),
            ),
          ),
          PopupMenuItem<_AlbumListTileMenuItems>(
            value: _AlbumListTileMenuItems.addToQueue,
            child: ListTile(
              leading: const Icon(TablerIcons.playlist),
              title: Text(local.addToQueue),
            ),
          ),
          PopupMenuItem<_AlbumListTileMenuItems>(
            value: _AlbumListTileMenuItems.shuffleToQueue,
            child: ListTile(
              leading: const Icon(TablerIcons.playlist),
              title: Text(local.shuffleToQueue),
            ),
          ),
          PopupMenuItem<_AlbumListTileMenuItems>(
            value: _AlbumListTileMenuItems.addToPlaylist,
            child: ListTile(
              leading: const Icon(Icons.playlist_add),
              title: Text(local.addToPlaylistTitle),
            ),
          ),
          downloadStatus.isRequired
              ? PopupMenuItem<_AlbumListTileMenuItems>(
                  value: _AlbumListTileMenuItems.deleteFromDevice,
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text(AppLocalizations.of(context)!
                        .deleteFromTargetConfirmButton("")),
                  ),
                )
              : PopupMenuItem<_AlbumListTileMenuItems>(
                  enabled: !isOffline,
                  value: _AlbumListTileMenuItems.download,
                  child: ListTile(
                    leading: const Icon(Icons.file_download),
                    title: Text(AppLocalizations.of(context)!.downloadItem),
                    enabled: !isOffline,
                  ),
                ),
          //TODO handle multiple artists
          // Only show goToArtist on albums, not artists/genres/playlists
          if (widget.album.type == "MusicAlbum" && albumArtistId != null)
            PopupMenuItem<_AlbumListTileMenuItems>(
              value: _AlbumListTileMenuItems.goToArtist,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(AppLocalizations.of(context)!.goToArtist),
              ),
            ),
          if (canDeleteFromServer)
            PopupMenuItem<_AlbumListTileMenuItems>(
              value: _AlbumListTileMenuItems.deleteFromServer,
              enabled: canDeleteFromServer,
              child: ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: Text(AppLocalizations.of(context)!
                      .deleteFromTargetConfirmButton("server"))),
            ),
        ],
      );
      if (!context.mounted) return;

      switch (selection) {
        case _AlbumListTileMenuItems.addFavourite:
          ref
              .read(isFavoriteProvider(mutableAlbum).notifier)
              .updateFavorite(true);
          break;
        case _AlbumListTileMenuItems.removeFavourite:
          ref
              .read(isFavoriteProvider(mutableAlbum).notifier)
              .updateFavorite(false);
          break;
        case _AlbumListTileMenuItems.addToMixList:
          try {
            if (mutableAlbum.type == "MusicArtist") {
              _jellyfinApiHelper.addArtistToMixBuilderList(mutableAlbum);
            } else if (mutableAlbum.type == "MusicAlbum") {
              _jellyfinApiHelper.addAlbumToMixBuilderList(mutableAlbum);
            } else if (mutableAlbum.type == "MusicGenre") {
              _jellyfinApiHelper.addGenreToMixBuilderList(mutableAlbum);
            }
            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _AlbumListTileMenuItems.removeFromMixList:
          try {
            if (mutableAlbum.type == "MusicArtist") {
              _jellyfinApiHelper.removeArtistFromMixBuilderList(mutableAlbum);
            } else if (mutableAlbum.type == "MusicAlbum") {
              _jellyfinApiHelper.removeAlbumFromMixBuilderList(mutableAlbum);
            }
            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _AlbumListTileMenuItems.playNext:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.album, playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableAlbum,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addNext(
                items: albumTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.nextUpPlaylist
                      : QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableAlbum.name ?? local.placeholderSource),
                  id: mutableAlbum.id,
                  item: mutableAlbum,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableAlbum.normalizationGain,
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
        case _AlbumListTileMenuItems.addToNextUp:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.album, playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableAlbum,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addToNextUp(
                items: albumTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.nextUpPlaylist
                      : QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableAlbum.name ?? local.placeholderSource),
                  id: mutableAlbum.id,
                  item: mutableAlbum,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableAlbum.normalizationGain,
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
        case _AlbumListTileMenuItems.shuffleNext:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.album, playable: true);
              albumTracks.shuffle();
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableAlbum,
                sortBy: "Random",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addNext(
                items: albumTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.nextUpPlaylist
                      : QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableAlbum.name ?? local.placeholderSource),
                  id: mutableAlbum.id,
                  item: mutableAlbum,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableAlbum.normalizationGain,
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
        case _AlbumListTileMenuItems.shuffleToNextUp:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.album, playable: true);
              albumTracks.shuffle();
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableAlbum,
                sortBy: "Random",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addToNextUp(
                items: albumTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.nextUpPlaylist
                      : QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableAlbum.name ?? local.placeholderSource),
                  id: mutableAlbum.id,
                  item: mutableAlbum,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableAlbum.normalizationGain,
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
        case _AlbumListTileMenuItems.addToQueue:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.album, playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableAlbum,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addToQueue(
                items: albumTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.playlist
                      : QueueItemSourceType.album,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableAlbum.name ?? local.placeholderSource),
                  id: mutableAlbum.id,
                  item: mutableAlbum,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableAlbum.normalizationGain,
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
        case _AlbumListTileMenuItems.shuffleToQueue:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.album, playable: true);
              albumTracks.shuffle();
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableAlbum,
                sortBy: "Random",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addToQueue(
                items: albumTracks,
                source: QueueItemSource(
                  type: widget.isPlaylist
                      ? QueueItemSourceType.playlist
                      : QueueItemSourceType.album,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableAlbum.name ?? local.placeholderSource),
                  id: mutableAlbum.id,
                  item: mutableAlbum,
                  contextNormalizationGain:
                      widget.isPlaylist ? null : mutableAlbum.normalizationGain,
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
        case _AlbumListTileMenuItems.goToArtist:
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
        case _AlbumListTileMenuItems.download:
          var item = DownloadStub.fromItem(
              type: DownloadItemType.collection, item: widget.album);
          await DownloadDialog.show(context, item, null);
        case _AlbumListTileMenuItems.deleteFromDevice:
          var item = DownloadStub.fromItem(
              type: DownloadItemType.collection, item: widget.album);
          await askBeforeDeleteDownloadFromDevice(context, item);
        case _AlbumListTileMenuItems.deleteFromServer:
          var item = DownloadStub.fromItem(
              type: DownloadItemType.collection, item: widget.album);
          await askBeforeDeleteFromServerAndDevice(context, item,
              refresh: () => musicScreenRefreshStream
                  .add(null)); // trigger a refresh of the music screen
        case _AlbumListTileMenuItems.addToPlaylist:
          if (context.mounted) {
            await showPlaylistActionsMenu(
              context: context,
              item: widget.album,
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
            ? AlbumItemCard(
                item: mutableAlbum,
                onTap: onTap,
                parentType: widget.parentType,
                addSettingsListener: widget.gridAddSettingsListener,
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
