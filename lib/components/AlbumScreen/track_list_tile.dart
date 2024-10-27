import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:finamp/components/AlbumScreen/song_menu.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_button.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
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

enum TrackListTileMenuItems {
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

class TrackListTile extends StatelessWidget {
  const TrackListTile({
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

    // if leading index number should be shown
    this.showIndex = false,

    /// Whether we are in the songs tab, as opposed to a playlist/album
    this.isSong = false,
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
  final bool showIndex;
  final bool isSong;
  final jellyfin_models.BaseItemDto? parentItem;
  final VoidCallback? onRemoveFromList;
  final bool showPlayCount;
  final bool isInPlaylist;
  final bool isOnArtistScreen;
  final bool isShownInSearch;

  @override
  Widget build(BuildContext context) {
    trackListTileOnTap(bool playable) async {
      final queueService = GetIt.instance<QueueService>();
      final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

      if (!playable) return;
      if (children != null) {
        // start linear playback of album from the given index
        await queueService.startPlayback(
          items: await children!,
          startingIndex: await index,
          order: FinampPlaybackOrder.linear,
          source: QueueItemSource(
            type: isInPlaylist
                ? QueueItemSourceType.playlist
                : isOnArtistScreen
                    ? QueueItemSourceType.artist
                    : QueueItemSourceType.album,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: ((isInPlaylist || isOnArtistScreen)
                        ? parentItem?.name
                        : item.album) ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem?.id ?? "",
            item: parentItem,
            // we're playing from an album, so we should use the album's normalization gain.
            contextNormalizationGain: (isInPlaylist || isOnArtistScreen)
                ? null
                : parentItem?.normalizationGain,
          ),
        );
      } else {
        // TODO put in a real offline songs implementation
        if (FinampSettingsHelper.finampSettings.isOffline) {
          final settings = FinampSettingsHelper.finampSettings;
          final downloadsService = GetIt.instance<DownloadsService>();
          final finampUserHelper = GetIt.instance<FinampUserHelper>();

          // get all downloaded songs in order
          List<DownloadStub> offlineItems;
          // If we're on the songs tab, just get all of the downloaded items
          offlineItems = await downloadsService.getAllSongs(
            // nameFilter: widget.searchTerm,
            viewFilter: finampUserHelper.currentUser?.currentView?.id,
            nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
            onlyFavorites:
                settings.onlyShowFavourite && settings.trackOfflineFavorites,
          );

          var items =
              offlineItems.map((e) => e.baseItem).whereNotNull().toList();

          items = sortItems(items, settings.tabSortBy[TabContentType.songs],
              settings.tabSortOrder[TabContentType.songs]);

          await queueService.startPlayback(
            items: items,
            startingIndex: isShownInSearch
                ? items.indexWhere((element) => element.id == item.id)
                : await index,
            source: QueueItemSource(
              name: QueueItemSourceName(
                type: item.name != null
                    ? QueueItemSourceNameType.mix
                    : QueueItemSourceNameType.instantMix,
                localizationParameter: item.name ?? "",
              ),
              type: QueueItemSourceType.allSongs,
              id: item.id,
            ),
          );
        } else {
          if (FinampSettingsHelper
              .finampSettings.startInstantMixForIndividualTracks) {
            await audioServiceHelper.startInstantMixForItem(item);
          } else {
            await queueService.startPlayback(
              items: [item],
              source: QueueItemSource(
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: item.name),
                type: QueueItemSourceType.song,
                id: item.id,
              ),
            );
          }
        }
      }
    }

    Future<bool> trackListTileConfirmDismiss(DismissDirection direction) async {
      final queueService = GetIt.instance<QueueService>();
      if (FinampSettingsHelper.finampSettings.swipeInsertQueueNext) {
        await queueService.addToNextUp(
            items: [item],
            source: QueueItemSource(
              type: QueueItemSourceType.nextUp,
              name: QueueItemSourceName(
                  type: QueueItemSourceNameType.preTranslated,
                  pretranslatedName: AppLocalizations.of(context)!.queue),
              id: parentItem?.id ?? "",
              item: parentItem,
            ));
      } else {
        await queueService.addToQueue(
            items: [item],
            source: QueueItemSource(
              type: QueueItemSourceType.queue,
              name: QueueItemSourceName(
                  type: QueueItemSourceNameType.preTranslated,
                  pretranslatedName: AppLocalizations.of(context)!.queue),
              id: parentItem?.id ?? "",
              item: parentItem,
            ));
      }

      GlobalSnackbar.message(
        (scaffold) => FinampSettingsHelper.finampSettings.swipeInsertQueueNext
            ? AppLocalizations.of(scaffold)!.confirmAddToNextUp("track")
            : AppLocalizations.of(scaffold)!.confirmAddToQueue("track"),
        isConfirmation: true,
      );

      return false;
    }

    final dismissBackground = Container(
      // color: Theme.of(context).colorScheme.secondaryContainer,
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                TablerIcons.playlist,
                color: Theme.of(context).colorScheme.secondary,
                size: 40,
              ),
              const SizedBox(width: 4.0),
              Text(
                FinampSettingsHelper.finampSettings.swipeInsertQueueNext
                    ? AppLocalizations.of(context)!.addToNextUp
                    : AppLocalizations.of(context)!.addToQueue,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                FinampSettingsHelper.finampSettings.swipeInsertQueueNext
                    ? AppLocalizations.of(context)!.addToNextUp
                    : AppLocalizations.of(context)!.addToQueue,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(width: 4.0),
              Icon(
                TablerIcons.playlist,
                color: Theme.of(context).colorScheme.secondary,
                size: 40,
              ),
            ],
          ),
        ],
      ),
    );

    return TrackListItem(
      baseItem: item,
      parentItem: parentItem,
      listIndex: index,
      actualIndex: item.indexNumber ?? -1,
      showIndex: showIndex,
      showArtists: !(
              // "hide song artists if they're the same as album artists" == true
              FinampSettingsHelper
                      .finampSettings.hideSongArtistsIfSameAsAlbumArtists
                  // song artists == album artists
                  &&
                  setEquals(
                      parentItem?.albumArtists?.map((e) => e.name).toSet(),
                      item.artists?.toSet())) &&
          parentItem?.isArtist != true,
      showPlayCount: showPlayCount,
      isInPlaylist: isInPlaylist,
      allowReorder: false,
      onRemoveFromList: onRemoveFromList,
      onTap: trackListTileOnTap,
      confirmDismiss: trackListTileConfirmDismiss,
      dismissBackground: dismissBackground,
    );
  }
}

