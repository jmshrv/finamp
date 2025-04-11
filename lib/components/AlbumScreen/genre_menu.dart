import 'dart:async';

import 'package:finamp/components/AlbumScreen/speed_menu.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/PlayerScreen/item_amount_chip.dart';
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

const Duration GenreMenuDefaultAnimationDuration = Duration(milliseconds: 750);
const Curve GenreMenuDefaultInCurve = Curves.easeOutCubic;
const Curve GenreMenuDefaultOutCurve = Curves.easeInCubic;

Future<void> showModalGenreMenu({
  required BuildContext context,
  required BaseItemDto item,
  BaseItemDto? parentItem,
}) async {
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;

  await showThemedBottomSheet(
      context: context,
      item: item,
      routeName: GenreMenu.routeName,
      buildWrapper: (context, dragController, childBuilder) {
        return GenreMenu(
          key: ValueKey(item.id),
          item: item,
          parentItem: parentItem,
          isOffline: isOffline,
          childBuilder: childBuilder,
          dragController: dragController,
        );
      });
}

class GenreMenu extends ConsumerStatefulWidget {
  static const routeName = "/genre-menu";

  const GenreMenu({
    super.key,
    required this.item,
    required this.isOffline,
    this.parentItem,
    required this.childBuilder,
    required this.dragController,
  });

  final BaseItemDto item;
  final BaseItemDto? parentItem;
  final bool isOffline;
  final ScrollBuilder childBuilder;
  final DraggableScrollableController dragController;

  @override
  ConsumerState<GenreMenu> createState() => _GenreMenuState();
}

class _GenreMenuState extends ConsumerState<GenreMenu> {
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
        duration: GenreMenuDefaultAnimationDuration,
        curve: GenreMenuDefaultInCurve,
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
            List<BaseItemDto>? genreTracks;
            try {
              FeedbackHelper.feedback(FeedbackType.selection);
              if (widget.isOffline) {
                genreTracks = await downloadsService
                    .getCollectionTracks(widget.item, playable: true);
              } else {
                genreTracks = await _jellyfinApiHelper.getItems(
                  parentItem: widget.item,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );
              }

              if (genreTracks == null) {
                GlobalSnackbar.message((scaffold) =>
                    AppLocalizations.of(scaffold)!.couldNotLoad(
                        BaseItemDtoType.fromItem(widget.item).name));
                return;
              }

              await _queueService.addNext(
                  items: genreTracks,
                  source: QueueItemSource(
                    type: QueueItemSourceType.nextUpGenre,
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
          List<BaseItemDto>? genreTracks;
          try {
            FeedbackHelper.feedback(FeedbackType.selection);
            if (widget.isOffline) {
              genreTracks = await downloadsService
                  .getCollectionTracks(widget.item, playable: true);
            } else {
              genreTracks = await _jellyfinApiHelper.getItems(
                parentItem: widget.item,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (genreTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(
                      BaseItemDtoType.fromItem(widget.item).name));
              return;
            }

            await _queueService.addToNextUp(
                items: genreTracks,
                source: QueueItemSource(
                  type: QueueItemSourceType.nextUpGenre,
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
          List<BaseItemDto>? genreTracks;
          try {
            FeedbackHelper.feedback(FeedbackType.selection);
            if (widget.isOffline) {
              genreTracks = await downloadsService
                  .getCollectionTracks(widget.item, playable: true);
            } else {
              genreTracks = await _jellyfinApiHelper.getItems(
                parentItem: widget.item,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (genreTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!.couldNotLoad(
                      BaseItemDtoType.fromItem(widget.item).name));
              return;
            }

            await _queueService.addToQueue(
                items: genreTracks,
                source: QueueItemSource(
                  type: QueueItemSourceType.genre,
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
        delegate: GenreMenuSliverAppBar(
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

class GenreMenuSliverAppBar extends SliverPersistentHeaderDelegate {
  BaseItemDto item;

  GenreMenuSliverAppBar({
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
                  borderRadius: BorderRadius.circular(12),
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
                      //!!! the data needed for this currently isn't loaded, as it's quite intensive on the server
                      // if (!widget.condensed)
                      //   ItemAmountChip(
                      //     baseItem: widget
                      //         .item, //FIXME fetch extended item when menu is opened to include BaseItemDto.albumCount
                      //     backgroundColor: IconTheme.of(context)
                      //             .color
                      //             ?.withOpacity(0.1) ??
                      //         Theme.of(context).textTheme.bodyMedium?.color ??
                      //         Colors.white,
                      //   )
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
