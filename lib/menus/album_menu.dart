import 'dart:async';

import 'package:finamp/menus/components/speed_menu.dart';
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
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../models/jellyfin_models.dart';
import '../screens/album_screen.dart';
import '../services/audio_service_helper.dart';
import '../services/downloads_service.dart';
import '../services/favorite_provider.dart';
import '../services/finamp_settings_helper.dart';
import '../services/jellyfin_api_helper.dart';
import 'playlist_actions_menu.dart';
import '../components/PlayerScreen/album_chip.dart';
import '../components/PlayerScreen/artist_chip.dart';
import '../components/PlayerScreen/queue_source_helper.dart';
import '../components/album_image.dart';
import '../components/global_snackbar.dart';
import '../components/AlbumScreen/download_dialog.dart';

const albumMenuRouteName = "/album-menu";
const Duration albumMenuDefaultAnimationDuration = Duration(milliseconds: 750);
const Curve albumMenuDefaultInCurve = Curves.easeOutCubic;
const Curve albumMenuDefaultOutCurve = Curves.easeInCubic;

Future<void> showModalAlbumMenu({
  required BuildContext context,
  required BaseItemDto baseItem,
  BaseItemDto? parentItem,
  Function? onRemoveFromList,
  bool confirmPlaylistRemoval = true,
}) async {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  final isOffline = FinampSettingsHelper.finampSettings.isOffline;
  final canGoToArtist = (baseItem.artistItems?.isNotEmpty ?? false);
  final canGoToGenre = (baseItem.genreItems?.isNotEmpty ?? false);

  // Normal album menu entries, excluding headers
  List<Widget> getMenuEntries(BuildContext context) {
    final downloadsService = GetIt.instance<DownloadsService>();
    final downloadStatus = downloadsService.getStatus(
        DownloadStub.fromItem(
            type: DownloadItemType.collection, item: baseItem),
        null);
    var iconColor = Theme.of(context).colorScheme.primary;

    String? parentTooltip;
    if (downloadStatus.isIncidental) {
      var parent = downloadsService.getFirstRequiringItem(DownloadStub.fromItem(
          type: DownloadItemType.collection, item: baseItem));
      if (parent != null) {
        var parentName = AppLocalizations.of(context)!
            .itemTypeSubtitle(parent.baseItemType.name, parent.name);
        parentTooltip =
            AppLocalizations.of(context)!.incidentalDownloadTooltip(parentName);
      }
    }

    return [
      ListTile(
        leading: Icon(
          TablerIcons.player_play,
          color: iconColor,
        ),
        title: Text(AppLocalizations.of(context)!.playButtonLabel),
        onTap: () async {
          List<BaseItemDto>? albumTracks;
          try {
            FeedbackHelper.feedback(FeedbackType.selection);
            if (isOffline) {
              albumTracks = await downloadsService.getCollectionTracks(baseItem,
                  playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: baseItem,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!
                      .couldNotLoad(BaseItemDtoType.fromItem(baseItem).name));
              return;
            }

            await _queueService.startPlayback(
              items: albumTracks,
              source: QueueItemSource(
                type: QueueItemSourceType.album,
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: baseItem.name ??
                        AppLocalizations.of(context)!.placeholderSource),
                id: baseItem.id,
                item: baseItem,
                contextNormalizationGain: baseItem.normalizationGain,
              ),
              order: FinampPlaybackOrder.linear,
            );

            GlobalSnackbar.message(
                (scaffold) => AppLocalizations.of(scaffold)!
                    .confirmPlayNext(BaseItemDtoType.fromItem(baseItem).name),
                isConfirmation: true);
            Navigator.pop(context);
          } catch (e) {
            GlobalSnackbar.error(e);
          }
        },
      ),
      ListTile(
        leading: Icon(
          TablerIcons.arrows_shuffle,
          color: iconColor,
        ),
        title: Text(AppLocalizations.of(context)!.shuffleButtonLabel),
        onTap: () async {
          List<BaseItemDto>? albumTracks;
          try {
            FeedbackHelper.feedback(FeedbackType.selection);
            if (isOffline) {
              albumTracks = await downloadsService.getCollectionTracks(baseItem,
                  playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: baseItem,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!
                      .couldNotLoad(BaseItemDtoType.fromItem(baseItem).name));
              return;
            }

            await _queueService.startPlayback(
              items: albumTracks,
              source: QueueItemSource(
                type: QueueItemSourceType.album,
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: baseItem.name ??
                        AppLocalizations.of(context)!.placeholderSource),
                id: baseItem.id,
                item: baseItem,
                contextNormalizationGain: baseItem.normalizationGain,
              ),
              order: FinampPlaybackOrder.shuffled,
            );

            GlobalSnackbar.message(
                (scaffold) => AppLocalizations.of(scaffold)!
                    .confirmPlayNext(BaseItemDtoType.fromItem(baseItem).name),
                isConfirmation: true);
            Navigator.pop(context);
          } catch (e) {
            GlobalSnackbar.error(e);
          }
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
            List<BaseItemDto>? albumTracks;
            try {
              FeedbackHelper.feedback(FeedbackType.selection);
              if (isOffline) {
                albumTracks = await downloadsService
                    .getCollectionTracks(baseItem, playable: true);
              } else {
                albumTracks = await _jellyfinApiHelper.getItems(
                  parentItem: baseItem,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );
              }

              if (albumTracks == null) {
                GlobalSnackbar.message((scaffold) =>
                    AppLocalizations.of(scaffold)!
                        .couldNotLoad(BaseItemDtoType.fromItem(baseItem).name));
                return;
              }

              await _queueService.addNext(
                  items: albumTracks,
                  source: QueueItemSource(
                    type: QueueItemSourceType.nextUpAlbum,
                    name: QueueItemSourceName(
                        type: QueueItemSourceNameType.preTranslated,
                        pretranslatedName: baseItem.name ??
                            AppLocalizations.of(context)!.placeholderSource),
                    id: baseItem.id,
                    item: baseItem,
                    contextNormalizationGain: baseItem.normalizationGain,
                  ));

              GlobalSnackbar.message(
                  (scaffold) => AppLocalizations.of(scaffold)!
                      .confirmPlayNext(BaseItemDtoType.fromItem(baseItem).name),
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
            if (isOffline) {
              albumTracks = await downloadsService.getCollectionTracks(baseItem,
                  playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: baseItem,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!
                      .couldNotLoad(BaseItemDtoType.fromItem(baseItem).name));
              return;
            }

            await _queueService.addToNextUp(
                items: albumTracks,
                source: QueueItemSource(
                  type: QueueItemSourceType.nextUpAlbum,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName: baseItem.name ??
                          AppLocalizations.of(context)!.placeholderSource),
                  id: baseItem.id,
                  item: baseItem,
                  contextNormalizationGain: baseItem.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) => AppLocalizations.of(scaffold)!.confirmAddToNextUp(
                    BaseItemDtoType.fromItem(baseItem).name),
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
            if (isOffline) {
              albumTracks = await downloadsService.getCollectionTracks(baseItem,
                  playable: true);
            } else {
              albumTracks = await _jellyfinApiHelper.getItems(
                parentItem: baseItem,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
            }

            if (albumTracks == null) {
              GlobalSnackbar.message((scaffold) =>
                  AppLocalizations.of(scaffold)!
                      .couldNotLoad(BaseItemDtoType.fromItem(baseItem).name));
              return;
            }

            await _queueService.addToQueue(
                items: albumTracks,
                source: QueueItemSource(
                  type: QueueItemSourceType.album,
                  name: QueueItemSourceName(
                      type: QueueItemSourceNameType.preTranslated,
                      pretranslatedName: baseItem.name ??
                          AppLocalizations.of(context)!.placeholderSource),
                  id: baseItem.id,
                  item: baseItem,
                  contextNormalizationGain: baseItem.normalizationGain,
                ));

            GlobalSnackbar.message(
                (scaffold) => AppLocalizations.of(scaffold)!
                    .confirmAddToQueue(BaseItemDtoType.fromItem(baseItem).name),
                isConfirmation: true);
            Navigator.pop(context);
          } catch (e) {
            GlobalSnackbar.error(e);
          }
        },
      ),
      Visibility(
        visible: !isOffline,
        child: ListTile(
          leading: Icon(
            Icons.explore,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.instantMix),
          enabled: !isOffline,
          onTap: () async {
            await _audioServiceHelper.startInstantMixForItem(baseItem);

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
                    type: DownloadItemType.collection, item: baseItem);
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
          enabled: !isOffline && downloadStatus == DownloadItemStatus.notNeeded,
          onTap: () async {
            var item = DownloadStub.fromItem(
                type: DownloadItemType.collection, item: baseItem);
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
              color: isOffline ? iconColor.withOpacity(0.3) : iconColor,
            ),
            title: Text(AppLocalizations.of(context)!.lockDownload),
            enabled: !isOffline && downloadStatus.isIncidental,
            onTap: () async {
              var item = DownloadStub.fromItem(
                  type: DownloadItemType.collection, item: baseItem);
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
          bool isFav = ref.watch(isFavoriteProvider(baseItem));
          return ListTile(
            enabled: !isOffline,
            leading: isFav
                ? Icon(
                    Icons.favorite,
                    color: isOffline ? iconColor.withOpacity(0.3) : iconColor,
                  )
                : Icon(
                    Icons.favorite_border,
                    color: isOffline ? iconColor.withOpacity(0.3) : iconColor,
                  ),
            title: Text(isFav
                ? AppLocalizations.of(context)!.removeFavourite
                : AppLocalizations.of(context)!.addFavourite),
            onTap: () async {
              ref
                  .read(isFavoriteProvider(baseItem).notifier)
                  .updateFavorite(!isFav);
              if (context.mounted) Navigator.pop(context);
            },
          );
        },
      ),
      Visibility(
        visible: canGoToArtist,
        child: ListTile(
          leading: Icon(
            Icons.person,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.goToArtist),
          enabled: canGoToArtist,
          onTap: () async {
            late BaseItemDto artist;
            try {
              if (FinampSettingsHelper.finampSettings.isOffline) {
                final downloadsService = GetIt.instance<DownloadsService>();
                artist = (await downloadsService.getCollectionInfo(
                        id: baseItem.artistItems!.first.id))!
                    .baseItem!;
              } else {
                artist = await _jellyfinApiHelper
                    .getItemById(baseItem.artistItems!.first.id);
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
        visible: canGoToGenre,
        child: ListTile(
          leading: Icon(
            Icons.category_outlined,
            color: iconColor,
          ),
          title: Text(AppLocalizations.of(context)!.goToGenre),
          enabled: canGoToGenre,
          onTap: () async {
            late BaseItemDto genre;
            try {
              if (FinampSettingsHelper.finampSettings.isOffline) {
                final downloadsService = GetIt.instance<DownloadsService>();
                genre = (await downloadsService.getCollectionInfo(
                        id: baseItem.genreItems!.first.id))!
                    .baseItem!;
              } else {
                genre = await _jellyfinApiHelper
                    .getItemById(baseItem.genreItems!.first.id);
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
        var canDelete =
            ref.watch(_jellyfinApiHelper.canDeleteFromServerProvider(baseItem));
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
                    type: DownloadItemType.collection, item: baseItem);
                await askBeforeDeleteFromServerAndDevice(context, item);
                Navigator.pop(context); // close popup
                musicScreenRefreshStream.add(null);
              },
            ));
      }),
    ];
  }

  (double, List<Widget>) getMenuProperties(BuildContext context) {
    var stackHeight = 155.0;
    var menuEntries = getMenuEntries(context);
    stackHeight += menuEntries
            .where((element) =>
                switch (element) { Visibility e => e.visible, _ => true })
            .length *
        56;

    List<Widget> menu = [
      SliverPersistentHeader(
        delegate: AlbumMenuSliverAppBar(
          item: baseItem,
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

    return (stackHeight, menu);
  }

  await showThemedBottomSheet(
    context: context,
    item: baseItem,
    routeName: albumMenuRouteName,
    buildSlivers: (context) => getMenuProperties(context),
  );
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
