import 'dart:async';

import 'package:finamp/components/AlbumScreen/speed_menu.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/PlayerScreen/queue_list.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_cancel_dialog.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_dialog.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/metadata_provider.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
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

const Duration albumMenuDefaultAnimationDuration = Duration(milliseconds: 750);
const Curve albumMenuDefaultInCurve = Curves.easeOutCubic;
const Curve albumMenuDefaultOutCurve = Curves.easeInCubic;

Future<void> showModalAlbumMenu({
  required BuildContext context,
  required BaseItemDto item,
  BaseItemDto? parentItem,
  Function? onRemoveFromList,
  bool confirmPlaylistRemoval = true,
}) async {
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;
  final canGoToArtist = (item.artistItems?.isNotEmpty ?? false);
  final canGoToGenre = (item.genreItems?.isNotEmpty ?? false);

  await showThemedBottomSheet(
      context: context,
      item: item,
      routeName: AlbumMenu.routeName,
      buildWrapper: (context, dragController, childBuilder) {
        return AlbumMenu(
          key: ValueKey(item.id),
          item: item,
          parentItem: parentItem,
          isOffline: isOffline,
          canGoToArtist: canGoToArtist,
          canGoToGenre: canGoToGenre,
          onRemoveFromList: onRemoveFromList,
          confirmPlaylistRemoval: confirmPlaylistRemoval,
          childBuilder: childBuilder,
          dragController: dragController,
        );
      });
}

class AlbumMenu extends ConsumerStatefulWidget {
  static const routeName = "/album-menu";

  const AlbumMenu({
    super.key,
    required this.item,
    required this.isOffline,
    required this.canGoToArtist,
    required this.canGoToGenre,
    required this.onRemoveFromList,
    required this.confirmPlaylistRemoval,
    this.parentItem,
    required this.childBuilder,
    required this.dragController,
  });

  final BaseItemDto item;
  final BaseItemDto? parentItem;
  final bool isOffline;
  final bool canGoToArtist;
  final bool canGoToGenre;
  final Function? onRemoveFromList;
  final bool confirmPlaylistRemoval;
  final ScrollBuilder childBuilder;
  final DraggableScrollableController dragController;

  @override
  ConsumerState<AlbumMenu> createState() => _AlbumMenuState();
}

class _AlbumMenuState extends ConsumerState<AlbumMenu> {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  double initialSheetExtent = 0.0;
  double inputStep = 0.9;
  double oldExtent = 0.0;