class QueueListTile extends StatelessWidget {
  final jellyfin_models.BaseItemDto item;
  final jellyfin_models.BaseItemDto? parentItem;
  final Future<int>? listIndex;
  final int actualIndex;
  final int indexOffset;
  final bool isCurrentTrack;
  final bool isPreviousTrack;
  final bool isInPlaylist;
  final bool allowReorder;

  final void Function(bool playable) onTap;
  final VoidCallback? onRemoveFromList;
  final void Function(FinampTheme)? themeCallback;

  const QueueListTile({
    super.key,
    required this.item,
    required this.listIndex,
    required this.actualIndex,
    required this.indexOffset,
    required this.onTap,
    required this.isCurrentTrack,
    required this.isInPlaylist,
    required this.allowReorder,
    this.isPreviousTrack = false,
    this.parentItem,
    this.onRemoveFromList,
    this.themeCallback,
  });

  @override
  Widget build(BuildContext context) {
    Future<bool> queueListTileConfirmDismiss(direction) async {
      final queueService = GetIt.instance<QueueService>();
      FeedbackHelper.feedback(FeedbackType.impact);
      await queueService.removeAtOffset(indexOffset);
      return true;
    }

    return TrackListItem(
      baseItem: item,
      parentItem: parentItem,
      listIndex: listIndex,
      actualIndex: item.indexNumber ?? -1,
      isPreviousTrack: isPreviousTrack,
      isInPlaylist: isInPlaylist,
      allowReorder: allowReorder,
      onRemoveFromList: onRemoveFromList,
      // This must be in ListTile instead of parent GestureDetecter to
      // enable hover color changes
      onTap: onTap,
      confirmDismiss: queueListTileConfirmDismiss,
    );
  }
}

