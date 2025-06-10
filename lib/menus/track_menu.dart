import 'dart:async';

import 'package:finamp/menus/components/menuEntries/adaptive_download_lock_delete_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/clear_queue_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/go_to_album_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/instant_mix_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/add_to_playlist_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/delete_from_server_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/go_to_artist_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/go_to_genre_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/remove_from_current_playlist_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/toggle_favorite_menu_entry.dart';
import 'package:finamp/menus/components/menu_item_info_header.dart';
import 'package:finamp/menus/components/playbackActions/playback_action.dart';
import 'package:finamp/menus/components/playbackActions/playback_actions.dart';
import 'package:finamp/menus/components/speed_menu.dart';
import 'package:finamp/components/PlayerScreen/queue_list.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_cancel_dialog.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_dialog.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/metadata_provider.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

const Duration trackMenuDefaultAnimationDuration = Duration(milliseconds: 750);
const Curve trackMenuDefaultInCurve = Curves.easeOutCubic;
const Curve trackMenuDefaultOutCurve = Curves.easeInCubic;

Future<void> showModalTrackMenu({
  required BuildContext context,
  required BaseItemDto item,
  bool showPlaybackControls = false,
  bool isInPlaylist = false,
  BaseItemDto? parentItem,
  VoidCallback? onRemoveFromList,
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
  final VoidCallback? onRemoveFromList;
  final bool confirmPlaylistRemoval;
  final bool showClearQueue;
  final ScrollBuilder childBuilder;
  final DraggableScrollableController dragController;

  @override
  ConsumerState<TrackMenu> createState() => _TrackMenuState();
}

class _TrackMenuState extends ConsumerState<TrackMenu> {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  // Makes sure that widget doesn't just disappear after press while menu is visible
  bool speedWidgetWasVisible = false;
  bool showSpeedMenu = false;

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

  void toggleSpeedMenu() {
    setState(() {
      showSpeedMenu = !showSpeedMenu;
    });
    if (widget.dragController.isAttached) {
      scrollToExtent(widget.dragController, showSpeedMenu ? inputStep : null);
    }
    FeedbackHelper.feedback(FeedbackType.selection);
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
    final menuEntries = _getMenuEntries(context);
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
  List<Widget> _getMenuEntries(BuildContext context) {

    final currentTrack = _queueService.getCurrentTrack();
    FinampQueueItem? queueItem;
    if (isBaseItemInQueueItem(widget.item, currentTrack)) {
      queueItem = currentTrack;
    }

    return [
      AddToPlaylistMenuEntry(
        baseItem: widget.item,
        queueItem: queueItem,
      ),
      RemoveFromCurrentPlaylistMenuEntry(
        baseItem: widget.item,
        parentItem: widget.parentItem,
        confirmRemoval: widget.confirmPlaylistRemoval,
        onRemove: widget.onRemoveFromList,
      ),
      InstantMixMenuEntry(baseItem: widget.item),
      AdaptiveDownloadLockDeleteMenuEntry(baseItem: widget.item),
      ToggleFavoriteMenuEntry(baseItem: widget.item),
      GoToAlbumMenuEntry(baseItem: widget.item),
      GoToArtistMenuEntry(baseItem: widget.item),
      GoToGenreMenuEntry(baseItem: widget.item),
      DeleteFromServerMenuEntry(baseItem: widget.item),
      if (widget.showClearQueue) ClearQueueMenuEntry(baseItem: widget.item),
    ];
  }

  // All track menu slivers, including headers
  List<Widget> menu(BuildContext context, List<Widget> menuEntries,
      MetadataProvider? metadata) {
    var iconColor = Theme.of(context).colorScheme.primary;

    return [
      if (widget.showPlaybackControls)
        StreamBuilder<PlaybackBehaviorInfo>(
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
              FinampPlaybackOrder.linear:
                  AppLocalizations.of(context)!.playbackOrderLinearButtonLabel,
              FinampPlaybackOrder.shuffled: AppLocalizations.of(context)!
                  .playbackOrderShuffledButtonLabel,
            };
            const loopModeIcons = {
              FinampLoopMode.none: TablerIcons.repeat,
              FinampLoopMode.one: TablerIcons.repeat_once,
              FinampLoopMode.all: TablerIcons.repeat,
            };
            final loopModeTooltips = {
              FinampLoopMode.none:
                  AppLocalizations.of(context)!.loopModeNoneButtonLabel,
              FinampLoopMode.one:
                  AppLocalizations.of(context)!.loopModeOneButtonLabel,
              FinampLoopMode.all:
                  AppLocalizations.of(context)!.loopModeAllButtonLabel,
            };
        
            var playbackActionsArray = [
              PlaybackAction(
                icon: playbackOrderIcons[playbackBehavior.order]!,
                onPressed: () async {
                  _queueService.togglePlaybackOrder();
                },
                label: playbackOrderTooltips[playbackBehavior.order]!,
                iconColor:
                    playbackBehavior.order == FinampPlaybackOrder.shuffled
                        ? iconColor
                        : Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.white,
              ),
              ValueListenableBuilder<Timer?>(
                valueListenable: _audioHandler.sleepTimer,
                builder: (context, timerValue, child) {
                  final remainingMinutes =
                      (_audioHandler.sleepTimerRemaining.inSeconds / 60.0)
                          .ceil();
                  return PlaybackAction(
                    icon: timerValue != null
                        ? TablerIcons.hourglass_high
                        : TablerIcons.hourglass_empty,
                    onPressed: () async {
                      if (timerValue != null) {
                        await showDialog<SleepTimerCancelDialog>(
                          context: context,
                          builder: (context) => const SleepTimerCancelDialog(),
                        );
                      } else {
                        await showDialog<SleepTimerDialog>(
                          context: context,
                          builder: (context) => const SleepTimerDialog(),
                        );
                      }
                    },
                    label: timerValue != null
                        ? AppLocalizations.of(context)
                                ?.sleepTimerRemainingTime(remainingMinutes) ??
                            "Sleeping in $remainingMinutes minutes"
                        : AppLocalizations.of(context)!.sleepTimerTooltip,
                    iconColor: timerValue != null
                        ? iconColor
                        : Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.white,
                  );
                },
              ),
              // [Playback speed widget will be added here if conditions are met]
              PlaybackAction(
                icon: loopModeIcons[playbackBehavior.loop]!,
                onPressed: () async {
                  _queueService.toggleLoopMode();
                },
                label: loopModeTooltips[playbackBehavior.loop]!,
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
              label: AppLocalizations.of(context)!
                  .playbackSpeedButtonLabel(playbackBehavior.speed),
              iconColor: playbackBehavior.speed == 1.0
                  ? Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.white
                  : iconColor,
            );
        
            if (speedWidgetWasVisible ||
                shouldShowSpeedControls(playbackBehavior.speed, metadata)) {
              speedWidgetWasVisible = true;
              playbackActionsArray.insertAll(2, [speedWidget]);
            }
        
            return SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: playbackActionsArray,
              ),
            );
          },
        ),
      if (widget.showPlaybackControls)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Divider(
              color: Colors.white.withOpacity(0.2),
              indent: 24.0,
              endIndent: 24.0,
              height: 2.0,
            ),
          ),
        ),
      SliverPersistentHeader(
        delegate: MenuItemInfoSliverHeader(
          item: widget.item,
        ),
        pinned: true,
      ),
      MenuMask(
        height: MenuMask.defaultHeight,
        child: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PlayPlaybackAction(baseItem: widget.item),
              if (_queueService.getQueue().nextUp.isNotEmpty)
                PlayNextPlaybackAction(baseItem: widget.item),
              AddToNextUpPlaybackAction(baseItem: widget.item),
              AddToQueuePlaybackAction(baseItem: widget.item),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: AnimatedSwitcher(
          duration: trackMenuDefaultAnimationDuration,
          switchInCurve: trackMenuDefaultInCurve,
          switchOutCurve: trackMenuDefaultOutCurve,
          transitionBuilder: (child, animation) {
            if (MediaQuery.of(context).disableAnimations) {
              return child;
            }
            return SizeTransition(sizeFactor: animation, child: child);
          },
          child: showSpeedMenu ? SpeedMenu(iconColor: iconColor) : null,
        ),
      ),
      MenuMask(
        height: MenuMask.defaultHeight,
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
