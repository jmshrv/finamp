import 'dart:async';

import 'package:finamp/components/AlbumScreen/speed_menu.dart';
import 'package:finamp/components/PlayerScreen/queue_list.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_cancel_dialog.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_dialog.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/metadata_provider.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:finamp/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/album_screen.dart';
import '../../services/audio_service_helper.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AddToPlaylistScreen/add_to_playlist_list.dart';
import '../PlayerScreen/album_chip.dart';
import '../PlayerScreen/artist_chip.dart';
import '../PlayerScreen/queue_source_helper.dart';
import '../album_image.dart';
import '../global_snackbar.dart';
import 'download_dialog.dart';

const Duration songMenuDefaultAnimationDuration = Duration(milliseconds: 750);
const Curve songMenuDefaultInCurve = Curves.easeOutCubic;
const Curve songMenuDefaultOutCurve = Curves.easeInCubic;

Future<void> showModalSongMenu({
  required BuildContext context,
  required BaseItemDto item,
  bool showPlaybackControls = false,
  bool usePlayerTheme = false,
  bool isInPlaylist = false,
  BaseItemDto? parentItem,
  Function? onRemoveFromList,
  bool confirmPlaylistRemoval = true,
  ImageProvider? cachedImage,
  ThemeProvider? themeProvider,
}) async {
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;
  final canGoToAlbum = item.parentId != null;
  final canGoToArtist = (item.artistItems?.isNotEmpty ?? false);
  final canGoToGenre = (item.genreItems?.isNotEmpty ?? false);

  await showThemedBottomSheet(
      context: context,
      item: item,
      routeName: SongMenu.routeName,
      buildWrapper: (context, imageProvider, childBuilder) {
        return SongMenu(
          key: ValueKey(item.id),
          item: item,
          parentItem: parentItem,
          usePlayerTheme: usePlayerTheme,
          isOffline: isOffline,
          showPlaybackControls: showPlaybackControls,
          isInPlaylist: isInPlaylist,
          canGoToAlbum: canGoToAlbum,
          canGoToArtist: canGoToArtist,
          canGoToGenre: canGoToGenre,
          onRemoveFromList: onRemoveFromList,
          confirmPlaylistRemoval: confirmPlaylistRemoval,
          childBuilder: childBuilder,
          imageProvider: imageProvider,
        );
      },
      usePlayerTheme: usePlayerTheme,
      cachedImage: cachedImage,
      themeProvider: themeProvider);
}

class SongMenu extends ConsumerStatefulWidget {
  static const routeName = "/song-menu";

  const SongMenu({
    super.key,
    required this.item,
    required this.isOffline,
    required this.showPlaybackControls,
    required this.usePlayerTheme,
    required this.isInPlaylist,
    required this.canGoToAlbum,
    required this.canGoToArtist,
    required this.canGoToGenre,
    required this.onRemoveFromList,
    required this.confirmPlaylistRemoval,
    this.parentItem,
    required this.childBuilder,
    required this.imageProvider,
  });

  final BaseItemDto item;
  final BaseItemDto? parentItem;
  final bool isOffline;
  final bool showPlaybackControls;
  final bool usePlayerTheme;
  final bool isInPlaylist;
  final bool canGoToAlbum;
  final bool canGoToArtist;
  final bool canGoToGenre;
  final Function? onRemoveFromList;
  final bool confirmPlaylistRemoval;
  final ScrollBuilder childBuilder;
  final ImageProvider imageProvider;

  @override
  ConsumerState<SongMenu> createState() => _SongMenuState();
}