class TrackListItem extends ConsumerStatefulWidget {
  final jellyfin_models.BaseItemDto baseItem;
  final jellyfin_models.BaseItemDto? parentItem;
  final Future<int>? listIndex;
  final int actualIndex;
  final bool showIndex;
  final bool showArtists;
  final bool showPlayCount;
  final bool isPreviousTrack;
  final bool isInPlaylist;
  final bool allowReorder;
  final Widget dismissBackground;

  final void Function(bool playable) onTap;
  final Future<bool> Function(DismissDirection direction) confirmDismiss;
  final VoidCallback? onRemoveFromList;

  const TrackListItem(
      {super.key,
      required this.baseItem,
      required this.listIndex,
      required this.actualIndex,
      required this.onTap,
      required this.confirmDismiss,
      this.parentItem,
      this.isPreviousTrack = false,
      this.isInPlaylist = false,
      this.allowReorder = false,
      this.showIndex = false,
      this.showArtists = true,
      this.showPlayCount = false,
      this.onRemoveFromList,
      this.dismissBackground = const SizedBox.shrink()});

  @override
  ConsumerState<TrackListItem> createState() => TrackListItemState();
}

class TrackListItemState extends ConsumerState<TrackListItem>
    with SingleTickerProviderStateMixin {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  FinampTheme? _menuTheme;

  @override
  void dispose() {
    _menuTheme?.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    bool playable;
    if (FinampSettingsHelper.finampSettings.isOffline) {
      playable = ref.watch(GetIt.instance<DownloadsService>()
          .stateProvider(DownloadStub.fromItem(
              type: DownloadItemType.song, item: widget.baseItem))
          .select((value) => value.value?.isComplete ?? false));
    } else {
      playable = true;
    }

    final bool showAlbum = widget.baseItem.albumId != widget.parentItem?.id;

    void menuCallback() async {
      if (playable) {
        FeedbackHelper.feedback(FeedbackType.selection);
        await showModalSongMenu(
          context: context,
          item: widget.baseItem,
          isInPlaylist: widget.isInPlaylist,
          parentItem: widget.parentItem,
          onRemoveFromList: widget.onRemoveFromList,
          themeProvider: _menuTheme,
          confirmPlaylistRemoval: false,
        );
      }
    }

    final listItem = StreamBuilder<MediaItem?>(
        stream: _audioHandler.mediaItem,
        builder: (context, snapshot) {
          // I think past me did this check directly from the JSON for
          // performance. It works for now, apologies if you're debugging it
          // years in the future.
          final isCurrentlyPlaying =
              snapshot.data?.extras?["itemJson"]["Id"] == widget.baseItem.id;

          return isCurrentlyPlaying
              ? ProviderScope(
                  overrides: [
                    themeDataProvider.overrideWith((ref) {
                      return ref.watch(playerScreenThemeDataProvider) ??
                          FinampTheme.defaultTheme();
                    })
                  ],
                  child: Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      final imageTheme = ref.watch(playerScreenThemeProvider);
                      return AnimatedTheme(
                        duration: const Duration(milliseconds: 500),
                        data: ThemeData(
                          colorScheme: imageTheme,
                          brightness: Theme.of(context).brightness,
                          iconTheme: Theme.of(context).iconTheme.copyWith(
                                color: imageTheme.primary,
                              ),
                        ),
                        child: ThemedTrackListTile(
                            playable: playable,
                            isCurrentTrack: isCurrentlyPlaying,
                            isPreviousTrack: widget.isPreviousTrack,
                            themeCallback: (x) => _menuTheme = x,
                            baseItem: widget.baseItem,
                            listIndex: widget.listIndex,
                            actualIndex: widget.actualIndex,
                            showIndex: widget.showIndex,
                            showArtists: widget.showArtists,
                            showAlbum: showAlbum,
                            showPlayCount: widget.showPlayCount,
                            allowReorder: widget.allowReorder,
                            onTap: () => widget.onTap(playable)),
                      );
                    },
                  ),
                )
              : ThemedTrackListTile(
                  playable: playable,
                  isCurrentTrack: isCurrentlyPlaying,
                  isPreviousTrack: widget.isPreviousTrack,
                  themeCallback: (x) => _menuTheme = x,
                  baseItem: widget.baseItem,
                  listIndex: widget.listIndex,
                  actualIndex: widget.actualIndex,
                  showIndex: widget.showIndex,
                  showArtists: widget.showArtists,
                  showAlbum: showAlbum,
                  showPlayCount: widget.showPlayCount,
                  allowReorder: widget.allowReorder,
                  onTap: () => widget.onTap(playable));
        });

    return GestureDetector(
      onTapDown: (_) {
        _menuTheme?.calculate(Theme.of(context).brightness);
      },
      onLongPressStart: (details) => menuCallback(),
      onSecondaryTapDown: (details) => menuCallback(),
      child: !playable
          ? listItem
          : Dismissible(
              key: Key(widget.listIndex.toString()),
              direction: FinampSettingsHelper.finampSettings.disableGesture
                  ? DismissDirection.none
                  : DismissDirection.horizontal,
              dismissThresholds: const {
                DismissDirection.startToEnd: 0.65,
                DismissDirection.endToStart: 0.65
              },
              // no background, dismissing really dismisses here
              confirmDismiss: widget.confirmDismiss,
              background: widget.dismissBackground,
              child: listItem,
            ),
    );
  }
}

