import 'dart:async';

import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_button.dart';
import 'package:finamp/components/AlbumScreen/track_menu.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/services/current_album_image_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../services/audio_service_helper.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/theme_provider.dart';
import '../album_image.dart';
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

    /// Children that are related to this list tile, such as the other tracks in
    /// the album. This is used to give the audio service all the tracks for the
    /// item. If null, only this track will be given to the audio service.
    this.children,

    /// Index of the track in whatever parent this widget is in. Used to start
    /// the audio service at a certain index, such as when selecting the middle
    /// track in an album.  Will be -1 if we are offline and the track is not downloaded.
    this.index,
    this.parentItem,

    // if leading index number should be shown
    this.showIndex = false,
    // if leading album cover should be shown
    this.showCover = true,

    /// Whether we are in the tracks tab, as opposed to a playlist/album
    this.isTrack = false,
    this.onRemoveFromList,
    this.showPlayCount = false,

    /// Whether this widget is being displayed in a playlist. If true, will show
    /// the remove from playlist button.
    this.isInPlaylist = false,
    this.isOnArtistScreen = false,
    this.isShownInSearch = false,
    this.allowDismiss = true,
    this.highlightCurrentTrack = true,
  });

  final jellyfin_models.BaseItemDto item;
  final Future<List<jellyfin_models.BaseItemDto>>? children;
  final Future<int>? index;
  final bool showIndex;
  final bool showCover;
  final bool isTrack;
  final jellyfin_models.BaseItemDto? parentItem;
  final VoidCallback? onRemoveFromList;
  final bool showPlayCount;
  final bool isInPlaylist;
  final bool isOnArtistScreen;
  final bool isShownInSearch;
  final bool allowDismiss;
  final bool highlightCurrentTrack;

  @override
  Widget build(BuildContext context) {
    final currentSettings = FinampSettingsHelper.finampSettings;

    Future<void> trackListTileOnTap(bool playable) async {
      final queueService = GetIt.instance<QueueService>();
      final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

      if (!playable) return;
      if (children != null) {
        // start linear playback of album from the given index
        await queueService.startPlayback(
          items: await children!,
          startingIndex: await index,
          order: FinampPlaybackOrder.linear,
          source: QueueItemSource.rawId(
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
            id: parentItem?.id.raw ?? "",
            item: parentItem,
            // we're playing from an album, so we should use the album's normalization gain.
            contextNormalizationGain: (isInPlaylist || isOnArtistScreen)
                ? null
                : parentItem?.normalizationGain,
          ),
        );
      } else {
        // TODO put in a real offline tracks implementation
        if (FinampSettingsHelper.finampSettings.isOffline) {
          final settings = FinampSettingsHelper.finampSettings;
          final downloadsService = GetIt.instance<DownloadsService>();
          final finampUserHelper = GetIt.instance<FinampUserHelper>();

          // get all downloaded tracks in order
          List<DownloadStub> offlineItems;
          // If we're on the tracks tab, just get all of the downloaded items
          offlineItems = await downloadsService.getAllTracks(
            // nameFilter: widget.searchTerm,
            viewFilter: finampUserHelper.currentUser?.currentView?.id,
            nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
            onlyFavorites:
                settings.onlyShowFavourites && settings.trackOfflineFavorites,
          );

          var items = offlineItems.map((e) => e.baseItem).nonNulls.toList();

          items = sortItems(items, settings.tabSortBy[TabContentType.tracks],
              settings.tabSortOrder[TabContentType.tracks]);

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
              type: QueueItemSourceType.allTracks,
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
                type: QueueItemSourceType.track,
                id: item.id,
              ),
            );
          }
        }
      }
    }

    Future<bool> trackListTileConfirmDismiss(DismissDirection direction) async {
      var followUpAction = (direction == DismissDirection.startToEnd)
          ? currentSettings.itemSwipeActionLeftToRight
          : currentSettings.itemSwipeActionRightToLeft;

      final queueService = GetIt.instance<QueueService>();

      switch (followUpAction) {
        case ItemSwipeActions.addToNextUp:
          unawaited(queueService.addToNextUp(
              items: [item],
              source: QueueItemSource.rawId(
                type: QueueItemSourceType.nextUp,
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: AppLocalizations.of(context)!.queue),
                id: parentItem?.id.raw ?? "",
                item: parentItem,
              )));
          GlobalSnackbar.message(
            (scaffold) =>
                AppLocalizations.of(scaffold)!.confirmAddToNextUp("track"),
            isConfirmation: true,
          );
          break;
        case ItemSwipeActions.playNext:
          unawaited(queueService.addNext(
              items: [item],
              source: QueueItemSource.rawId(
                type: QueueItemSourceType.nextUp,
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: AppLocalizations.of(context)!.queue),
                id: parentItem?.id.raw ?? "",
                item: parentItem,
              )));
          GlobalSnackbar.message(
            (scaffold) =>
                AppLocalizations.of(scaffold)!.confirmPlayNext("track"),
            isConfirmation: true,
          );
          break;
        case ItemSwipeActions.addToQueue:
          unawaited(queueService.addToQueue(
              items: [item],
              source: QueueItemSource.rawId(
                type: QueueItemSourceType.queue,
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: AppLocalizations.of(context)!.queue),
                id: parentItem?.id.raw ?? "",
                item: parentItem,
              )));
          GlobalSnackbar.message(
            (scaffold) =>
                AppLocalizations.of(scaffold)!.confirmAddToQueue("track"),
            isConfirmation: true,
          );
          break;
        case ItemSwipeActions.nothing:
          break;
      }

      return false;
    }

    IconData getSwipeActionIcon(ItemSwipeActions action) {
      switch (action) {
        case ItemSwipeActions.addToQueue:
          return TablerIcons.playlist;
        case ItemSwipeActions.playNext:
          return TablerIcons.corner_right_down;
        case ItemSwipeActions.addToNextUp:
        case ItemSwipeActions.nothing:
          return TablerIcons.corner_right_down_double;
      }
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
                getSwipeActionIcon(currentSettings.itemSwipeActionLeftToRight),
                color: Theme.of(context).colorScheme.secondary,
                size: 40,
              ),
              const SizedBox(width: 4.0),
              Text(
                currentSettings.itemSwipeActionLeftToRight
                    .toLocalisedString(context),
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
                currentSettings.itemSwipeActionRightToLeft
                    .toLocalisedString(context),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(width: 4.0),
              Icon(
                getSwipeActionIcon(currentSettings.itemSwipeActionRightToLeft),
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
      actualIndex: item.indexNumber,
      showIndex: showIndex,
      showCover: showCover,
      showArtists: parentItem?.isArtist != true,
      showPlayCount: showPlayCount,
      isInPlaylist: isInPlaylist,
      allowReorder: false,
      allowDismiss: allowDismiss,
      highlightCurrentTrack: highlightCurrentTrack,
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
  final bool isInPlaylist;
  final bool allowReorder;
  final bool allowDismiss;
  final bool highlightCurrentTrack;

  final void Function(bool playable) onTap;
  final VoidCallback? onRemoveFromList;

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
    this.allowDismiss = true,
    this.highlightCurrentTrack = false,
    this.parentItem,
    this.onRemoveFromList,
  });

  @override
  Widget build(BuildContext context) {
    Future<bool> queueListTileConfirmDismiss(direction) async {
      final queueService = GetIt.instance<QueueService>();
      FeedbackHelper.feedback(FeedbackType.heavy);
      unawaited(queueService.removeAtOffset(indexOffset));
      return true;
    }

    return TrackListItem(
      baseItem: item,
      parentItem: parentItem,
      listIndex: listIndex,
      actualIndex: item.indexNumber,
      isInPlaylist: isInPlaylist,
      allowReorder: allowReorder,
      allowDismiss: allowDismiss,
      highlightCurrentTrack: highlightCurrentTrack,
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
  final int? actualIndex;
  final bool showIndex;
  final bool showCover;
  final bool showArtists;
  final bool showPlayCount;
  final bool isInPlaylist;
  final bool allowReorder;
  final bool allowDismiss;
  final bool highlightCurrentTrack;
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
      this.isInPlaylist = false,
      this.allowReorder = false,
      this.allowDismiss = true,
      this.showIndex = false,
      this.showCover = true,
      this.showArtists = true,
      this.showPlayCount = false,
      this.highlightCurrentTrack = true,
      this.onRemoveFromList,
      this.dismissBackground = const SizedBox.shrink()});

  @override
  ConsumerState<TrackListItem> createState() => TrackListItemState();
}