  @override
  void initState() {
    super.initState();

    initialSheetExtent = 0.45;
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

  void scrollToExtent(
      DraggableScrollableController scrollController, double? percentage) {
    var currentSize = scrollController.size;
    if ((percentage != null && currentSize < percentage) ||
        scrollController.size == inputStep) {
      scrollController.animateTo(
        percentage ?? oldExtent,
        duration: albumMenuDefaultAnimationDuration,
        curve: albumMenuDefaultInCurve,
      );
    }
    oldExtent = currentSize;
  }

  @override
  Widget build(BuildContext context) {
    final menuEntries = _menuEntries(context);
    var stackHeight = 155.0;
    stackHeight += menuEntries
            .where((element) =>
                switch (element) { Visibility e => e.visible, _ => true })
            .length *
        56;

    return widget.childBuilder(stackHeight, menu(context, menuEntries));
  }

  // Normal album menu entries, excluding headers
  List<Widget> _menuEntries(BuildContext context) {
    final downloadsService = GetIt.instance<DownloadsService>();
    final downloadStatus = downloadsService.getStatus(
        DownloadStub.fromItem(
            type: DownloadItemType.collection, item: widget.item),
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
          type: DownloadItemType.collection, item: widget.item));
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
          onTap: () {
            Navigator.pop(context); // close menu
            showPlaylistActionsMenu(
              context: context,
              item: widget.item,
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
            List<BaseItemDto>? albumTracks;
            try {
              FeedbackHelper.feedback(FeedbackType.selection);
              if (widget.isOffline) {
                albumTracks = await downloadsService
                    .getCollectionTracks(widget.item, playable: true);
              } else {
                albumTracks = await _jellyfinApiHelper.getItems(
                  parentItem: widget.item,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );
              }

              if (albumTracks == null) {
                GlobalSnackbar.message((scaffold) =>
                    AppLocalizations.of(scaffold)!.couldNotLoad(
                        BaseItemDtoType.fromItem(widget.item).name));
                return;
              }

              await _queueService.addNext(
                  items: albumTracks,
                  source: QueueItemSource(
                    type: QueueItemSourceType.nextUpAlbum,
                    name: QueueItemSourceName(
                        type: QueueItemSourceNameType.preTranslated,
                        pretranslatedName: widget.item.name ??
                            AppLocalizations.of(context)!.placeholderSource),
                    id: widget.item.id,
                    item: widget.item,
                    contextNormalizationGain: widget.item.normalizationGain,
                  ));

              GlobalSnackbar.message(
                  (scaffold) => AppLocalizations.of(scaffold)!.confirmPlayNext(
                      BaseItemDtoType.fromItem(widget.item).name),
                  isConfirmation: true);
              Navigator.pop(context);
            } catch (e) {
              GlobalSnackbar.error(e);
            }
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
          List<BaseItemDto>? albumTracks;
          try {
            FeedbackHelper.feedback(FeedbackType.selection);
            if (widget.isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.item, playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: widget.item,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(
                      BaseItemDtoType.fromItem(widget.item).name));
              return;
            }

            await _queueService.addToNextUp(
                items: albumTracks,
                source: QueueItemSource(
                  type: QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName: widget.item.name ??
                          AppLocalizations.of(context)!.placeholderSource),
                  id: widget.item.id,
                  item: widget.item,
                  contextNormalizationGain: widget.item.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) => AppLocalizations.of(scaffold)!.confirmAddToNextUp(
                    BaseItemDtoType.fromItem(widget.item).name),
                isConfirmation: true);
            Navigator.pop(context);
          } catch (e) {
            GlobalSnackbar.error(e);
          }
        },
      ),
      ListTile(
        leading: Icon(
          TablerIcons.playlist,
          color: iconColor,
        ),
        title: Text(AppLocalizations.of(context)!.addToQueue),
        onTap: () async {
          List<BaseItemDto>? albumTracks;
          try {
            FeedbackHelper.feedback(FeedbackType.selection);
            if (widget.isOffline) {
              albumTracks = await downloadsService
                  .getCollectionTracks(widget.item, playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: widget.item,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(
                      BaseItemDtoType.fromItem(widget.item).name));
              return;
            }

            await _queueService.addToQueue(
                items: albumTracks,
                source: QueueItemSource(
                  type: QueueItemSourceType.album,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName: widget.item.name ??
                          AppLocalizations.of(context)!.placeholderSource),
                  id: widget.item.id,
                  item: widget.item,
                  contextNormalizationGain: widget.item.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) => AppLocalizations.of(scaffold)!.confirmAddToQueue(
                    BaseItemDtoType.fromItem(widget.item).name),
                isConfirmation: true);
            Navigator.pop(context);
          } catch (e) {
            GlobalSnackbar.error(e);
          }
        },
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
      //FIXME addToMixList / removeFromMixList
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
                    type: DownloadItemType.collection, item: widget.item);
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
                type: DownloadItemType.collection, item: widget.item);
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
                  type: DownloadItemType.collection, item: widget.item);
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
                ? AppLocalizations.of(context)!.removeFavourite
                : AppLocalizations.of(context)!.addFavourite),
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
                    type: DownloadItemType.collection, item: widget.item);
                await askBeforeDeleteFromServerAndDevice(context, item);
                Navigator.pop(context); // close popup
                musicScreenRefreshStream.add(null);
              },
            ));
      }),
    ];
  }

  // All album menu slivers, including headers
  List<Widget> menu(BuildContext context, List<Widget> menuEntries) {
    var iconColor = Theme.of(context).colorScheme.primary;
    return [
      SliverPersistentHeader(
        delegate: AlbumMenuSliverAppBar(
          item: widget.item,
        ),
        pinned: true,
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

class AlbumMenuSliverAppBar extends SliverPersistentHeaderDelegate {
  BaseItemDto item;

  AlbumMenuSliverAppBar({
    required this.item,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AlbumInfo(
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

class AlbumInfo extends ConsumerStatefulWidget {
  const AlbumInfo({
    super.key,
    required this.item,
  }) : condensed = false;

  const AlbumInfo.condensed({
    super.key,
    required this.item,
  }) : condensed = true;

  final BaseItemDto item;
  final bool condensed;

  @override
  ConsumerState createState() => _AlbumInfoState();
}

class _AlbumInfoState extends ConsumerState<AlbumInfo> {
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
                        ReleaseDateChip(
                          baseItem: widget.item,
                          backgroundColor: IconTheme.of(context)
                                  .color
                                  ?.withOpacity(0.1) ??
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              Colors.white,
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
