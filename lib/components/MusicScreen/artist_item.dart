import 'dart:async';

import 'package:finamp/components/AlbumScreen/download_dialog.dart';
import 'package:finamp/components/MusicScreen/artist_item_card.dart';
import 'package:finamp/components/MusicScreen/artist_item_list_tile.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/menus/playlist_actions_menu.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/favorite_provider.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

enum _ArtistListTileMenuItems {
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
  deleteFromServer,
  addToPlaylist,
}

class ArtistItem extends ConsumerStatefulWidget {
  const ArtistItem({
    super.key,
    required this.artist,
    this.parentType,
    this.onTap,
    this.isGrid = false,
    this.gridAddSettingsListener = false,
  });

  /// The album (or item, I just used to call items albums before Finamp
  /// supported other types) to show in the widget.
  final BaseItemDto artist;

  /// The parent type of the item. Used to change onTap functionality for stuff
  /// like artists.
  final String? parentType;

  /// A custom onTap can be provided to override the default value, which is to
  /// open the item's album/artist screen.
  final void Function()? onTap;

  /// If specified, use cards instead of list tiles. Use this if you want to use
  /// this widget in a grid view.
  final bool isGrid;

  /// If true, the grid item will use a ValueListenableBuilder to check whether
  /// or not to show the text. You'll want to set this to false if the
  /// [ArtistItem] would be rebuilt by FinampSettings anyway.
  final bool gridAddSettingsListener;

  @override
  ConsumerState<ArtistItem> createState() => _ArtistItemState();
}

class _ArtistItemState extends ConsumerState<ArtistItem> {
  late BaseItemDto mutableArtist;

  late VoidCallback onTap;
  late AppLocalizations local;

  @override
  void initState() {
    super.initState();
    mutableArtist = widget.artist;

    onTap = widget.onTap ??
        () => Navigator.of(context)
            .pushNamed(ArtistScreen.routeName, arguments: mutableArtist);
  }

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _queueService = GetIt.instance<QueueService>();
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
          .watch(_jellyfinApiHelper.canDeleteFromServerProvider(widget.artist));
      final isOffline = ref.watch(finampSettingsProvider.isOffline);
      final downloadStatus = downloadsService.getStatus(
          DownloadStub.fromItem(
              type: DownloadItemType.collection, item: widget.artist),
          null);
      String itemType = "artist";

