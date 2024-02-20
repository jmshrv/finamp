import 'dart:async';

import 'package:finamp/components/PlayerScreen/queue_list.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_cancel_dialog.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_dialog.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/screens/blurred_player_screen_background.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/add_to_playlist_screen.dart';
import '../../screens/album_screen.dart';
import '../../services/audio_service_helper.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/player_screen_theme_provider.dart';
import '../PlayerScreen/album_chip.dart';
import '../PlayerScreen/artist_chip.dart';
import '../album_image.dart';
import '../global_snackbar.dart';
import 'download_dialog.dart';
import 'song_list_tile.dart';
import 'speed_menu.dart';

const Duration songMenuDefaultAnimationDuration = Duration(milliseconds: 350);
const Curve songMenuDefaultInCurve = Curves.easeOutCubic;
const Curve songMenuDefaultOutCurve = Curves.easeInCubic;

Future<void> showModalSongMenu({
  required BuildContext context,
  required BaseItemDto item,
  ColorScheme? playerScreenTheme,
  bool showPlaybackControls = false,
  bool isInPlaylist = false,
  Function? onRemoveFromList,
}) async {
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;
  final canGoToAlbum = item.parentId != null;
  final canGoToArtist = (item.artistItems?.isNotEmpty ?? false);
  final canGoToGenre = (item.genreItems?.isNotEmpty ?? false);

  Vibrate.feedback(FeedbackType.impact);

  await showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: (Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black)
          .withOpacity(0.9),
      useSafeArea: true,
      builder: (BuildContext context) {
        return SongMenu(
          item: item,
          playerScreenTheme: playerScreenTheme,
          isOffline: isOffline,
          showPlaybackControls: showPlaybackControls,
          isInPlaylist: isInPlaylist,
          canGoToAlbum: canGoToAlbum,
          canGoToArtist: canGoToArtist,
          canGoToGenre: canGoToGenre,
          onRemoveFromList: onRemoveFromList,
        );
      });
}

class SongMenu extends StatefulWidget {
  const SongMenu({
    super.key,
    required this.item,
    required this.isOffline,
    required this.showPlaybackControls,
    required this.isInPlaylist,
    required this.canGoToAlbum,
    required this.canGoToArtist,
    required this.canGoToGenre,
    required this.onRemoveFromList,
    this.playerScreenTheme,
  });

  final BaseItemDto item;
  final bool isOffline;
  final bool showPlaybackControls;
  final bool isInPlaylist;
  final bool canGoToAlbum;
  final bool canGoToArtist;
  final bool canGoToGenre;
  final Function? onRemoveFromList;
  final ColorScheme? playerScreenTheme;

  @override
  State<SongMenu> createState() => _SongMenuState();
}

bool isBaseItemInQueueItem(BaseItemDto baseItem, FinampQueueItem? queueItem) {
  if (queueItem != null) {
    final baseItem = BaseItemDto.fromJson(queueItem.item.extras!["itemJson"]);
    return baseItem.id == queueItem.id;
  }
  return false;
}

class _SongMenuState extends State<SongMenu> {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  ColorScheme? _imageTheme;
  ImageProvider? _imageProvider;