class TrackListItemState extends ConsumerState<TrackListItem>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(
    BuildContext context,
  ) {
    bool playable;
    if (FinampSettingsHelper.finampSettings.isOffline) {
      playable = ref.watch(GetIt.instance<DownloadsService>()
          .stateProvider(DownloadStub.fromItem(
              type: DownloadItemType.track, item: widget.baseItem))
          .select((value) => value.value?.isComplete ?? false));
    } else {
      playable = true;
    }

    final bool showAlbum = widget.baseItem.albumId != widget.parentItem?.id;

    final isCurrentlyPlaying = ref.watch(currentTrackProvider.select(
        (queueItem) =>
            queueItem.valueOrNull?.baseItemId == widget.baseItem.id));

    var listItem = Opacity(
      opacity: playable ? 1.0 : 0.5,
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TrackListItemTile(
            baseItem: widget.baseItem,
            listIndex: widget.listIndex,
            actualIndex: widget.actualIndex,
            showIndex: widget.showIndex,
            showCover: widget.showCover,
            showArtists: widget.showArtists,
            showAlbum: showAlbum,
            showPlayCount: widget.showPlayCount,
            isCurrentTrack: isCurrentlyPlaying,
            highlightCurrentTrack: widget.highlightCurrentTrack,
            allowReorder: widget.allowReorder,
            onTap: () => widget.onTap(playable)),
      ),
    );

    var unthemedItem = Builder(builder: (context) {
      // Use potentially themed context in menu callback
      void menuCallback() async {
        if (playable) {
          FeedbackHelper.feedback(FeedbackType.selection);
          await showModalTrackMenu(
            context: context,
            item: widget.baseItem,
            isInPlaylist: widget.isInPlaylist,
            parentItem: widget.parentItem,
            onRemoveFromList: widget.onRemoveFromList,
            confirmPlaylistRemoval: false,
          );
        }
      }

      final currentSettings = FinampSettingsHelper.finampSettings;
      final swipeLeftEnabled = (currentSettings.itemSwipeActionLeftToRight !=
          ItemSwipeActions.nothing);
      final swipeRightEnabled = (currentSettings.itemSwipeActionRightToLeft !=
          ItemSwipeActions.nothing);
      final allowedDismissDirection = (swipeLeftEnabled && swipeRightEnabled)
          ? DismissDirection.horizontal
          : swipeLeftEnabled
              ? DismissDirection.startToEnd
              : swipeRightEnabled
                  ? DismissDirection.endToStart
                  : DismissDirection.none;

      return GestureDetector(
        onTapDown: (_) {
          // Begin precalculating theme for song menu
          ref.listen(
              finampThemeProvider(ThemeInfo(widget.baseItem)), (_, __) {});
        },
        onLongPressStart: (details) => menuCallback(),
        onSecondaryTapDown: (details) => menuCallback(),
        child: !playable
            ? listItem
            : Dismissible(
                key: Key(widget.listIndex.toString()),
                direction: FinampSettingsHelper.finampSettings.disableGesture ||
                        !widget.allowDismiss
                    ? DismissDirection.none
                    : allowedDismissDirection,
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
    });

    return isCurrentlyPlaying && widget.highlightCurrentTrack
        ? PlayerScreenTheme(
            themeTransitionDuration: const Duration(milliseconds: 500),
            themeOverride: (imageTheme) {
              return imageTheme.copyWith(
                  colorScheme: imageTheme.colorScheme.copyWith(
                      surfaceContainer: imageTheme.colorScheme.primary
                          .withOpacity(imageTheme.brightness == Brightness.dark
                              ? 0.35
                              : 0.3)),
                  textTheme: imageTheme.textTheme.copyWith(
                    bodyLarge: imageTheme.textTheme.bodyLarge?.copyWith(
                        color: Color.alphaBlend(
                            (imageTheme.colorScheme.secondary.withOpacity(
                                imageTheme.brightness == Brightness.light
                                    ? 0.5
                                    : 0.1)),
                            imageTheme.textTheme.bodyLarge?.color ??
                                (imageTheme.brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white))),
                  ));
            },
            child: unthemedItem)
        : unthemedItem;
  }
}

