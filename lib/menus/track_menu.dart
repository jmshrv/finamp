import 'dart:async';

import 'package:finamp/components/PlayerScreen/queue_list.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_cancel_dialog.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/adaptive_download_lock_delete_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/add_to_playlist_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/clear_queue_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/delete_from_server_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/instant_mix_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/remove_from_current_playlist_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/toggle_favorite_menu_entry.dart';
import 'package:finamp/menus/components/menu_item_info_header.dart';
import 'package:finamp/menus/components/playbackActions/playback_action.dart';
import 'package:finamp/menus/components/playbackActions/playback_actions.dart';
import 'package:finamp/menus/components/speed_menu.dart';
import 'package:finamp/menus/sleep_timer_menu.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/metadata_provider.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'components/menuEntries/menu_entry.dart';

const Duration trackMenuDefaultAnimationDuration = Duration(milliseconds: 500);
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
  final VoidCallback? onRemoveFromList;
  final bool confirmPlaylistRemoval;
  final bool showClearQueue;
  final ScrollBuilder childBuilder;
  final DraggableScrollableController dragController;

  @override
  ConsumerState<TrackMenu> createState() => _TrackMenuState();
}

class _TrackMenuState extends ConsumerState<TrackMenu> with TickerProviderStateMixin {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  // Makes sure that widget doesn't just disappear after press while menu is visible
  bool speedWidgetWasVisible = false;
  SubMenu? activeMenu;
  SubMenu? previousMenu;

  double initialSheetExtent = 0.0;
  double inputStep = 0.9;
  double oldExtent = 0.0;

  // Define heights for each submenu state
  double closedHeight = 0;
  double speedMenuHeight = 120;
  double sleepTimerMenuHeight = 265;

  @override
  void initState() {
    super.initState();

    initialSheetExtent = widget.showPlaybackControls ? 0.6 : 0.45;
    oldExtent = initialSheetExtent;
  }

