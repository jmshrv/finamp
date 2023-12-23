import 'dart:async';
import 'dart:ui';

import 'package:finamp/at_contrast.dart';
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
import 'package:palette_generator/palette_generator.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/add_to_playlist_screen.dart';
import '../../screens/album_screen.dart';
import '../../services/audio_service_helper.dart';
import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/player_screen_theme_provider.dart';
import '../PlayerScreen/album_chip.dart';
import '../PlayerScreen/artist_chip.dart';
import '../album_image.dart';
import '../error_snackbar.dart';
import 'song_list_tile.dart';

Future<void> showModalSongMenu({
  required BuildContext context,
  required BaseItemDto item,
  required String? parentId,
  bool showPlaybackControls = false,
  bool isInPlaylist = false,
  Function? onRemoveFromList,
}) async {
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;
  final canGoToAlbum = isAlbumDownloadedIfOffline(item.parentId);
  final canGoToArtist = !isOffline;
  final canGoToGenre = !isOffline;

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
            isOffline: isOffline,
            showPlaybackControls: showPlaybackControls,
            isInPlaylist: isInPlaylist,
            canGoToAlbum: canGoToAlbum,
            canGoToArtist: canGoToArtist,
            canGoToGenre: canGoToGenre,
            onRemoveFromList: onRemoveFromList,
            parentId: parentId);
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
    required this.parentId,
  });

  final BaseItemDto item;
  final bool isOffline;
  final bool showPlaybackControls;
  final bool isInPlaylist;
  final bool canGoToAlbum;
  final bool canGoToArtist;
  final bool canGoToGenre;
  final Function? onRemoveFromList;
  final String? parentId;

  @override
  State<SongMenu> createState() => _SongMenuState();
}