class TrackListItemTile extends StatelessWidget {
  const TrackListItemTile({
    super.key,
    required this.baseItem,
    required this.isCurrentTrack,
    required this.allowReorder,
    required this.onTap,
    required this.actualIndex,
    this.listIndex,
    this.showIndex = false,
    this.showCover = true,
    this.showArtists = true,
    this.showAlbum = true,
    this.showPlayCount = false,
    this.highlightCurrentTrack = true,
  });

  final jellyfin_models.BaseItemDto baseItem;
  final bool isCurrentTrack;
  final bool allowReorder;
  final Future<int>? listIndex;
  final int? actualIndex;
  final bool showIndex;
  final bool showCover;
  final bool showArtists;
  final bool showAlbum;
  final bool showPlayCount;
  final bool highlightCurrentTrack;
  final void Function() onTap;

  static const double defaultTileHeight = 60.0;
  static const double defaultTitleGap = 10.0;

  @override
  Widget build(BuildContext context) {
    final highlightTrack = isCurrentTrack && highlightCurrentTrack;

    final bool secondRowNeeded = showArtists || showAlbum || showPlayCount;

    final durationLabelFullHours =
        (baseItem.runTimeTicksDuration()?.inHours ?? 0);
    final durationLabelFullMinutes =
        (baseItem.runTimeTicksDuration()?.inMinutes ?? 0) % 60;
    final durationLabelSeconds =
        (baseItem.runTimeTicksDuration()?.inSeconds ?? 0) % 60;
    final durationLabelString =
        "${durationLabelFullHours > 0 ? "$durationLabelFullHours ${AppLocalizations.of(context)!.hours} " : ""}${durationLabelFullMinutes > 0 ? "$durationLabelFullMinutes ${AppLocalizations.of(context)!.minutes} " : ""}$durationLabelSeconds ${AppLocalizations.of(context)!.seconds}";

    final artistsString = (baseItem.artists?.isNotEmpty ?? false)
        ? baseItem.artists?.join(", ")
        : baseItem.albumArtist ?? AppLocalizations.of(context)!.unknownArtist;

    return ListTileTheme(
      tileColor: highlightTrack
          ? Theme.of(context).colorScheme.surfaceContainer
          : Colors.transparent,
      child: ListTile(
        visualDensity: const VisualDensity(
          horizontal: 0.0,
          vertical: 0.5,
        ),
        minVerticalPadding: 0.0,
        horizontalTitleGap: defaultTitleGap,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        // tileColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIndex && actualIndex != null)
              Padding(
                padding: showCover
                    ? const EdgeInsets.only(left: 2.0, right: 8.0)
                    : const EdgeInsets.only(left: 6.0, right: 0.0),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 22.0,
                  ),
                  child: Text(
                    actualIndex.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            if (showCover)
              AlbumImage(
                item: baseItem,
                borderRadius: highlightTrack
                    ? BorderRadius.zero
                    : BorderRadius.circular(8.0),
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
                flex: 3,
                child: Text(
                  baseItem.name ?? AppLocalizations.of(context)!.unknownName,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500,
                      height: 1.1),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 2,
                child: Text.rich(
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  maxLines: 1,
                  TextSpan(children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Transform.translate(
                          offset: const Offset(-1.5, 2.5),
                          child: DownloadedIndicator(
                            item: DownloadStub.fromItem(
                                item: baseItem, type: DownloadItemType.track),
                            size: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize! +
                                1,
                          ),
                        ),
                      ),
                      alignment: PlaceholderAlignment.top,
                    ),
                    if (baseItem.hasLyrics ?? false)
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Transform.translate(
                              offset: const Offset(-1.5, 2.5),
                              child: Icon(
                                TablerIcons.microphone_2,
                                size: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize! +
                                    1,
                              )),
                        ),
                        alignment: PlaceholderAlignment.top,
                      ),
                    if (showArtists)
                      TextSpan(
                        text: artistsString,
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color!
                                .withOpacity(0.75),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis),
                      ),
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
                        text: AppLocalizations.of(context)!
                            .playCountValue(baseItem.userData?.playCount ?? 0),
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
                printDuration(baseItem.runTimeTicksDuration(),
                    leadingZeroes: false),
                semanticsLabel: durationLabelString,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              Semantics(
                excludeSemantics: true,
                child: AddToPlaylistButton(
                  item: baseItem,
                  size: 24,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                  ),
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
