import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:Finamp/components/AlbumScreen/song_menu.dart';
import 'package:Finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:Finamp/components/global_snackbar.dart';
import 'package:Finamp/models/finamp_models.dart';
import 'package:Finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:Finamp/services/finamp_user_helper.dart';
import 'package:Finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';

import '../../services/audio_service_helper.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/music_player_background_task.dart';
import '../../services/process_artist.dart';
import '../../services/theme_provider.dart';
import '../album_image.dart';
import '../favourite_button.dart';
import '../print_duration.dart';
import 'downloaded_indicator.dart';

enum SongListTileMenuItems {
  addToQueue,
  playNext,
  addToNextUp,
  addToPlaylist,
  removeFromPlaylist,
  instantMix,
  goToAlbum,
  addFavourite,
  removeFavourite,
  download,
  delete,
}

class SongListTile extends ConsumerStatefulWidget {
  const SongListTile({
    super.key,
    required this.item,

    /// Children that are related to this list tile, such as the other songs in
    /// the album. This is used to give the audio service all the songs for the
    /// item. If null, only this song will be given to the audio service.
    this.children,

    /// Index of the song in whatever parent this widget is in. Used to start
    /// the audio service at a certain index, such as when selecting the middle
    /// song in an album.  Will be -1 if we are offline and the song is not downloaded.
    this.index,
    this.parentItem,

    /// Whether we are in the songs tab, as opposed to a playlist/album
    this.isSong = false,
    this.showArtists = true,
    this.onRemoveFromList,
    this.showPlayCount = false,

    /// Whether this widget is being displayed in a playlist. If true, will show
    /// the remove from playlist button.
    this.isInPlaylist = false,
    this.isOnArtistScreen = false,
    this.isShownInSearch = false,
  });

  final jellyfin_models.BaseItemDto item;
  final Future<List<jellyfin_models.BaseItemDto>>? children;
  final Future<int>? index;
  final bool isSong;
  final jellyfin_models.BaseItemDto? parentItem;
  final bool showArtists;
  final VoidCallback? onRemoveFromList;
  final bool showPlayCount;
  final bool isInPlaylist;
  final bool isOnArtistScreen;
  final bool isShownInSearch;

  @override
  ConsumerState<SongListTile> createState() => _SongListTileState();
}