bool isBaseItemInQueueItem(BaseItemDto baseItem, FinampQueueItem? queueItem) {

  if (queueItem != null) {
        final baseItem =
            BaseItemDto.fromJson(queueItem.item.extras!["itemJson"]);
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

  /// Sets the item's favourite on the Jellyfin server.
  Future<void> toggleFavorite() async {
    try {
      final currentTrack =_queueService.getCurrentTrack();
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
      errorSnackbar(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _imageTheme?.primary ??
        Theme.of(context).iconTheme.color ??
        Colors.white;

    return Stack(children: [
      DraggableScrollableSheet(
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
                    brightnessFactor:
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
                          setState(() {
                            _imageProvider = provider;
                          });
                        });
                      },
                      imageThemeCallback: (ColorScheme colorScheme) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _imageTheme = colorScheme;
                          });
                        });
                      },
                    ),
                    pinned: true,
                  ),
                  if (widget.showPlaybackControls)
                    StreamBuilder<PlaybackBehaviorInfo>(
                      stream: Rx.combineLatest2(
                          _queueService.getPlaybackOrderStream(),
                          _queueService.getLoopModeStream(),
                          (a, b) => PlaybackBehaviorInfo(a, b)),
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

                        return SliverCrossAxisGroup(
                          // return SliverGrid.count(
                          //   crossAxisCount: 3,
                          //   mainAxisSpacing: 40,
                          //   children: [
                          slivers: [
                            PlaybackAction(
                              icon: playbackOrderIcons[playbackBehavior.order]!,
                              onPressed: () async {
                                _queueService.togglePlaybackOrder();
                              },
                              tooltip: playbackOrderTooltips[
                                  playbackBehavior.order]!,
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
                                final remainingMinutes = (_audioHandler
                                            .sleepTimerRemaining.inSeconds /
                                        60.0)
                                    .ceil();
                                return PlaybackAction(
                                  icon: timerValue != null
                                      ? TablerIcons.hourglass_high
                                      : TablerIcons.hourglass,
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
                          ],
                        );
                      },
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
                              TablerIcons.hourglass_low,
                              color: iconColor,
                            ),
                            title: Text(AppLocalizations.of(context)!.playNext),
                            onTap: () async {
                              await _queueService.addNext(
                                  items: [widget.item],
                                  source: QueueItemSource(
                                      type: QueueItemSourceType.nextUp,
                                      name: QueueItemSourceName(
                                          type: QueueItemSourceNameType
                                              .preTranslated,
                                          pretranslatedName: widget.item.name),
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
                            TablerIcons.hourglass_high,
                            color: iconColor,
                          ),
                          title:
                              Text(AppLocalizations.of(context)!.addToNextUp),
                          onTap: () async {
                            await _queueService.addToNextUp(
                                items: [widget.item],
                                source: QueueItemSource(
                                    type: QueueItemSourceType.nextUp,
                                    name: QueueItemSourceName(
                                        type: QueueItemSourceNameType
                                            .preTranslated,
                                        pretranslatedName: widget.item.name),
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
                            Icons.queue_music,
                            color: iconColor,
                          ),
                          title: Text(AppLocalizations.of(context)!.addToQueue),
                          onTap: () async {
                            await _queueService.addToQueue(
                                items: [widget.item],
                                source: QueueItemSource(
                                    type: QueueItemSourceType.allSongs,
                                    name: QueueItemSourceName(
                                        type: QueueItemSourceNameType
                                            .preTranslated,
                                        pretranslatedName: widget.item.name),
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
                            enabled:
                                !widget.isOffline && widget.parentId != null,
                            onTap: () async {
                              try {
                                await _jellyfinApiHelper
                                    .removeItemsFromPlaylist(
                                        playlistId: widget.parentId!,
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
                                  isGenres: false,
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
                                errorSnackbar(e, context);
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
                              if (FinampSettingsHelper
                                  .finampSettings.isOffline) {
                                // If offline, load the album's BaseItemDto from DownloadHelper.
                                final downloadsHelper =
                                    GetIt.instance<DownloadsHelper>();

                                // downloadedParent won't be null here since the menu item already
                                // checks if the DownloadedParent exists.
                                album = downloadsHelper
                                    .getDownloadedParent(widget.item.parentId!)!
                                    .item;
                              } else {
                                // If online, get the album's BaseItemDto from the server.
                                try {
                                  album = await _jellyfinApiHelper
                                      .getItemById(widget.item.parentId!);
                                } catch (e) {
                                  errorSnackbar(e, context);
                                  return;
                                }
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
                              // If online, get the artist's BaseItemDto from the server.
                              try {
                                artist = await _jellyfinApiHelper.getItemById(
                                    widget.item.artistItems!.first.id);
                              } catch (e) {
                                errorSnackbar(e, context);
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
                              // If online, get the genre's BaseItemDto from the server.
                              try {
                                genre = await _jellyfinApiHelper.getItemById(
                                    widget.item.genreItems!.first.id);
                              } catch (e) {
                                errorSnackbar(e, context);
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
                  imageProviderCallback: (imageProvider) async {
                    if (widget.theme == null && imageProvider != null) {
                      if (widget.imageProviderCallback != null) {
                        widget.imageProviderCallback!(imageProvider);
                      }

                      final theme = Theme.of(context);

                      final palette = await PaletteGenerator.fromImageProvider(
                        imageProvider,
                        timeout: const Duration(milliseconds: 2000),
                      );

                      // Color accent = palette.dominantColor!.color;
                      Color accent = palette.vibrantColor?.color ??
                          palette.dominantColor?.color ??
                          const Color.fromARGB(255, 0, 164, 220);

                      final lighter = theme.brightness == Brightness.dark;

                      final background = Color.alphaBlend(
                          lighter
                              ? Colors.black.withOpacity(0.675)
                              : Colors.white.withOpacity(0.675),
                          accent);

                      accent = accent.atContrast(4.5, background, lighter);

                      final newColorScheme = ColorScheme.fromSwatch(
                        primarySwatch: generateMaterialColor(accent),
                        accentColor: accent,
                        brightness: theme.brightness,
                      );

                      if (widget.theme == null &&
                          widget.imageThemeCallback != null) {
                        widget.imageThemeCallback!(newColorScheme);
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
    required this.onPressed,
    required this.tooltip,
    required this.iconColor,
  });

  final IconData icon;
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
              size: 32,
              weight: 1.0,
            ),
            const SizedBox(height: 12),
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