class ThemedTrackListTile extends ConsumerWidget {
  final bool playable;
  final bool isCurrentTrack;
  final bool isPreviousTrack;
  final void Function(FinampTheme) themeCallback;
  final jellyfin_models.BaseItemDto baseItem;
  final Future<int>? listIndex;
  final int actualIndex;
  final bool showIndex;
  final bool showArtists;
  final bool showAlbum;
  final bool showPlayCount;
  final bool allowReorder;
  final void Function() onTap;

  const ThemedTrackListTile({
    super.key,
    required this.playable,
    required this.isCurrentTrack,
    required this.isPreviousTrack,
    required this.themeCallback,
    required this.baseItem,
    required this.listIndex,
    required this.actualIndex,
    required this.showIndex,
    required this.showArtists,
    required this.showAlbum,
    required this.showPlayCount,
    required this.allowReorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Opacity(
      opacity: playable ? (isPreviousTrack ? 0.7 : 1.0) : 0.5,
      child: Card(
          color: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: AnimatedTheme(
            duration: const Duration(seconds: 2),
            data: Theme.of(context).copyWith(
                // customize the tile colors based on the current track theme
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      surfaceContainer: isCurrentTrack
                          ? ref
                              .watch(colorThemeNullableProvider)
                              .value
                              ?.primary
                              .withOpacity(Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? 0.35
                                  : 0.3)
                          // : Theme.of(context).colorScheme.surfaceContainer,
                          : Colors.transparent,
                    ),
                textTheme: Theme.of(context).textTheme.copyWith(
                      bodyLarge: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: isCurrentTrack
                                ? ref
                                    .watch(colorThemeNullableProvider)
                                    .value
                                    ?.secondary
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                    )),
            child: TrackListItemTile(
                baseItem: baseItem,
                listIndex: listIndex,
                actualIndex: actualIndex,
                showIndex: showIndex,
                showArtists: showArtists,
                showAlbum: showAlbum,
                showPlayCount: showPlayCount,
                themeCallback: themeCallback,
                isCurrentTrack: isCurrentTrack,
                allowReorder: allowReorder,
                onTap: onTap),
          )),
    );
  }
}

class TrackListItemTile extends StatelessWidget {
  const TrackListItemTile({
    super.key,
    required this.baseItem,
    required this.themeCallback,
    required this.isCurrentTrack,
    required this.allowReorder,
    required this.onTap,
    required this.actualIndex,
    this.listIndex,
    this.showIndex = false,
    this.showArtists = true,
    this.showAlbum = true,
    this.showPlayCount = false,
  });