      final selection = await showMenu<_ArtistListTileMenuItems>(
        context: context,
        position: RelativeRect.fromLTRB(
          globalPosition.dx,
          globalPosition.dy,
          screenSize.width - globalPosition.dx,
          screenSize.height - globalPosition.dy,
        ),
        items: [
          ref.watch(isFavoriteProvider(mutableArtist))
              ? PopupMenuItem<_ArtistListTileMenuItems>(
                  enabled: !isOffline,
                  value: _ArtistListTileMenuItems.removeFavourite,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.favorite_border),
                    title: Text(local.removeFavorite),
                  ),
                )
              : PopupMenuItem<_ArtistListTileMenuItems>(
                  enabled: !isOffline,
                  value: _ArtistListTileMenuItems.addFavourite,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.favorite),
                    title: Text(local.addFavorite),
                  ),
                ),
          _jellyfinApiHelper.selectedMixArtists
                  .map((e) => e.id)
                  .contains(mutableArtist.id)
              ? PopupMenuItem<_ArtistListTileMenuItems>(
                  enabled: !isOffline,
                  value: _ArtistListTileMenuItems.removeFromMixList,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.explore_off),
                    title: Text(local.removeFromMix),
                  ),
                )
              : PopupMenuItem<_ArtistListTileMenuItems>(
                  enabled: !isOffline,
                  value: _ArtistListTileMenuItems.addToMixList,
                  child: ListTile(
                    enabled: !isOffline,
                    leading: const Icon(Icons.explore),
                    title: Text(local.addToMix),
                  ),
                ),
          if (_queueService.getQueue().nextUp.isNotEmpty)
            PopupMenuItem<_ArtistListTileMenuItems>(
              value: _ArtistListTileMenuItems.playNext,
              child: ListTile(
                leading: const Icon(TablerIcons.corner_right_down),
                title: Text(local.playNext),
              ),
            ),
          PopupMenuItem<_ArtistListTileMenuItems>(
            value: _ArtistListTileMenuItems.addToNextUp,
            child: ListTile(
              leading: const Icon(TablerIcons.corner_right_down_double),
              title: Text(local.addToNextUp),
            ),
          ),
          if (_queueService.getQueue().nextUp.isNotEmpty)
            PopupMenuItem<_ArtistListTileMenuItems>(
              value: _ArtistListTileMenuItems.shuffleNext,
              child: ListTile(
                leading: const Icon(TablerIcons.corner_right_down),
                title: Text(local.shuffleNext),
              ),
            ),
          PopupMenuItem<_ArtistListTileMenuItems>(
            value: _ArtistListTileMenuItems.shuffleToNextUp,
            child: ListTile(
              leading: const Icon(TablerIcons.corner_right_down_double),
              title: Text(local.shuffleToNextUp),
            ),
          ),
          PopupMenuItem<_ArtistListTileMenuItems>(
            value: _ArtistListTileMenuItems.addToQueue,
            child: ListTile(
              leading: const Icon(TablerIcons.playlist),
              title: Text(local.addToQueue),
            ),
          ),
          PopupMenuItem<_ArtistListTileMenuItems>(
            value: _ArtistListTileMenuItems.shuffleToQueue,
            child: ListTile(
              leading: const Icon(TablerIcons.playlist),
              title: Text(local.shuffleToQueue),
            ),
          ),
          PopupMenuItem<_ArtistListTileMenuItems>(
            value: _ArtistListTileMenuItems.addToPlaylist,
            child: ListTile(
              leading: const Icon(Icons.playlist_add),
              title: Text(local.addToPlaylistTitle),
            ),
          ),
          downloadStatus.isRequired
              ? PopupMenuItem<_ArtistListTileMenuItems>(
                  value: _ArtistListTileMenuItems.deleteFromDevice,
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text(AppLocalizations.of(context)!
                        .deleteFromTargetConfirmButton("")),
                  ),
                )
              : PopupMenuItem<_ArtistListTileMenuItems>(
                  enabled: !isOffline,
                  value: _ArtistListTileMenuItems.download,
                  child: ListTile(
                    leading: const Icon(Icons.file_download),
                    title: Text(AppLocalizations.of(context)!.downloadItem),
                    enabled: !isOffline,
                  ),
                ),
          if (canDeleteFromServer)
            PopupMenuItem<_ArtistListTileMenuItems>(
              value: _ArtistListTileMenuItems.deleteFromServer,
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
        case _ArtistListTileMenuItems.addFavourite:
          ref
              .read(isFavoriteProvider(mutableArtist).notifier)
              .updateFavorite(true);
          break;
        case _ArtistListTileMenuItems.removeFavourite:
          ref
              .read(isFavoriteProvider(mutableArtist).notifier)
              .updateFavorite(false);
          break;
        case _ArtistListTileMenuItems.addToMixList:
          try {
            _jellyfinApiHelper.addArtistToMixBuilderList(mutableArtist);
            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ArtistListTileMenuItems.removeFromMixList:
          try {
            _jellyfinApiHelper.removeArtistFromMixBuilderList(mutableArtist);
            setState(() {});
          } catch (e) {
            GlobalSnackbar.error(e);
          }
          break;
        case _ArtistListTileMenuItems.playNext:
          try {
            List<BaseItemDto>? artistTracks;
            if (isOffline) {
              artistTracks = await downloadsService
                  .getCollectionTracks(widget.artist, playable: true);
            } else {
              artistTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableArtist,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (artistTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addNext(
                items: artistTracks,
                source: QueueItemSource(
                  type: QueueItemSourceType.nextUpArtist,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableArtist.name ?? local.placeholderSource),
                  id: mutableArtist.id,
                  item: mutableArtist,
                  contextNormalizationGain: null,
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
        case _ArtistListTileMenuItems.addToNextUp:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.artist, playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableArtist,
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
                  type: QueueItemSourceType.nextUpArtist,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableArtist.name ?? local.placeholderSource),
                  id: mutableArtist.id,
                  item: mutableArtist,
                  contextNormalizationGain: null,
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
        case _ArtistListTileMenuItems.shuffleNext:
          try {
            List<BaseItemDto>? artistTracks;
            if (isOffline) {
              artistTracks = await downloadsService
                  .getCollectionTracks(widget.artist, playable: true);
              artistTracks.shuffle();
            } else {
              artistTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableArtist,
                sortBy: "Random",
                includeItemTypes: "Audio",
              );
            }

            if (artistTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(itemType));
              return;
            }

            await _queueService.addNext(
                items: artistTracks,
                source: QueueItemSource(
                  type: QueueItemSourceType.nextUpArtist,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableArtist.name ?? local.placeholderSource),
                  id: mutableArtist.id,
                  item: mutableArtist,
                  contextNormalizationGain: null,
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
        case _ArtistListTileMenuItems.shuffleToNextUp:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.artist, playable: true);
              albumTracks.shuffle();
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableArtist,
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
                  type: QueueItemSourceType.nextUpArtist,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableArtist.name ?? local.placeholderSource),
                  id: mutableArtist.id,
                  item: mutableArtist,
                  contextNormalizationGain: null,
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
        case _ArtistListTileMenuItems.addToQueue:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.artist, playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableArtist,
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
                  type: QueueItemSourceType.artist,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableArtist.name ?? local.placeholderSource),
                  id: mutableArtist.id,
                  item: mutableArtist,
                  contextNormalizationGain: null,
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
        case _ArtistListTileMenuItems.shuffleToQueue:
          try {
            List<BaseItemDto>? albumTracks;
            if (isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.artist, playable: true);
              albumTracks.shuffle();
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: mutableArtist,
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
                  type: QueueItemSourceType.artist,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName:
                          mutableArtist.name ?? local.placeholderSource),
                  id: mutableArtist.id,
                  item: mutableArtist,
                  contextNormalizationGain: null,
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
        case _ArtistListTileMenuItems.download:
          var item = DownloadStub.fromItem(
              type: DownloadItemType.collection, item: widget.artist);
          await DownloadDialog.show(context, item, null);
        case _ArtistListTileMenuItems.deleteFromDevice:
          var item = DownloadStub.fromItem(
              type: DownloadItemType.collection, item: widget.artist);
          await askBeforeDeleteDownloadFromDevice(context, item);
        case _ArtistListTileMenuItems.deleteFromServer:
          var item = DownloadStub.fromItem(
              type: DownloadItemType.collection, item: widget.artist);
          await askBeforeDeleteFromServerAndDevice(context, item,
              refresh: () => musicScreenRefreshStream
                  .add(null)); // trigger a refresh of the music screen
        case _ArtistListTileMenuItems.addToPlaylist:
          if (context.mounted) {
            await showPlaylistActionsMenu(
              context: context,
              items: [widget.artist],
              parentPlaylist: null,
            );
          }
        case null:
          break;
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
            ? ArtistItemCard(
                item: mutableArtist,
                onTap: onTap,
                addSettingsListener: widget.gridAddSettingsListener,
              )
            : ArtistItemListTile(
                item: mutableArtist,
                onTap: onTap,
                parentType: widget.parentType,
              ),
      ),
    );
  }
}
