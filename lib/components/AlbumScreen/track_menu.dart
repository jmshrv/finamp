import 'dart:async';

import 'package:finamp/components/AlbumScreen/sleep_timer_menu.dart';
import 'package:finamp/components/AlbumScreen/speed_menu.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/PlayerScreen/queue_list.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_cancel_dialog.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_dialog.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/screens/genre_screen.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/metadata_provider.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/album_screen.dart';
import '../../services/audio_service_helper.dart';
import '../../services/downloads_service.dart';
import '../../services/favorite_provider.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AddToPlaylistScreen/playlist_actions_menu.dart';
import '../PlayerScreen/album_chip.dart';
import '../PlayerScreen/artist_chip.dart';
import '../PlayerScreen/queue_source_helper.dart';
import '../album_image.dart';
import '../global_snackbar.dart';
import 'download_dialog.dart';

const Duration trackMenuDefaultAnimationDuration = Duration(milliseconds: 500);
const Curve trackMenuDefaultInCurve = Curves.easeOutCubic;
const Curve trackMenuDefaultOutCurve = Curves.easeInCubic;

Future<void> showModalTrackMenu({
  required BuildContext context,
  required BaseItemDto item,
  bool showPlaybackControls = false,
  bool isInPlaylist = false,
  BaseItemDto? parentItem,
  Function? onRemoveFromList,
  bool confirmPlaylistRemoval = true,
  bool showClearQueue = false,
}) async {
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;
  final canGoToAlbum = item.parentId != null;
  final canGoToArtist = (item.artistItems?.isNotEmpty ?? false);
  final canGoToGenre = (item.genreItems?.isNotEmpty ?? false);

  await showThemedBottomSheet(
      context: context,
      item: item,
      routeName: TrackMenu.routeName,
      buildWrapper: (context, dragController, childBuilder) {
        return TrackMenu(
          key: ValueKey(item.id),
          item: item,
          parentItem: parentItem,
          isOffline: isOffline,
          showPlaybackControls: showPlaybackControls,
          isInPlaylist: isInPlaylist,
          canGoToAlbum: canGoToAlbum,
          canGoToArtist: canGoToArtist,
          canGoToGenre: canGoToGenre,
          onRemoveFromList: onRemoveFromList,
          confirmPlaylistRemoval: confirmPlaylistRemoval,
          showClearQueue: showClearQueue,
          childBuilder: childBuilder,
          dragController: dragController,
        );
      });
}

enum SubMenu {
  speed,
  sleepTimer,
}

class TrackMenu extends ConsumerStatefulWidget {
  static const routeName = "/track-menu";

  const TrackMenu({
    super.key,
    required this.item,
    required this.isOffline,
    required this.showPlaybackControls,
    required this.isInPlaylist,
    required this.canGoToAlbum,
    required this.canGoToArtist,
    required this.canGoToGenre,
    required this.onRemoveFromList,
    required this.confirmPlaylistRemoval,
    required this.showClearQueue,
    this.parentItem,
    required this.childBuilder,
    required this.dragController,
  });

  final BaseItemDto item;
  final BaseItemDto? parentItem;
  final bool isOffline;
  final bool showPlaybackControls;
  final bool isInPlaylist;
  final bool canGoToAlbum;
  final bool canGoToArtist;
  final bool canGoToGenre;
  final Function? onRemoveFromList;
  final bool confirmPlaylistRemoval;
  final bool showClearQueue;
  final ScrollBuilder childBuilder;
  final DraggableScrollableController dragController;

  @override
  ConsumerState<TrackMenu> createState() => _TrackMenuState();
}