  final jellyfin_models.BaseItemDto baseItem;
  final void Function(FinampTheme theme)? themeCallback;
  final bool isCurrentTrack;
  final bool allowReorder;
  final Future<int>? listIndex;
  final int actualIndex;
  final bool showIndex;
  final bool showArtists;
  final bool showAlbum;
  final bool showPlayCount;
  final void Function() onTap;

  static const double defaultTileHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    final bool secondRowNeeded = showArtists || showAlbum || showPlayCount;

    return ListTileTheme(
      tileColor: Theme.of(context).colorScheme.surfaceContainer,
      child: ListTile(
        visualDensity: const VisualDensity(
          horizontal: 0.0,
          vertical: 1.0,
        ),
        minVerticalPadding: 0.0,
        horizontalTitleGap: 10.0,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        // tileColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIndex)
              Padding(
                padding:
                    FinampSettingsHelper.finampSettings.showCoversOnAlbumScreen
                        ? const EdgeInsets.only(left: 2.0, right: 6.0)
                        : const EdgeInsets.only(left: 6.0, right: 0.0),
                child: SizedBox.fromSize(
                    size: const Size(22.0, defaultTileHeight),
                    child: Center(
                        child: Text(
                      actualIndex.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ))),
              ),
            if (FinampSettingsHelper.finampSettings.showCoversOnAlbumScreen)
              Stack(
                children: [
                  AlbumImage(
                    item: baseItem,
                    borderRadius: isCurrentTrack
                        ? BorderRadius.zero
                        : BorderRadius.circular(8.0),
                    themeCallback: themeCallback,
                  ),
                  if (isCurrentTrack)
                    SizedBox.square(
                      dimension: defaultTileHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: isCurrentTrack
                              ? BorderRadius.zero
                              : BorderRadius.circular(8.0),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.35)
                              : Colors.white.withOpacity(0.35),
                        ),
                        // color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
                        child: MiniMusicVisualizer(
                          color: Theme.of(context).colorScheme.secondary,
                          animate: true,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
        title: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: defaultTileHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  baseItem.name ?? AppLocalizations.of(context)!.unknownName,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.0),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Text.rich(
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                  TextSpan(
                      text: showArtists
                          ? baseItem.artists?.join(", ") ??
                              baseItem.albumArtist ??
                              AppLocalizations.of(context)!.unknownArtist
                          : "",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color!,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis),
                      children: [
                        if (!secondRowNeeded)
                          // show the artist anyway if nothing else is shown
                          TextSpan(
                            text: baseItem.artists?.join(", ") ??
                                baseItem.albumArtist ??
                                AppLocalizations.of(context)!.unknownArtist,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withOpacity(0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        if (showArtists)
                          const WidgetSpan(child: SizedBox(width: 10.0)),
                        if (showAlbum)
                          TextSpan(
                            text: baseItem.album,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withOpacity(0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        if (showAlbum)
                          const WidgetSpan(child: SizedBox(width: 10.0)),
                        if (showPlayCount)
                          TextSpan(
                            text: AppLocalizations.of(context)!.playCountValue(
                                baseItem.userData?.playCount ?? 0),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withOpacity(0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                      ]),
                ),
              ),
            ],
          ),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(right: 0.0),
          padding: const EdgeInsets.only(right: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${baseItem.runTimeTicksDuration()?.inMinutes.toString()}:${((baseItem.runTimeTicksDuration()?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              AddToPlaylistButton(
                item: baseItem,
                size: 24,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                ),
              ),
              if (allowReorder)
                FutureBuilder(
                    future: listIndex,
                    builder: (context, snapshot) {
                      return ReorderableDragStartListener(
                        index: snapshot.data ??
                            0, // will briefly use 0 as index, but should resolve quickly enough for user not to notice
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Icon(
                            TablerIcons.grip_horizontal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Colors.white,
                            size: 28.0,
                            weight: 1.5,
                          ),
                        ),
                      );
                    }),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