class _SongListTileState extends ConsumerState<SongListTile>
    with SingleTickerProviderStateMixin {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _queueService = GetIt.instance<QueueService>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  FinampTheme? _menuTheme;

  @override
  void dispose() {
    _menuTheme?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool playable;
    if (FinampSettingsHelper.finampSettings.isOffline) {
      playable = ref.watch(GetIt.instance<DownloadsService>()
          .stateProvider(DownloadStub.fromItem(
              type: DownloadItemType.song, item: widget.item))
          .select((value) => value.value?.isComplete ?? false));
    } else {
      playable = true;
    }

    final listTile = StreamBuilder<MediaItem?>(
        stream: _audioHandler.mediaItem,
        builder: (context, snapshot) {
          // I think past me did this check directly from the JSON for
          // performance. It works for now, apologies if you're debugging it
          // years in the future.
          final isCurrentlyPlaying =
              snapshot.data?.extras?["itemJson"]["Id"] == widget.item.id &&
                  snapshot.data?.extras?["itemJson"]["AlbumId"] ==
                      widget.parentItem?.id;

          return ListTile(
            leading: AlbumImage(
              item: widget.item,
              disabled: !playable,
              themeCallback: (x) => _menuTheme ??= x,
            ),
            title: Opacity(
              opacity: playable ? 1.0 : 0.5,
              child: RichText(
                text: TextSpan(
                  children: [
                    // third condition checks if the item is viewed from its album (instead of e.g. a playlist)
                    // same horrible check as in canGoToAlbum in GestureDetector below
                    if (widget.item.indexNumber != null &&
                        !widget.isSong &&
                        widget.item.albumId == widget.parentItem?.id)
                      TextSpan(
                          text: "${widget.item.indexNumber}. ",
                          style: TextStyle(
                              color: Theme.of(context).disabledColor)),
                    TextSpan(
                      text: widget.item.name ??
                          AppLocalizations.of(context)!.unknownName,
                      style: TextStyle(
                        color: isCurrentlyPlaying
                            ? Theme.of(context).colorScheme.secondary
                            : null,
                      ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            subtitle: Opacity(
              opacity: playable ? 1.0 : 0.5,
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(-3, 0),
                        child: DownloadedIndicator(
                          item: DownloadStub.fromItem(
                              item: widget.item, type: DownloadItemType.song),
                          size: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize! +
                              3,
                        ),
                      ),
                      alignment: PlaceholderAlignment.top,
                    ),
                    TextSpan(
                      text: printDuration(widget.item.runTimeTicksDuration()),
                      style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7)),
                    ),
                    if (widget.showArtists)
                      TextSpan(
                        text:
                            " · ${processArtist(widget.item.artists?.join(", ") ?? widget.item.albumArtist, context)}",
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                      ),
                    if (widget.showPlayCount)
                      TextSpan(
                        text:
                            " · ${AppLocalizations.of(context)!.playCountValue(widget.item.userData?.playCount ?? 0)}",
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                      ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCurrentlyPlaying)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: MiniMusicVisualizer(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 4,
                      height: 15,
                    ),
                  ),
                FavoriteButton(
                  item: widget.item,
                  onlyIfFav: true,
                ),
              ],
            ),
          );
        });

    void menuCallback() async {
      if (playable) {
        unawaited(Feedback.forLongPress(context));
        await showModalSongMenu(
          context: context,
          item: widget.item,
          isInPlaylist: widget.isInPlaylist,
          parentItem: widget.parentItem,
          onRemoveFromList: widget.onRemoveFromList,
          themeProvider: _menuTheme,
          confirmPlaylistRemoval: false,
        );
      }
    }

    return GestureDetector(
      onTapDown: (_) {
        _menuTheme?.calculate(Theme.of(context).brightness);
      },
      onLongPressStart: (details) => menuCallback(),
      onSecondaryTapDown: (details) => menuCallback(),
      onTap: () async {
        if (!playable) return;
        var children = await widget.children;
        if (children != null) {
          // start linear playback of album from the given index
          await _queueService.startPlayback(
            items: children,
            startingIndex: await widget.index,
            order: FinampPlaybackOrder.linear,
            source: QueueItemSource(
              type: widget.isInPlaylist
                  ? QueueItemSourceType.playlist
                  : widget.isOnArtistScreen
                      ? QueueItemSourceType.artist
                      : QueueItemSourceType.album,
              name: QueueItemSourceName(
                  type: QueueItemSourceNameType.preTranslated,
                  pretranslatedName:
                      ((widget.isInPlaylist || widget.isOnArtistScreen)
                              ? widget.parentItem?.name
                              : widget.item.album) ??
                          AppLocalizations.of(context)!.placeholderSource),
              id: widget.parentItem?.id ?? "",
              item: widget.parentItem,
              // we're playing from an album, so we should use the album's normalization gain.
              contextNormalizationGain:
                  (widget.isInPlaylist || widget.isOnArtistScreen)
                      ? null
                      : widget.parentItem?.normalizationGain,
            ),
          );
        } else {
          // TODO put in a real offline songs implementation
          if (FinampSettingsHelper.finampSettings.isOffline) {
            final settings = FinampSettingsHelper.finampSettings;
            final downloadService = GetIt.instance<DownloadsService>();
            final finampUserHelper = GetIt.instance<FinampUserHelper>();

            // get all downloaded songs in order
            List<DownloadStub> offlineItems;
            // If we're on the songs tab, just get all of the downloaded items
            offlineItems = await downloadService.getAllSongs(
                // nameFilter: widget.searchTerm,
                viewFilter: finampUserHelper.currentUser?.currentView?.id,
                nullableViewFilters: settings.showDownloadsWithUnknownLibrary);

            var items =
                offlineItems.map((e) => e.baseItem).whereNotNull().toList();

            items = sortItems(items, settings.tabSortBy[TabContentType.songs],
                settings.tabSortOrder[TabContentType.songs]);

            await _queueService.startPlayback(
              items: items,
              startingIndex: widget.isShownInSearch
                  ? items.indexWhere((element) => element.id == widget.item.id)
                  : await widget.index,
              source: QueueItemSource(
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName:
                        AppLocalizations.of(context)!.placeholderSource),
                type: QueueItemSourceType.allSongs,
                id: widget.item.id,
              ),
            );
          } else {
            await _audioServiceHelper.startInstantMixForItem(widget.item);
          }
        }
      },
      child: (widget.isSong || !playable)
          ? listTile
          : Dismissible(
              key: Key(widget.index.toString()),
              direction: FinampSettingsHelper.finampSettings.disableGesture
                  ? DismissDirection.none
                  : DismissDirection.horizontal,
              dismissThresholds: const {
                DismissDirection.startToEnd: 0.5,
                DismissDirection.endToStart: 0.5
              },
              background: Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        TablerIcons.playlist,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        size: 40,
                      ),
                      Icon(
                        TablerIcons.playlist,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        size: 40,
                      )
                    ],
                  ),
                ),
              ),
              confirmDismiss: (direction) async {
                if (FinampSettingsHelper.finampSettings.swipeInsertQueueNext) {
                  await _queueService.addToNextUp(
                      items: [widget.item],
                      source: QueueItemSource(
                        type: QueueItemSourceType.nextUp,
                        name: QueueItemSourceName(
                            type: QueueItemSourceNameType.preTranslated,
                            pretranslatedName:
                                AppLocalizations.of(context)!.queue),
                        id: widget.parentItem?.id ?? "",
                        item: widget.parentItem,
                      ));
                } else {
                  await _queueService.addToQueue(
                      items: [widget.item],
                      source: QueueItemSource(
                        type: QueueItemSourceType.queue,
                        name: QueueItemSourceName(
                            type: QueueItemSourceNameType.preTranslated,
                            pretranslatedName:
                                AppLocalizations.of(context)!.queue),
                        id: widget.parentItem?.id ?? "",
                        item: widget.parentItem,
                      ));
                }

                if (!mounted) return false;

                GlobalSnackbar.message(
                  (scaffold) =>
                      FinampSettingsHelper.finampSettings.swipeInsertQueueNext
                          ? AppLocalizations.of(scaffold)!
                              .confirmAddToNextUp("track")
                          : AppLocalizations.of(scaffold)!
                              .confirmAddToQueue("track"),
                  isConfirmation: true,
                );

                return false;
              },
              child: listTile,
            ),
    );
  }
}