class _SongMenuState extends ConsumerState<SongMenu> {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  // Makes sure that widget doesn't just disappear after press while menu is visible
  bool speedWidgetWasVisible = false;
  bool showSpeedMenu = false;
  final dragController = DraggableScrollableController();
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
      final baseItem = BaseItemDto.fromJson(queueItem.item.extras!["itemJson"]);
      return baseItem.id == queueItem.id;
    }
    return false;
  }

  /// Sets the item's favourite on the Jellyfin server.
  Future<void> toggleFavorite() async {
    try {
      final isOffline = FinampSettingsHelper.finampSettings.isOffline;

      if (isOffline) {
        FeedbackHelper.feedback(FeedbackType.error);
        GlobalSnackbar.message((context) =>
            AppLocalizations.of(context)!.notAvailableInOfflineMode);
        return;
      }

      final currentTrack = _queueService.getCurrentTrack();
      if (isBaseItemInQueueItem(widget.item, currentTrack)) {
        await setFavourite(currentTrack!, context);
        FeedbackHelper.feedback(FeedbackType.success);
        return;
      }

      // We switch the widget state before actually doing the request to
      // make the app feel faster (without, there is a delay from the
      // user adding the favourite and the icon showing)
      setState(() {
        widget.item.userData!.isFavorite = !widget.item.userData!.isFavorite;
      });
      FeedbackHelper.feedback(FeedbackType.success);

      // Since we flipped the favourite state already, we can use the flipped
      // state to decide which API call to make
      final newUserData = widget.item.userData!.isFavorite
          ? await _jellyfinApiHelper.addFavourite(widget.item.id)
          : await _jellyfinApiHelper.removeFavourite(widget.item.id);

      if (!mounted) return;

      setState(() {
        widget.item.userData = newUserData;
      });
    } catch (e) {
      setState(() {
        widget.item.userData!.isFavorite = !widget.item.userData!.isFavorite;
      });
      FeedbackHelper.feedback(FeedbackType.error);
      GlobalSnackbar.error(e);
    }
  }

  void toggleSpeedMenu() {
    setState(() {
      showSpeedMenu = !showSpeedMenu;
    });
    if (dragController.isAttached) {
      scrollToExtent(dragController, showSpeedMenu ? inputStep : null);
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
      scrollController.animateTo(
        percentage ?? oldExtent,
        duration: songMenuDefaultAnimationDuration,
        curve: songMenuDefaultInCurve,
      );
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

  // Normal song menu entries, excluding headers
  List<Widget> _menuEntries(BuildContext context) {
    final downloadsService = GetIt.instance<DownloadsService>();
    final downloadStatus = downloadsService.getStatus(
        DownloadStub.fromItem(type: DownloadItemType.song, item: widget.item),
        null);
    var iconColor = Theme.of(context).colorScheme.primary;

    final currentTrack = _queueService.getCurrentTrack();
    FinampQueueItem? queueItem;
    if (isBaseItemInQueueItem(widget.item, currentTrack)) {
      queueItem = currentTrack;
    }

    String? parentTooltip;
    if (downloadStatus.isIncidental) {
      var parent = downloadsService.getFirstRequiringItem(DownloadStub.fromItem(
          type: DownloadItemType.song, item: widget.item));
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
          title: Text(AppLocalizations.of(context)!.addToPlaylistTitle),
          enabled: !widget.isOffline,
          onTap: ()  {
            Navigator.pop(context); // close menu
            bool inPlaylist = queueItemInPlaylist(queueItem);
            showPlaylistActionsMenu(
              context: context,
              item: widget.item,
              parentPlaylist: inPlaylist ? queueItem!.source.item : null,
              usePlayerTheme: widget.usePlayerTheme,
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
        visible: widget.isInPlaylist && widget.parentItem != null,
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
            var removed = await removeFromPlaylist(
                context, widget.item, widget.parentItem!,
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
          title: Text(AppLocalizations.of(context)!.deleteItem),
          enabled: downloadStatus.isRequired,
          onTap: () async {
            var item = DownloadStub.fromItem(
                type: DownloadItemType.song, item: widget.item);
            unawaited(downloadsService.deleteDownload(stub: item));
            if (mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
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
                type: DownloadItemType.song, item: widget.item);
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
                  type: DownloadItemType.song, item: widget.item);
              await DownloadDialog.show(context, item, null);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      ListTile(
        enabled: !widget.isOffline,
        leading: widget.item.userData!.isFavorite
            ? Icon(
                Icons.favorite,
                color:
                    widget.isOffline ? iconColor.withOpacity(0.3) : iconColor,
              )
            : Icon(
                Icons.favorite_border,
                color:
                    widget.isOffline ? iconColor.withOpacity(0.3) : iconColor,
              ),
        title: Text(widget.item.userData!.isFavorite
            ? AppLocalizations.of(context)!.removeFavourite
            : AppLocalizations.of(context)!.addFavourite),
        onTap: () async {
          await toggleFavorite();
          if (context.mounted) Navigator.pop(context);
        },
      ),
      Visibility(
        visible: widget.canGoToAlbum,
        child: ListTile(
          leading: Icon(
            Icons.album,
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
            Icons.person,
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
            Icons.category_outlined,
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
                  .pushNamed(ArtistScreen.routeName, arguments: genre);
            }
          },
        ),
      ),
    ];
  }

  // All song menu slivers, including headers
  List<Widget> menu(BuildContext context, List<Widget> menuEntries,
      MetadataProvider? metadata) {
    var iconColor = Theme.of(context).colorScheme.primary;
    return [
      SliverPersistentHeader(
        delegate: SongMenuSliverAppBar(
          item: widget.item,
          headerImage: widget.usePlayerTheme ? widget.imageProvider : null,
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
                          "Looping off",
                  FinampLoopMode.one:
                      AppLocalizations.of(context)?.loopModeOneButtonLabel ??
                          "Looping this song",
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
                            await showDialog(
                              context: context,
                              builder: (context) =>
                                  const SleepTimerCancelDialog(),
                            );
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) => const SleepTimerDialog(),
                            );
                          }
                        },
                        tooltip: timerValue != null
                            ? AppLocalizations.of(context)
                                    ?.sleepTimerRemainingTime(
                                        remainingMinutes) ??
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
        child: AnimatedSwitcher(
          duration: songMenuDefaultAnimationDuration,
          switchInCurve: songMenuDefaultInCurve,
          switchOutCurve: songMenuDefaultOutCurve,
          transitionBuilder: (child, animation) {
            return SizeTransition(sizeFactor: animation, child: child);
          },
          child: showSpeedMenu ? SpeedMenu(iconColor: iconColor) : null,
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

class SongMenuSliverAppBar extends SliverPersistentHeaderDelegate {
  BaseItemDto item;
  ImageProvider? headerImage;

  SongMenuSliverAppBar({
    required this.item,
    this.headerImage,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SongInfo(
      item: item,
      headerImage: headerImage,
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

class SongInfo extends ConsumerStatefulWidget {
  const SongInfo({
    required this.item,
    this.headerImage,
  });

  final BaseItemDto item;
  final ImageProvider? headerImage;

  @override
  ConsumerState createState() => _SongInfoState();
}

class _SongInfoState extends ConsumerState<SongInfo> {
  // Wrap a static imageProvider to give to AlbumImage  Do not watch player image
  // provider because the song menu does not update on track changes.
  static final _imageProvider = Provider.autoDispose
      .family<ImageProvider, ImageProvider>((ref, value) => value);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          height: 120,
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
              SizedBox(
                width: 120,
                height: 120,
                child: AlbumImage(
                  // Only supply one of item or imageListenable
                  item: widget.headerImage == null ? widget.item : null,
                  imageListenable: widget.headerImage == null
                      ? null
                      : _imageProvider(widget.headerImage!),
                  borderRadius: BorderRadius.zero,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.name ??
                            AppLocalizations.of(context)!.unknownName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
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
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                      AlbumChip(
                        item: widget.item,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.white,
                        backgroundColor:
                            IconTheme.of(context).color?.withOpacity(0.1) ??
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                Colors.white,
                        key: widget.item.album == null
                            ? null
                            : ValueKey("${widget.item.album}-album"),
                      ),
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
  final Function() onPressed;
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
          FeedbackHelper.feedback(FeedbackType.success);
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

const quickActionsMenuRouteName = "/playlist-actions-menu";

Future<void> showPlaylistActionsMenu({
  required BuildContext context,
  required BaseItemDto item,
  required BaseItemDto? parentPlaylist,
  bool usePlayerTheme = false,
  Function? onRemoveFromList,
  bool confirmPlaylistRemoval = false,
  ImageProvider? cachedImage,
  ThemeProvider? themeProvider,
}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;

  FeedbackHelper.feedback(FeedbackType.selection);

  await showThemedBottomSheet(
      context: context,
      item: item,
      routeName: SongMenu.routeName,
      minDraggableHeight: 0.2,
      buildSlivers: (context, imageProvider) {
        var themeColor = Theme.of(context).colorScheme.primary;
        bool isFavorite = item.userData?.isFavorite ?? false;

        final menuEntries = [
          SongInfo(
            item: item,
            headerImage: usePlayerTheme ? imageProvider : null,
          ),
          const SizedBox(height: 10),
          ToggleableListTile(
            title: AppLocalizations.of(context)!.favourites,
            leading: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.3),
              ),
              child: const Center(
                child: Icon(
                  TablerIcons.heart,
                  size: 36.0,
                  color: Colors.white,
                ),
              ),
            ),
            positiveIcon: TablerIcons.heart_filled,
            negativeIcon: TablerIcons.heart,
            initialState: isFavorite,
            onToggle: (bool currentState) async {
              if (isOffline) {
                FeedbackHelper.feedback(FeedbackType.error);
                GlobalSnackbar.message((context) =>
                    AppLocalizations.of(context)!.notAvailableInOfflineMode);
                return currentState;
              }

              UserItemDataDto? newUserData;
              if (currentState) {
                newUserData = await jellyfinApiHelper.removeFavourite(item.id);
              } else {
                newUserData =
                    await jellyfinApiHelper.addFavourite(item.id);
              }
              item.userData = newUserData;

              final currentTrackItem = BaseItemDto.fromJson(audioHandler.mediaItem.valueOrNull!.extras!['itemJson']);
              if (currentTrackItem.id == item.id) {
                audioHandler.mediaItem.valueOrNull!.extras!['itemJson'] = item.toJson();
              }

              return newUserData.isFavorite;
            },
            enabled: !isOffline,
            accentColor: themeColor,
          ),
          if (parentPlaylist != null)
            ToggleableListTile(
              title: parentPlaylist.name ?? AppLocalizations.of(context)!.unknownName,
              subtitle: AppLocalizations.of(context)!.songCount(parentPlaylist.childCount ?? 0),
              leading: AlbumImage(item: parentPlaylist),
              positiveIcon: TablerIcons.circle_check_filled,
              negativeIcon: TablerIcons.circle_plus,
              initialState: parentPlaylist != null,
              onToggle: (bool currentState) async {
                bool isPartOfPlaylist = currentState;
                if (currentState) {
                  // part of playlist, remove
                  bool removed = await removeFromPlaylist(
                      context, item, parentPlaylist,
                      confirm: confirmPlaylistRemoval);
                  if (removed) {
                    if (onRemoveFromList != null) {
                      onRemoveFromList();
                    }
                  }
                  isPartOfPlaylist = !removed;
                } else {
                  // add back to playlist
                  bool added = await addItemToPlaylist(context, item, parentPlaylist);
                  isPartOfPlaylist = added;
                }

                return isPartOfPlaylist;
              },
              enabled: !isOffline,
              accentColor: themeColor,
            ),
        ];

        var menu = [
          SliverStickyHeader(
            header: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 3.5,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).textTheme.bodySmall!.color!,
                      borderRadius: BorderRadius.circular(3.5),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text("Add To / Remove From Playlists",
                      style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!,
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
            sliver: MenuMask(
                height: 45.0,
                child: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                  menuEntries,
                ))),
          ),
          SliverStickyHeader(
              header: Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
                child: Text("Add track to a playlist",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              sliver: MenuMask(
                height: 55.0,
                child: AddToPlaylistList(
                  itemToAdd: item,
                  accentColor: themeColor,
                  partOfPlaylists: parentPlaylist != null ? [parentPlaylist] : [],
                ),
              )),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100.0))
        ];
        // TODO better estimate, how to deal with lag getting playlists?
        var stackHeight = MediaQuery.sizeOf(context).height * 0.9;
        return (stackHeight, menu);
      },
      usePlayerTheme: usePlayerTheme,
      cachedImage: cachedImage,
      themeProvider: themeProvider);
}

class ToggleableListTile extends StatefulWidget {
  const ToggleableListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    required this.positiveIcon,
    required this.negativeIcon,
    required this.initialState,
    required this.onToggle,
    required this.enabled,
    required this.accentColor,
  });

  final String title;
  final String? subtitle;
  final Widget leading;
  final IconData positiveIcon;
  final IconData negativeIcon;
  final bool initialState;
  final Future<bool> Function(bool currentState) onToggle;
  final bool enabled;
  final Color accentColor;

  @override
  State<ToggleableListTile> createState() => _ToggleableListTileState();
}

class _ToggleableListTileState extends State<ToggleableListTile> {

  bool isLoading = false;
  bool currentState = false;

  @override
  void initState() {
    super.initState();
    currentState = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
      child: Container(
        decoration: ShapeDecoration(
          color: widget.accentColor.withOpacity(currentState ? 0.3 : 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.zero,
        child: ListTile(
          enableFeedback: true,
          enabled: widget.enabled,
          leading: widget.leading,
          title: Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (widget.subtitle != null)
                Text(
                  widget.subtitle!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              SizedBox(
                height: 48.0,
                width: 16.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: VerticalDivider(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                      thickness: 1.5,
                      indent: 8.0,
                      endIndent: 8.0,
                      width: 1.0,
                    ),
                ),
              ),
              isLoading ? 
                const CircularProgressIndicator() :
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                  child: Icon(
                    currentState == true ? widget.positiveIcon : widget.negativeIcon,
                    size: 36.0,
                    color: widget.accentColor,
                  ),
                ),
            ]
          ),
          onTap: () async {
            try {
              setState(() {
                isLoading = true;
              });
              final result = await widget.onToggle(currentState);
              FeedbackHelper.feedback(FeedbackType.success);
              setState(() {
                isLoading = false;
                currentState = result;
              });
            } catch(e) {
              setState(() {
                isLoading = false;
              });
              GlobalSnackbar.error(e);
            }
          },
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          // visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
        ),
      ),
    );
  }
}