  bool isBaseItemInQueueItem(BaseItemDto baseItem, FinampQueueItem? queueItem) {
    if (queueItem != null) {
      final baseItem = BaseItemDto.fromJson(queueItem.item.extras!["itemJson"] as Map<String, dynamic>);
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

  bool shouldShowSpeedControls(double currentSpeed, MetadataProvider? metadata) {
    if (currentSpeed != 1.0 ||
        FinampSettingsHelper.finampSettings.playbackSpeedVisibility == PlaybackSpeedVisibility.visible) {
      return true;
    }

    if (FinampSettingsHelper.finampSettings.playbackSpeedVisibility == PlaybackSpeedVisibility.automatic) {
      return metadata?.qualifiesForPlaybackSpeedControl ?? false;
    }

    return false;
  }

  void scrollToExtent(DraggableScrollableController scrollController, double? percentage) {
    var currentSize = scrollController.size;
    if ((percentage != null && currentSize < percentage) || scrollController.size == inputStep) {
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
    final stackHeight = ThemedBottomSheet.calculateStackHeight(
      context: context,
      menuEntries: menuEntries,
      // Include 60 height of shorter track playback row
      extraHeight: widget.showPlaybackControls ? 160 : 60,
      includePlaybackrow: false,
    );

    return Consumer(builder: (context, ref, child) {
      final metadata = ref.watch(currentTrackMetadataProvider).unwrapPrevious();
      return widget.childBuilder(stackHeight, menu(context, menuEntries, metadata.value));
    });
  }

  // Normal track menu entries, excluding headers
  List<HideableMenuEntry> _getMenuEntries(BuildContext context) {
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
      DeleteFromServerMenuEntry(baseItem: widget.item),
      if (widget.showClearQueue) ClearQueueMenuEntry(baseItem: widget.item),
    ];
  }

  // All track menu slivers, including headers
  List<Widget> menu(BuildContext context, List<Widget> menuEntries, MetadataProvider? metadata) {
    var iconColor = Theme.of(context).colorScheme.primary;
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
      if (widget.showPlaybackControls) ...[
        StreamBuilder<PlaybackBehaviorInfo>(
          stream: Rx.combineLatest3(_queueService.getPlaybackOrderStream(), _queueService.getLoopModeStream(),
              _queueService.getPlaybackSpeedStream(), (a, b, c) => PlaybackBehaviorInfo(a, b, c)),
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
              FinampPlaybackOrder.linear: AppLocalizations.of(context)!.playbackOrderLinearButtonLabel,
              FinampPlaybackOrder.shuffled: AppLocalizations.of(context)!.playbackOrderShuffledButtonLabel,
            };
            const loopModeIcons = {
              FinampLoopMode.none: TablerIcons.repeat,
              FinampLoopMode.one: TablerIcons.repeat_once,
              FinampLoopMode.all: TablerIcons.repeat,
            };
            final loopModeTooltips = {
              FinampLoopMode.none: AppLocalizations.of(context)!.loopModeNoneButtonLabel,
              FinampLoopMode.one: AppLocalizations.of(context)!.loopModeOneButtonLabel,
              FinampLoopMode.all: AppLocalizations.of(context)!.loopModeAllButtonLabel,
            };

            var playbackActionsArray = [
              PlaybackAction(
                icon: playbackOrderIcons[playbackBehavior.order]!,
                onPressed: () async {
                  _queueService.togglePlaybackOrder();
                },
                label: playbackOrderTooltips[playbackBehavior.order]!,
                iconColor: playbackBehavior.order == FinampPlaybackOrder.shuffled
                    ? iconColor
                    : Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
                      label: AppLocalizations.of(context)!.sleepTimerTooltip,
                      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
                              builder: (context) => const SleepTimerCancelDialog(),
                            );
                          } else {
                            toggleSleepTimerMenu();
                          }
                        },
                        label: hasTimeLeft
                            ? timerValue.asString(context)
                            : AppLocalizations.of(context)!.sleepTimerTooltip,
                        iconColor:
                            hasTimeLeft ? iconColor : Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
                      );
                    },
                  );
                },
              ),
              PlaybackAction(
                icon: loopModeIcons[playbackBehavior.loop]!,
                onPressed: () async {
                  _queueService.toggleLoopMode();
                },
                label: loopModeTooltips[playbackBehavior.loop]!,
                iconColor: playbackBehavior.loop == FinampLoopMode.none
                    ? Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white
                    : iconColor,
              ),
            ];

            final speedWidget = PlaybackAction(
              icon: TablerIcons.brand_speedtest,
              onPressed: () {
                toggleSpeedMenu();
              },
              label: AppLocalizations.of(context)!.playbackSpeedButtonLabel(playbackBehavior.speed),
              iconColor: playbackBehavior.speed == 1.0
                  ? Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white
                  : iconColor,
            );

            if (speedWidgetWasVisible || shouldShowSpeedControls(playbackBehavior.speed, metadata)) {
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
                      final isSpeedMenu = (child.key is ValueKey && (child.key as ValueKey).value == 'speed');
                      final isSleepMenu = (child.key is ValueKey && (child.key as ValueKey).value == 'sleep');
                      // Slide in from right for speed, left for sleep
                      final Offset beginOffset = previousMenu == null || activeMenu == null
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
                          onSizeChange: (double height) {
                            setState(() {
                              sleepTimerMenuHeight = height;
                            });
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
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Divider(
              color: Theme.of(context).brightness == Brightness.light
                  ? Color.alphaBlend(Theme.of(context).primaryColor.withOpacity(0.6), Colors.black26)
                  : Color.alphaBlend(Theme.of(context).primaryColor.withOpacity(0.8), Colors.white),
              indent: 24.0,
              endIndent: 24.0,
              height: 2.0,
            ),
          ),
        ),
      ],
      SliverPersistentHeader(
        delegate: MenuItemInfoSliverHeader(
          item: widget.item,
        ),
        pinned: true,
      ),
      MenuMask(
        height: MenuItemInfoSliverHeader.defaultHeight,
        child: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PlayPlaybackAction(baseItem: widget.item),
              if (_queueService.getQueue().nextUp.isNotEmpty) PlayNextPlaybackAction(baseItem: widget.item),
              AddToNextUpPlaybackAction(baseItem: widget.item),
              AddToQueuePlaybackAction(baseItem: widget.item),
            ],
          ),
        ),
      ),
      MenuMask(
        height: MenuItemInfoSliverHeader.defaultHeight,
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