  // Makes sure that widget doesn't just disappear after press while menu is visible
  var speedWidgetWasVisible = false;
  var showSpeedMenu = false;
  final dragController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _imageTheme =
        widget.playerScreenTheme; // use player screen theme if provided
  }

  /// Sets the item's favourite on the Jellyfin server.
  Future<void> toggleFavorite() async {
    try {
      final currentTrack = _queueService.getCurrentTrack();
      if (isBaseItemInQueueItem(widget.item, currentTrack)) {
        setFavourite(currentTrack!, context);
        Vibrate.feedback(FeedbackType.success);
        return;
      }

      // We switch the widget state before actually doing the request to
      // make the app feel faster (without, there is a delay from the
      // user adding the favourite and the icon showing)
      setState(() {
        widget.item.userData!.isFavorite = !widget.item.userData!.isFavorite;
      });
      Vibrate.feedback(FeedbackType.success);

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
      Vibrate.feedback(FeedbackType.error);
      GlobalSnackbar.error(e);
    }
  }

  Future<bool> shouldShowSpeedWidget(currentSpeed) async {
    if (currentSpeed != 1.0 ||
        FinampSettingsHelper.finampSettings.contentPlaybackSpeedType.index ==
            1) {
      return true;
    }
    if (FinampSettingsHelper.finampSettings.contentPlaybackSpeedType.index ==
        0) {
      var genres = widget.item.genres!;

      for (var i = 0; i < genres.length; i++) {
        if (["audiobook", "speech"].contains(genres[i].toLowerCase())) {
          return true;
        }
      }

      try {
        var parent =
            await _jellyfinApiHelper.getItemById(widget.item.parentId!);
        if (parent.runTimeTicks! > 72e9.toInt()) {
          return true;
        }
      } catch (e) {
        GlobalSnackbar.error(e);
      }
    }

    return false;
  }

  final inputStep = 0.9;
  var oldExtent = 0.0;

  void toggleSpeedMenu() {
    setState(() {
      showSpeedMenu = !showSpeedMenu;
    });
    scrollToExtent(dragController, showSpeedMenu ? inputStep : null);
    Vibrate.feedback(FeedbackType.selection);
  }

  scrollToExtent(
      DraggableScrollableController scrollController, double? percentage) {
    var currentSize = scrollController.size;
    if (percentage != null &&
            (percentage != inputStep || currentSize < percentage) ||
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
    final iconColor = _imageTheme?.primary ??
        Theme.of(context).iconTheme.color ??
        Colors.white;

    final downloadsService = GetIt.instance<DownloadsService>();
    final bool isDownloadRequired = downloadsService
        .getStatus(
            DownloadStub.fromItem(
                type: DownloadItemType.song, item: widget.item),
            null)
        .isRequired;

    return Stack(children: [
      DraggableScrollableSheet(
        controller: dragController,
        snap: true,
        snapSizes: widget.showPlaybackControls ? const [0.6] : const [0.45],
        initialChildSize: widget.showPlaybackControls ? 0.6 : 0.45,
        minChildSize: 0.15,
        expand: false,
        builder: (context, scrollController) {
          return Stack(
            children: [
              if (FinampSettingsHelper
                  .finampSettings.showCoverAsPlayerBackground)
                BlurredPlayerScreenBackground(
                    customImageProvider: _imageProvider,
                    opacityFactor:
                        Theme.of(context).brightness == Brightness.dark
                            ? 1.0
                            : 1.0),
              CustomScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    delegate: SongMenuSliverAppBar(
                      item: widget.item,
                      theme: _imageTheme,
                      imageProviderCallback: (ImageProvider provider) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _imageProvider = provider;
                            });
                          }
                        });
                      },
                      imageThemeCallback: (ColorScheme colorScheme) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _imageTheme = colorScheme;
                            });
                          }
                        });
                      },
                    ),
                    pinned: true,
                  ),
                  if (widget.showPlaybackControls)
                    StreamBuilder<PlaybackBehaviorInfo>(
                      stream: Rx.combineLatest3(
                          _queueService.getPlaybackOrderStream(),
                          _queueService.getLoopModeStream(),
                          _queueService.getPlaybackSpeedStream(),
                          (a, b, c) => PlaybackBehaviorInfo(a, b, c)),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const SliverToBoxAdapter();

                        final playbackBehavior = snapshot.data!;
                        const playbackOrderIcons = {
                          FinampPlaybackOrder.linear: TablerIcons.arrows_right,
                          FinampPlaybackOrder.shuffled:
                              TablerIcons.arrows_shuffle,
                        };
                        final playbackOrderTooltips = {
                          FinampPlaybackOrder.linear:
                              AppLocalizations.of(context)
                                      ?.playbackOrderLinearButtonLabel ??
                                  "Playing in order",
                          FinampPlaybackOrder.shuffled:
                              AppLocalizations.of(context)
                                      ?.playbackOrderShuffledButtonLabel ??
                                  "Shuffling",
                        };
                        final playbackSpeedTooltip =
                            AppLocalizations.of(context)
                                    ?.playbackSpeedButtonLabel(
                                        playbackBehavior.speed) ??
                                "Playing at x${playbackBehavior.speed} speed";
                        const loopModeIcons = {
                          FinampLoopMode.none: TablerIcons.repeat,
                          FinampLoopMode.one: TablerIcons.repeat_once,
                          FinampLoopMode.all: TablerIcons.repeat,
                        };
                        final loopModeTooltips = {
                          FinampLoopMode.none: AppLocalizations.of(context)
                                  ?.loopModeNoneButtonLabel ??
                              "Looping off",
                          FinampLoopMode.one: AppLocalizations.of(context)
                                  ?.loopModeOneButtonLabel ??
                              "Looping this song",
                          FinampLoopMode.all: AppLocalizations.of(context)
                                  ?.loopModeAllButtonLabel ??
                              "Looping all",
                        };

                        var sliverArray = [
                          PlaybackAction(
                            icon: playbackOrderIcons[playbackBehavior.order]!,
                            onPressed: () async {
                              _queueService.togglePlaybackOrder();
                            },
                            tooltip:
                                playbackOrderTooltips[playbackBehavior.order]!,
                            iconColor: playbackBehavior.order ==
                                    FinampPlaybackOrder.shuffled
                                ? iconColor
                                : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color ??
                                    Colors.white,
                          ),
                          ValueListenableBuilder<Timer?>(
                            valueListenable: _audioHandler.sleepTimer,
                            builder: (context, timerValue, child) {
                              final remainingMinutes =
                                  (_audioHandler.sleepTimerRemaining.inSeconds /
                                          60.0)
                                      .ceil();
                              return PlaybackAction(
                                icon: timerValue != null
                                    ? TablerIcons.hourglass_high
                                    : TablerIcons.hourglass_empty,
                                onPressed: () async {
                                  if (timerValue != null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const SleepTimerCancelDialog(),
                                    );
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const SleepTimerDialog(),
                                    );
                                  }
                                },
                                tooltip: timerValue != null
                                    ? AppLocalizations.of(context)
                                            ?.sleepTimerRemainingTime(
                                                remainingMinutes) ??
                                        "Sleeping in $remainingMinutes minutes"
                                    : AppLocalizations.of(context)!
                                        .sleepTimerTooltip,
                                iconColor: timerValue != null
                                    ? iconColor
                                    : Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color ??
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
                            iconColor:
                                playbackBehavior.loop == FinampLoopMode.none
                                    ? Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color ??
                                        Colors.white
                                    : iconColor,
                          ),
                        ];

                        final speedWidget = PlaybackAction(
                          icon: TablerIcons.brand_speedtest,
                          onPressed: () {
                            toggleSpeedMenu();
                          },
                          tooltip: playbackSpeedTooltip,
                          iconColor: playbackBehavior.speed == 1.0
                              ? Theme.of(context).textTheme.bodyMedium?.color ??
                                  Colors.white
                              : iconColor,
                        );

                        if (speedWidgetWasVisible) {
                          sliverArray.insertAll(2, [speedWidget]);
                          return SliverCrossAxisGroup(
                            slivers: sliverArray,
                          );
                        }
                        return FutureBuilder<bool>(
                            future:
                                shouldShowSpeedWidget(playbackBehavior.speed),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data == true) {
                                speedWidgetWasVisible = true;
                                sliverArray.insertAll(2, [speedWidget]);
                              }
                              return SliverCrossAxisGroup(
                                slivers: sliverArray,
                              );
                            });
                      },
                    ),
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
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 8.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        ListTile(
                          leading: widget.item.userData!.isFavorite
                              ? Icon(
                                  Icons.favorite,
                                  color: iconColor,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: iconColor,
                                ),
                          title: Text(widget.item.userData!.isFavorite
                              ? AppLocalizations.of(context)!.removeFavourite
                              : AppLocalizations.of(context)!.addFavourite),
                          onTap: () async {
                            await toggleFavorite();
                            if (mounted) Navigator.pop(context);
                          },
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

                              if (!mounted) return;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    AppLocalizations.of(context)!.addedToQueue),
                              ));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            TablerIcons.corner_right_down_double,
                            color: iconColor,
                          ),
                          title:
                              Text(AppLocalizations.of(context)!.addToNextUp),
                          onTap: () async {
                            await _queueService.addToNextUp(
                                items: [widget.item],
                                source: QueueItemSource(
                                    type: QueueItemSourceType.nextUp,
                                    name: const QueueItemSourceName(
                                        type: QueueItemSourceNameType.nextUp),
                                    id: widget.item.id));

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.addedToQueue),
                            ));
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
                                    name: const QueueItemSourceName(
                                        type: QueueItemSourceNameType.queue),
                                    id: widget.item.id));

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.addedToQueue),
                            ));
                            Navigator.pop(context);
                          },
                        ),
                        Visibility(
                          visible: widget.isInPlaylist && !widget.isOffline,
                          child: ListTile(
                            leading: Icon(
                              Icons.playlist_remove,
                              color: iconColor,
                            ),
                            title: Text(AppLocalizations.of(context)!
                                .removeFromPlaylistTitle),
                            enabled: !widget.isOffline &&
                                widget.item.parentId != null,
                            onTap: () async {
                              try {
                                await _jellyfinApiHelper
                                    .removeItemsFromPlaylist(
                                        playlistId: widget.item.parentId!,
                                        entryIds: [
                                      widget.item.playlistItemId!
                                    ]);

                                if (!mounted) return;

                                await _jellyfinApiHelper.getItems(
                                  parentItem: await _jellyfinApiHelper
                                      .getItemById(widget.item.parentId!),
                                  sortBy:
                                      "ParentIndexNumber,IndexNumber,SortName",
                                  includeItemTypes: "Audio",
                                );

                                if (!mounted) return;

                                if (widget.onRemoveFromList != null)
                                  widget.onRemoveFromList!();

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(AppLocalizations.of(context)!
                                      .removedFromPlaylist),
                                ));
                                Navigator.pop(context);
                              } catch (e) {
                                GlobalSnackbar.error(e);
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: !widget.isOffline,
                          child: ListTile(
                            leading: Icon(
                              Icons.playlist_add,
                              color: iconColor,
                            ),
                            title: Text(AppLocalizations.of(context)!
                                .addToPlaylistTitle),
                            enabled: !widget.isOffline,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamed(
                                  AddToPlaylistScreen.routeName,
                                  arguments: widget.item.id);
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
                            title:
                                Text(AppLocalizations.of(context)!.instantMix),
                            enabled: !widget.isOffline,
                            onTap: () async {
                              await _audioServiceHelper
                                  .startInstantMixForItem(widget.item);

                              if (!mounted) return;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .startingInstantMix),
                              ));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.canGoToAlbum,
                          child: ListTile(
                            leading: Icon(
                              Icons.album,
                              color: iconColor,
                            ),
                            title:
                                Text(AppLocalizations.of(context)!.goToAlbum),
                            enabled: widget.canGoToAlbum,
                            onTap: () async {
                              late BaseItemDto album;
                              try {
                                if (FinampSettingsHelper
                                    .finampSettings.isOffline) {
                                  final downloadsService =
                                      GetIt.instance<DownloadsService>();
                                  album =
                                      (await downloadsService.getCollectionInfo(
                                              id: widget.item.parentId!))!
                                          .baseItem!;
                                } else {
                                  album = await _jellyfinApiHelper
                                      .getItemById(widget.item.parentId!);
                                }
                              } catch (e) {
                                GlobalSnackbar.error(e);
                                return;
                              }
                              if (mounted) {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(
                                    AlbumScreen.routeName,
                                    arguments: album);
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
                            title:
                                Text(AppLocalizations.of(context)!.goToArtist),
                            enabled: widget.canGoToArtist,
                            onTap: () async {
                              late BaseItemDto artist;
                              try {
                                if (FinampSettingsHelper
                                    .finampSettings.isOffline) {
                                  final downloadsService =
                                      GetIt.instance<DownloadsService>();
                                  artist =
                                      (await downloadsService.getCollectionInfo(
                                              id: widget
                                                  .item.artistItems!.first.id))!
                                          .baseItem!;
                                } else {
                                  artist = await _jellyfinApiHelper.getItemById(
                                      widget.item.artistItems!.first.id);
                                }
                              } catch (e) {
                                GlobalSnackbar.error(e);
                                return;
                              }
                              if (mounted) {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(
                                    ArtistScreen.routeName,
                                    arguments: artist);
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
                            title:
                                Text(AppLocalizations.of(context)!.goToGenre),
                            enabled: widget.canGoToGenre,
                            onTap: () async {
                              late BaseItemDto genre;
                              try {
                                if (FinampSettingsHelper
                                    .finampSettings.isOffline) {
                                  final downloadsService =
                                      GetIt.instance<DownloadsService>();
                                  genre =
                                      (await downloadsService.getCollectionInfo(
                                              id: widget
                                                  .item.genreItems!.first.id))!
                                          .baseItem!;
                                } else {
                                  genre = await _jellyfinApiHelper.getItemById(
                                      widget.item.genreItems!.first.id);
                                }
                              } catch (e) {
                                GlobalSnackbar.error(e);
                                return;
                              }
                              if (mounted) {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(
                                    ArtistScreen.routeName,
                                    arguments: genre);
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: isDownloadRequired,
                          // TODO add some sort of disabled state with tooltip saying to delete the parent
                          // Need to do on other delete buttons too
                          // Do we want to try showing lock on right clicks?
                          // Currently only download or delete are shown.
                          child: ListTile(
                            leading: Icon(
                              Icons.delete_outlined,
                              color: iconColor,
                            ),
                            title:
                                Text(AppLocalizations.of(context)!.deleteItem),
                            enabled: !widget.isOffline && isDownloadRequired,
                            onTap: () async {
                              var item = DownloadStub.fromItem(
                                  type: DownloadItemType.song,
                                  item: widget.item);
                              unawaited(
                                  downloadsService.deleteDownload(stub: item));
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: !widget.isOffline && !isDownloadRequired,
                          child: ListTile(
                            leading: Icon(
                              Icons.file_download_outlined,
                              color: iconColor,
                            ),
                            title: Text(
                                AppLocalizations.of(context)!.downloadItem),
                            enabled: !widget.isOffline && !isDownloadRequired,
                            onTap: () async {
                              var item = DownloadStub.fromItem(
                                  type: DownloadItemType.song,
                                  item: widget.item);
                              await DownloadDialog.show(context, item, null);
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    ]);
  }
}

class SongMenuSliverAppBar extends SliverPersistentHeaderDelegate {
  BaseItemDto item;
  final ColorScheme? theme;
  final Function(ColorScheme)? imageThemeCallback;
  final Function(ImageProvider)? imageProviderCallback;

  SongMenuSliverAppBar({
    required this.item,
    required this.theme,
    this.imageThemeCallback,
    this.imageProviderCallback,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _SongInfo(
      item: item,
      theme: theme,
      imageThemeCallback: imageThemeCallback,
      imageProviderCallback: imageProviderCallback,
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _SongInfo extends ConsumerStatefulWidget {
  const _SongInfo({
    required this.item,
    required this.theme,
    this.imageThemeCallback,
    this.imageProviderCallback,
  });

  final BaseItemDto item;
  final ColorScheme? theme;
  final Function(ColorScheme)? imageThemeCallback;
  final Function(ImageProvider)? imageProviderCallback;

  @override
  ConsumerState<_SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends ConsumerState<_SongInfo> {
  final _queueService = GetIt.instance<QueueService>();

  VoidCallback? onDispose;
  bool waitingForTheme = false;

  @override
  void dispose() {
    onDispose?.call();
    super.dispose();
  }

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
                  item: widget.item,
                  borderRadius: BorderRadius.zero,
                  autoScale:
                      false, // use the maximum resolution, so that the generated color scheme is consistent with the player screen
                  imageProviderCallback: (imageProvider) async {
                    if (widget.theme == null && imageProvider != null) {
                      if (widget.imageProviderCallback != null) {
                        widget.imageProviderCallback!(imageProvider);
                      }

                      ImageStream stream = imageProvider.resolve(
                          const ImageConfiguration(devicePixelRatio: 1.0));
                      ImageStreamListener? listener;

                      ColorScheme newColorScheme;

                      listener =
                          ImageStreamListener((image, synchronousCall) async {
                        stream.removeListener(listener!);
                        if (waitingForTheme || widget.theme != null) {
                          return;
                        }
                        themeProviderLogger.finest("Getting theme from image");
                        waitingForTheme = true;
                        newColorScheme = await getColorSchemeForImage(
                            image.image, Theme.of(context).brightness);
                        widget.imageThemeCallback?.call(newColorScheme);
                        waitingForTheme = false;
                      }, onError: (err, trace) {
                        stream.removeListener(listener!);
                        waitingForTheme = false;
                        if (widget.theme != null) {
                          return;
                        }
                        themeProviderLogger.warning(
                            "Error getting color scheme for image", err, trace);
                        newColorScheme =
                            getDefaultTheme(Theme.of(context).brightness);
                        widget.imageThemeCallback?.call(newColorScheme);
                      });

                      onDispose = () {
                        stream.removeListener(listener!);
                      };

                      if (widget.theme == null && !waitingForTheme) {
                        stream.addListener(listener);
                      }
                    }
                  },
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
            SizedBox(
              width: 35,
              height: 46,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: 35,
                    weight: 1.0,
                  ),
                  Positioned(
                    bottom: -2,
                    child: Text(
                      value ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
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
          Vibrate.feedback(FeedbackType.success);
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