class _TrackMenuState extends ConsumerState<TrackMenu>
    with TickerProviderStateMixin {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  // Makes sure that widget doesn't just disappear after press while menu is visible
  bool speedWidgetWasVisible = false;
  SubMenu? activeMenu;
  SubMenu? previousMenu;


  double initialSheetExtent = 0.0;
  double inputStep = 0.9;
  double oldExtent = 0.0;

  @override
  void initState() {
    super.initState();

    initialSheetExtent = widget.showPlaybackControls ? 0.6 : 0.45;
    oldExtent = initialSheetExtent;
  }

  bool isBaseItemInQueueItem(BaseItemDto baseItem, FinampQueueItem? queueItem) {
    if (queueItem != null) {
      final baseItem = BaseItemDto.fromJson(
          queueItem.item.extras!["itemJson"] as Map<String, dynamic>);
      return baseItem.id == queueItem.id;
    }
    return false;
  }

  void setActiveMenu(SubMenu? menu) {
    setState(() {
      previousMenu = activeMenu;
      activeMenu = menu;
    });
    if (widget.dragController.isAttached) {
      scrollToExtent(widget.dragController, menu != null ? inputStep : null);
    }
    FeedbackHelper.feedback(FeedbackType.selection);
  }

  void toggleSpeedMenu() {
    setActiveMenu(activeMenu == SubMenu.speed ? null : SubMenu.speed);
  }

  void toggleSleepTimerMenu() {
    setActiveMenu(activeMenu == SubMenu.sleepTimer ? null : SubMenu.sleepTimer);
  }

  bool shouldShowSpeedControls(
      double currentSpeed, MetadataProvider? metadata) {
    if (currentSpeed != 1.0 ||
        FinampSettingsHelper.finampSettings.playbackSpeedVisibility ==
            PlaybackSpeedVisibility.visible) {
      return true;
    }

    if (FinampSettingsHelper.finampSettings.playbackSpeedVisibility ==
        PlaybackSpeedVisibility.automatic) {
      return metadata?.qualifiesForPlaybackSpeedControl ?? false;
    }

    return false;
  }

  void scrollToExtent(
      DraggableScrollableController scrollController, double? percentage) {
    var currentSize = scrollController.size;
    if ((percentage != null && currentSize < percentage) ||
        scrollController.size == inputStep) {
      if (MediaQuery.of(context).disableAnimations) {
        scrollController.jumpTo(
          percentage ?? oldExtent,
        );
      } else {
        scrollController.animateTo(
          percentage ?? oldExtent,
          duration: trackMenuDefaultAnimationDuration,
          curve: trackMenuDefaultInCurve,
        );
      }
    }
    oldExtent = currentSize;
  }

  @override
  Widget build(BuildContext context) {
    final menuEntries = _menuEntries(context);
    var stackHeight = widget.showPlaybackControls ? 255.0 : 155.0;
    stackHeight += menuEntries
            .where((element) =>
                switch (element) { Visibility e => e.visible, _ => true })
            .length *
        56;

    return Consumer(builder: (context, ref, child) {
      final metadata = ref.watch(currentTrackMetadataProvider).unwrapPrevious();
      return widget.childBuilder(
          stackHeight, menu(context, menuEntries, metadata.value));
    });
  }

  // Normal track menu entries, excluding headers
  List<Widget> _menuEntries(BuildContext context) {
    final downloadsService = GetIt.instance<DownloadsService>();
    final downloadStatus = downloadsService.getStatus(
        DownloadStub.fromItem(type: DownloadItemType.track, item: widget.item),
        null);
    var iconColor = Theme.of(context).colorScheme.primary;

    final isInCurrentPlaylist =
        widget.isInPlaylist && widget.parentItem != null;

    final currentTrack = _queueService.getCurrentTrack();
    FinampQueueItem? queueItem;
    if (isBaseItemInQueueItem(widget.item, currentTrack)) {
      queueItem = currentTrack;
    }

    String? parentTooltip;
    if (downloadStatus.isIncidental) {
      var parent = downloadsService.getFirstRequiringItem(DownloadStub.fromItem(
          type: DownloadItemType.track, item: widget.item));
      if (parent != null) {
        var parentName = AppLocalizations.of(context)!
            .itemTypeSubtitle(parent.baseItemType.name, parent.name);
        parentTooltip =
            AppLocalizations.of(context)!.incidentalDownloadTooltip(parentName);
      }
    }

    return [
      Visibility(
        visible: !widget.isOffline,
        child: ListTile(
          leading: Icon(
            Icons.playlist_add,
            color: iconColor,
          ),
          title: Text(isInCurrentPlaylist
              ? AppLocalizations.of(context)!.addToMorePlaylistsTitle
              : AppLocalizations.of(context)!.addToPlaylistTitle),
          enabled: !widget.isOffline,
          onTap: () {
            Navigator.pop(context); // close menu
            bool inPlaylist = queueItemInPlaylist(queueItem);
            showPlaylistActionsMenu(
              context: context,
              item: widget.item,
              parentPlaylist: inPlaylist ? queueItem!.source.item : null,
            );
          },
        ),
      ),
      Visibility(
        visible: _queueService.getQueue().nextUp.isNotEmpty,
        child: ListTile(
          leading: Icon(
            TablerIcons.corner_right_down,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.playNext),
          onTap: () async {
            await _queueService.addNext(
                items: [widget.item],
                source: QueueItemSource(
                    type: QueueItemSourceType.nextUp,
                    name: const QueueItemSourceName(
                        type: QueueItemSourceNameType.nextUp),
                    id: widget.item.id));

            if (!context.mounted) return;

            GlobalSnackbar.message(
                (context) =>
                    AppLocalizations.of(context)!.confirmPlayNext("track"),
                isConfirmation: true);
            Navigator.pop(context);
          },
        ),
      ),
      ListTile(
        leading: Icon(
          TablerIcons.corner_right_down_double,
          color: iconColor,
        ),
        title: Text(AppLocalizations.of(context)!.addToNextUp),
        onTap: () async {
          await _queueService.addToNextUp(
              items: [widget.item],
              source: QueueItemSource(
                  type: QueueItemSourceType.nextUp,
                  name: const QueueItemSourceName(
                      type: QueueItemSourceNameType.nextUp),
                  id: widget.item.id));

          if (!context.mounted) return;

          GlobalSnackbar.message(
              (context) =>
                  AppLocalizations.of(context)!.confirmAddToNextUp("track"),
              isConfirmation: true);
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(
          TablerIcons.playlist,
          color: iconColor,
        ),
        title: Text(AppLocalizations.of(context)!.addToQueue),
        onTap: () async {
          await _queueService.addToQueue(
              items: [widget.item],
              source: QueueItemSource(
                  type: QueueItemSourceType.queue,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName: AppLocalizations.of(context)!.queue),
                  id: widget.item.id));

          if (!context.mounted) return;

          GlobalSnackbar.message(
              (context) => AppLocalizations.of(context)!.addedToQueue,
              isConfirmation: true);
          Navigator.pop(context);
        },
      ),
      Visibility(
        visible: isInCurrentPlaylist,
        child: ListTile(
          leading: Icon(
            Icons.playlist_remove,
            color: widget.isOffline ? iconColor.withOpacity(0.3) : iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.removeFromPlaylistTitle),
          enabled: widget.isInPlaylist &&
              widget.parentItem != null &&
              !widget.isOffline,
          onTap: () async {
            var removed = await removeFromPlaylist(context, widget.item,
                widget.parentItem!, widget.item.playlistItemId!,
                confirm: widget.confirmPlaylistRemoval);
            if (removed) {
              if (widget.onRemoveFromList != null) {
                widget.onRemoveFromList!();
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            }
          },
        ),
      ),
      Visibility(
        visible: !widget.isOffline,
        child: ListTile(
          leading: Icon(
            Icons.explore,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.instantMix),
          enabled: !widget.isOffline,
          onTap: () async {
            await _audioServiceHelper.startInstantMixForItem(widget.item);

            if (!context.mounted) return;

            GlobalSnackbar.message(
                (context) => AppLocalizations.of(context)!.startingInstantMix,
                isConfirmation: true);
            Navigator.pop(context);
          },
        ),
      ),
      Visibility(
          visible: downloadStatus.isRequired,
          child: ListTile(
              leading: Icon(
                Icons.delete_outlined,
                color: iconColor,
              ),
              title: Text(AppLocalizations.of(context)!
                  .deleteFromTargetConfirmButton("")),
              enabled: downloadStatus.isRequired,
              onTap: () async {
                var item = DownloadStub.fromItem(
                    type: DownloadItemType.track, item: widget.item);
                await askBeforeDeleteDownloadFromDevice(context, item);
              })),
      Visibility(
        visible: downloadStatus == DownloadItemStatus.notNeeded,
        child: ListTile(
          leading: Icon(
            Icons.file_download_outlined,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.downloadItem),
          enabled: !widget.isOffline &&
              downloadStatus == DownloadItemStatus.notNeeded,
          onTap: () async {
            var item = DownloadStub.fromItem(
                type: DownloadItemType.track, item: widget.item);
            await DownloadDialog.show(context, item, null);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      Visibility(
        visible: downloadStatus.isIncidental,
        child: Tooltip(
          message: parentTooltip ?? "Widget shouldn't be visible",
          child: ListTile(
            leading: Icon(
              Icons.lock_outlined,
              color: widget.isOffline ? iconColor.withOpacity(0.3) : iconColor,
            ),
            title: Text(AppLocalizations.of(context)!.lockDownload),
            enabled: !widget.isOffline && downloadStatus.isIncidental,
            onTap: () async {
              var item = DownloadStub.fromItem(
                  type: DownloadItemType.track, item: widget.item);
              await DownloadDialog.show(context, item, null);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      Consumer(
        builder: (context, ref, child) {
          bool isFav = ref.watch(isFavoriteProvider(widget.item));
          return ListTile(
            enabled: !widget.isOffline,
            leading: isFav
                ? Icon(
                    Icons.favorite,
                    color: widget.isOffline
                        ? iconColor.withOpacity(0.3)
                        : iconColor,
                  )
                : Icon(
                    Icons.favorite_border,
                    color: widget.isOffline
                        ? iconColor.withOpacity(0.3)
                        : iconColor,
                  ),
            title: Text(isFav
                ? AppLocalizations.of(context)!.removeFavorite
                : AppLocalizations.of(context)!.addFavorite),
            onTap: () async {
              ref
                  .read(isFavoriteProvider(widget.item).notifier)
                  .updateFavorite(!isFav);
              if (context.mounted) Navigator.pop(context);
            },
          );
        },
      ),
      Visibility(
        visible: widget.canGoToAlbum,
        child: ListTile(
          leading: Icon(
            TablerIcons.disc,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.goToAlbum),
          enabled: widget.canGoToAlbum,
          onTap: () async {
            late BaseItemDto album;
            try {
              if (FinampSettingsHelper.finampSettings.isOffline) {
                final downloadsService = GetIt.instance<DownloadsService>();
                album = (await downloadsService.getCollectionInfo(
                        id: widget.item.albumId!))!
                    .baseItem!;
              } else {
                album =
                    await _jellyfinApiHelper.getItemById(widget.item.albumId!);
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
      ),
      Visibility(
        visible: widget.canGoToArtist,
        child: ListTile(
          leading: Icon(
            TablerIcons.user,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.goToArtist),
          enabled: widget.canGoToArtist,
          onTap: () async {
            late BaseItemDto artist;
            try {
              if (FinampSettingsHelper.finampSettings.isOffline) {
                final downloadsService = GetIt.instance<DownloadsService>();
                artist = (await downloadsService.getCollectionInfo(
                        id: widget.item.artistItems!.first.id))!
                    .baseItem!;
              } else {
                artist = await _jellyfinApiHelper
                    .getItemById(widget.item.artistItems!.first.id);
              }
            } catch (e) {
              GlobalSnackbar.error(e);
              return;
            }
            if (context.mounted) {
              Navigator.pop(context);
              await Navigator.of(context)
                  .pushNamed(ArtistScreen.routeName, arguments: artist);
            }
          },
        ),
      ),
      Visibility(
        visible: widget.canGoToGenre,
        child: ListTile(
          leading: Icon(
            TablerIcons.color_swatch,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.goToGenre),
          enabled: widget.canGoToGenre,
          onTap: () async {
            late BaseItemDto genre;
            try {
              if (FinampSettingsHelper.finampSettings.isOffline) {
                final downloadsService = GetIt.instance<DownloadsService>();
                genre = (await downloadsService.getCollectionInfo(
                        id: widget.item.genreItems!.first.id))!
                    .baseItem!;
              } else {
                genre = await _jellyfinApiHelper
                    .getItemById(widget.item.genreItems!.first.id);
              }
            } catch (e) {
              GlobalSnackbar.error(e);
              return;
            }
            if (context.mounted) {
              Navigator.pop(context);
              await Navigator.of(context)
                  .pushNamed(GenreScreen.routeName, arguments: genre);
            }
          },
        ),
      ),
      Consumer(builder: (context, ref, _) {
        var canDelete = ref
            .watch(_jellyfinApiHelper.canDeleteFromServerProvider(widget.item));
        return Visibility(
            visible: canDelete,
            child: ListTile(
              leading: Icon(
                Icons.delete_forever,
                color: iconColor,
              ),
              title: Text(AppLocalizations.of(context)!
                  .deleteFromTargetConfirmButton("server")),
              enabled: canDelete,
              onTap: () async {
                var item = DownloadStub.fromItem(
                    type: DownloadItemType.track, item: widget.item);
                await askBeforeDeleteFromServerAndDevice(context, item);
                Navigator.pop(context); // close popup
                musicScreenRefreshStream.add(null);
              },
            ));
      }),
      Visibility(
        visible: widget.showClearQueue,
        child: ListTile(
          leading: Icon(
            TablerIcons.clear_all,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.stopAndClearQueue),
          onTap: () async {
            if (context.mounted) Navigator.pop(context);
            await _queueService.stopPlayback();
          },
        ),
      ),
    ];
  }

  // All track menu slivers, including headers
  List<Widget> menu(BuildContext context, List<Widget> menuEntries,
      MetadataProvider? metadata) {
    var iconColor = Theme.of(context).colorScheme.primary;
    // Define heights for each menu state
    const double closedHeight = 0;
    const double speedMenuHeight = 120;
    const double sleepTimerMenuHeight = 285;
    double menuHeight;
    switch (activeMenu) {
      case SubMenu.speed:
        menuHeight = speedMenuHeight;
        break;
      case SubMenu.sleepTimer:
        menuHeight = sleepTimerMenuHeight;
        break;
      default:
        menuHeight = closedHeight;
    }
    return [
      SliverPersistentHeader(
        delegate: TrackMenuSliverAppBar(
          item: widget.item,
        ),
        pinned: true,
      ),
      if (widget.showPlaybackControls)
        MenuMask(
            height: 135.0,
            child: StreamBuilder<PlaybackBehaviorInfo>(
              stream: Rx.combineLatest3(
                  _queueService.getPlaybackOrderStream(),
                  _queueService.getLoopModeStream(),
                  _queueService.getPlaybackSpeedStream(),
                  (a, b, c) => PlaybackBehaviorInfo(a, b, c)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter();
                }

                final playbackBehavior = snapshot.data!;
                const playbackOrderIcons = {
                  FinampPlaybackOrder.linear: TablerIcons.arrows_right,
                  FinampPlaybackOrder.shuffled: TablerIcons.arrows_shuffle,
                };
                final playbackOrderTooltips = {
                  FinampPlaybackOrder.linear: AppLocalizations.of(context)
                          ?.playbackOrderLinearButtonLabel ??
                      "Playing in order",
                  FinampPlaybackOrder.shuffled: AppLocalizations.of(context)
                          ?.playbackOrderShuffledButtonLabel ??
                      "Shuffling",
                };
                const loopModeIcons = {
                  FinampLoopMode.none: TablerIcons.repeat,
                  FinampLoopMode.one: TablerIcons.repeat_once,
                  FinampLoopMode.all: TablerIcons.repeat,
                };
                final loopModeTooltips = {
                  FinampLoopMode.none:
                      AppLocalizations.of(context)?.loopModeNoneButtonLabel ??
                          "Not looping",
                  FinampLoopMode.one:
                      AppLocalizations.of(context)?.loopModeOneButtonLabel ??
                          "Looping this track",
                  FinampLoopMode.all:
                      AppLocalizations.of(context)?.loopModeAllButtonLabel ??
                          "Looping all",
                };

                var sliverArray = [
                  PlaybackAction(
                    icon: playbackOrderIcons[playbackBehavior.order]!,
                    onPressed: () async {
                      _queueService.togglePlaybackOrder();
                    },
                    tooltip: playbackOrderTooltips[playbackBehavior.order]!,
                    iconColor:
                        playbackBehavior.order == FinampPlaybackOrder.shuffled
                            ? iconColor
                            : Theme.of(context).textTheme.bodyMedium?.color ??
                                Colors.white,
                  ),
                  ValueListenableBuilder<SleepTimer?>(
                    valueListenable: _audioHandler.timer,
                    builder: (context, timerValue, child) {
                      if (timerValue == null) {
                        return PlaybackAction(
                          icon: TablerIcons.bell_z,
                          onPressed: () async {
                            toggleSleepTimerMenu();
                          },
                          tooltip:
                              AppLocalizations.of(context)!.sleepTimerTooltip,
                          iconColor:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Colors.white,
                        );
                      }

                      return ValueListenableBuilder<int>(
                        valueListenable: timerValue.remainingNotifier,
                        builder: (context, remaining, _) {
                          final hasTimeLeft = remaining > 0;
                          return PlaybackAction(
                            icon: TablerIcons.bell_z_filled,
                            onPressed: () async {
                              if (hasTimeLeft) {
                                await showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const SleepTimerCancelDialog(),
                                );
                              } else {
                                toggleSleepTimerMenu();
                              }
                            },
                            tooltip: hasTimeLeft
                                ? timerValue.asString(context)
                                : AppLocalizations.of(context)!
                                    .sleepTimerTooltip,
                            iconColor: hasTimeLeft
                                ? iconColor
                                : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color ??
                                    Colors.white,
                          );
                        },
                      );
                    },
                  ),
                  // [Playback speed widget will be added here if conditions are met]
                  PlaybackAction(
                    icon: loopModeIcons[playbackBehavior.loop]!,
                    onPressed: () async {
                      _queueService.toggleLoopMode();
                    },
                    tooltip: loopModeTooltips[playbackBehavior.loop]!,
                    iconColor: playbackBehavior.loop == FinampLoopMode.none
                        ? Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.white
                        : iconColor,
                  ),
                ];

                final speedWidget = PlaybackAction(
                  icon: TablerIcons.brand_speedtest,
                  onPressed: () {
                    toggleSpeedMenu();
                  },
                  tooltip: AppLocalizations.of(context)!
                      .playbackSpeedButtonLabel(playbackBehavior.speed),
                  iconColor: playbackBehavior.speed == 1.0
                      ? Theme.of(context).textTheme.bodyMedium?.color ??
                          Colors.white
                      : iconColor,
                );

                if (speedWidgetWasVisible ||
                    shouldShowSpeedControls(playbackBehavior.speed, metadata)) {
                  speedWidgetWasVisible = true;
                  sliverArray.insertAll(2, [speedWidget]);
                }

                return SliverCrossAxisGroup(
                  slivers: sliverArray,
                );
              },
            )),
      SliverToBoxAdapter(
        child: ClipRect(
          child: AnimatedSize(
            duration: trackMenuDefaultAnimationDuration,
            curve: Curves.easeInOut,
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: menuHeight,
              child: OverflowBox(
                maxHeight: double.infinity,
                fit: OverflowBoxFit.deferToChild,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: trackMenuDefaultAnimationDuration,
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  transitionBuilder: (child, animation) {
                    if (MediaQuery.of(context).disableAnimations) {
                      return child;
                    }
                    // Determine if this is the incoming or outgoing child
                    final isSpeedMenu = (child.key is ValueKey &&
                        (child.key as ValueKey).value == 'speed');
                    final isSleepMenu = (child.key is ValueKey &&
                        (child.key as ValueKey).value == 'sleep');
                    // Slide in from right for speed, left for sleep
                    final Offset beginOffset =
                        previousMenu == null || activeMenu == null
                            ? Offset(0, 0)
                            : (isSpeedMenu
                                ? const Offset(1, 0)
                                : isSleepMenu
                                    ? const Offset(-1, 0)
                                    : Offset.zero);

                    final Offset endOffset = Offset.zero;
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: beginOffset,
                          end: endOffset,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: switch (activeMenu) {
                    SubMenu.speed => SpeedMenu(
                        key: const ValueKey('speed'),
                        iconColor: iconColor,
                      ),
                    SubMenu.sleepTimer => SleepTimerMenu(
                        key: const ValueKey('sleep'),
                        iconColor: iconColor,
                        onStartTimer: () {
                          toggleSleepTimerMenu();
                        },
                      ),
                    _ => null,
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      MenuMask(
        height: 135.0,
        child: SliverPadding(
          padding: const EdgeInsets.only(left: 8.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(menuEntries),
          ),
        ),
      )
    ];
  }
}

class TrackMenuSliverAppBar extends SliverPersistentHeaderDelegate {
  BaseItemDto item;

  TrackMenuSliverAppBar({
    required this.item,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return TrackInfo(
      item: item,
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 150;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class TrackInfo extends ConsumerStatefulWidget {
  const TrackInfo({
    super.key,
    required this.item,
  }) : condensed = false;

  const TrackInfo.condensed({
    super.key,
    required this.item,
  }) : condensed = true;

  final BaseItemDto item;
  final bool condensed;

  @override
  ConsumerState createState() => _TrackInfoState();
}

class _TrackInfoState extends ConsumerState<TrackInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: widget.condensed ? 28.0 : 12.0),
          height: widget.condensed ? 80 : 120,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.25)
                : Colors.white.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: AlbumImage(
                  item: widget.item,
                  borderRadius: BorderRadius.zero,
                  tapToZoom: true,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.name ??
                            AppLocalizations.of(context)!.unknownName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: widget.condensed ? 16 : 18,
                          height: 1.2,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                      ),
                      Padding(
                        padding: widget.condensed
                            ? const EdgeInsets.only(top: 6.0)
                            : const EdgeInsets.symmetric(vertical: 4.0),
                        child: ArtistChips(
                          baseItem: widget.item,
                          backgroundColor: IconTheme.of(context)
                                  .color
                                  ?.withOpacity(0.1) ??
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              Colors.white,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Colors.white,
                        ),
                      ),
                      if (!widget.condensed)
                        AlbumChips(
                          baseItem: widget.item,
                          backgroundColor: IconTheme.of(context)
                                  .color
                                  ?.withOpacity(0.1) ??
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              Colors.white,
                          key: widget.item.album == null
                              ? null
                              : ValueKey("${widget.item.album}-album"),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaybackAction extends StatelessWidget {
  const PlaybackAction({
    super.key,
    required this.icon,
    this.value,
    required this.onPressed,
    required this.tooltip,
    required this.iconColor,
  });

  final IconData icon;
  final String? value;
  final VoidCallback onPressed;
  final String tooltip;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: IconButton(
        icon: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 35,
              weight: 1.0,
            ),
            const SizedBox(height: 9),
            SizedBox(
              height: 2 * 12 * 1.4 + 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  tooltip,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          FeedbackHelper.feedback(FeedbackType.selection);
          onPressed();
        },
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.only(
            top: 12.0, left: 12.0, right: 12.0, bottom: 16.0),
        tooltip: tooltip,
      ),
    );
  }
}
