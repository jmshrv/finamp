import 'dart:async';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/add_to_next_up_menu_entry.dart';
import 'package:finamp/menus/components/add_to_queue_menu_entry.dart';
import 'package:finamp/menus/components/delete_from_device_menu_entry.dart';
import 'package:finamp/menus/components/delete_from_server_menu_entry.dart';
import 'package:finamp/menus/components/download_menu_entry.dart';
import 'package:finamp/menus/components/go_to_artist_menu_entry.dart';
import 'package:finamp/menus/components/go_to_genre_menu_entry.dart';
import 'package:finamp/menus/components/instant_mix_menu_entry.dart';
import 'package:finamp/menus/components/lock_download_menu_entry.dart';
import 'package:finamp/menus/components/menu_item_info_header.dart';
import 'package:finamp/menus/components/play_menu_entry.dart';
import 'package:finamp/menus/components/play_next_menu_entry.dart';
import 'package:finamp/menus/components/playback_action.dart';
import 'package:finamp/menus/components/playback_action_page_indicator.dart';
import 'package:finamp/menus/components/shuffle_menu_entry.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/menus/components/toggle_favorite_menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/item_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../models/jellyfin_models.dart';

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
  // Normal album menu entries, excluding headers
  List<Widget> getMenuEntries(BuildContext context) {
    return [
      InstantMixMenuEntry(baseItem: baseItem),
      //FIXME addToMixList / removeFromMixList
      DeleteFromDeviceMenuEntry(baseItem: baseItem),
      DownloadMenuEntry(baseItem: baseItem),
      LockDownloadMenuEntry(baseItem: baseItem),
      ToggleFavoriteMenuEntry(baseItem: baseItem),
      GoToArtistMenuEntry(baseItem: baseItem),
      GoToGenreMenuEntry(baseItem: baseItem),
      DeleteFromServerMenuEntry(baseItem: baseItem),
    ];
  }

  (double, List<Widget>) getMenuProperties(BuildContext context) {
    final queueService = GetIt.instance<QueueService>();

    var stackHeight = 155.0;
    var menuEntries = getMenuEntries(context);
    stackHeight += menuEntries
            .where((element) =>
                switch (element) { Visibility e => e.visible, _ => true })
            .length *
        56;

    final pageViewController = PageController();

    Map<String, Widget> playActionPages = {
      'Play*': Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PlaybackAction(
            icon: TablerIcons.player_play,
            tooltip: AppLocalizations.of(context)!.playButtonLabel,
            onPressed: (WidgetRef ref) async {
              await queueService.startPlayback(
                items: await ref.watch(loadChildTracksProvider(
                      baseItem: baseItem,
                    ).future) ??
                    [],
                source: QueueItemSource.fromBaseItem(baseItem),
                order: FinampPlaybackOrder.linear,
              );

              GlobalSnackbar.message(
                  (scaffold) => AppLocalizations.of(scaffold)!
                      .confirmPlayNext(BaseItemDtoType.fromItem(baseItem).name),
                  isConfirmation: true);
              Navigator.pop(context);
            },
            iconColor: Theme.of(context).colorScheme.primary,
          ),
          if (queueService.getQueue().nextUp.isNotEmpty)
            PlaybackAction(
              icon: TablerIcons.corner_right_down,
              tooltip: AppLocalizations.of(context)!.playNext,
              onPressed: (WidgetRef ref) async {
                await queueService.addNext(
                  items: await ref.watch(loadChildTracksProvider(
                        baseItem: baseItem,
                      ).future) ??
                      [],
                  source: QueueItemSource.fromBaseItem(baseItem,
                      type: QueueItemSourceType.nextUpAlbum),
                );

                GlobalSnackbar.message(
                    (scaffold) => AppLocalizations.of(scaffold)!
                        .confirmPlayNext(
                            BaseItemDtoType.fromItem(baseItem).name),
                    isConfirmation: true);
                Navigator.pop(context);
              },
              iconColor: Theme.of(context).colorScheme.primary,
            ),
          PlaybackAction(
            icon: TablerIcons.corner_right_down_double,
            tooltip: AppLocalizations.of(context)!.addToNextUp,
            onPressed: (WidgetRef ref) async {
              await queueService.addToNextUp(
                items: await ref.watch(loadChildTracksProvider(
                      baseItem: baseItem,
                    ).future) ??
                    [],
                source: QueueItemSource.fromBaseItem(baseItem,
                    type: QueueItemSourceType.nextUpAlbum),
              );

              GlobalSnackbar.message(
                  (scaffold) => AppLocalizations.of(scaffold)!
                      .confirmAddToNextUp(
                          BaseItemDtoType.fromItem(baseItem).name),
                  isConfirmation: true);
              Navigator.pop(context);
            },
            iconColor: Theme.of(context).colorScheme.primary,
          ),
          PlaybackAction(
            icon: TablerIcons.playlist,
            tooltip: AppLocalizations.of(context)!.addToQueue,
            onPressed: (WidgetRef ref) async {
              await queueService.addToQueue(
                items: await ref.watch(loadChildTracksProvider(
                      baseItem: baseItem,
                    ).future) ??
                    [],
                source: QueueItemSource.fromBaseItem(baseItem),
              );

              GlobalSnackbar.message(
                  (scaffold) => AppLocalizations.of(scaffold)!
                      .confirmAddToQueue(
                          BaseItemDtoType.fromItem(baseItem).name),
                  isConfirmation: true);
              Navigator.pop(context);
            },
            iconColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      // Shuffle
      'Shuffle*': Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PlaybackAction(
            icon: TablerIcons.arrows_shuffle,
            tooltip: AppLocalizations.of(context)!.shuffleButtonLabel,
            onPressed: (WidgetRef ref) async {
              await queueService.startPlayback(
                items: await ref.watch(loadChildTracksProvider(
                      baseItem: baseItem,
                    ).future) ??
                    [],
                source: QueueItemSource.fromBaseItem(baseItem),
                order: FinampPlaybackOrder.shuffled,
              );

              Navigator.pop(context);
            },
            iconColor: Theme.of(context).colorScheme.primary,
          ),
          if (queueService.getQueue().nextUp.isNotEmpty)
            PlaybackAction(
              icon: TablerIcons.corner_right_down,
              tooltip: AppLocalizations.of(context)!.shuffleNext,
              onPressed: (WidgetRef ref) async {
                await queueService.addNext(
                  items: (await ref.watch(loadChildTracksProvider(
                        baseItem: baseItem,
                      ).future) ??
                      [])
                    ..shuffle(),
                  source: QueueItemSource.fromBaseItem(baseItem,
                      type: QueueItemSourceType.nextUpAlbum),
                );

                GlobalSnackbar.message(
                    (scaffold) =>
                        AppLocalizations.of(scaffold)!.confirmShuffleNext,
                    isConfirmation: true);
                Navigator.pop(context);
              },
              iconColor: Theme.of(context).colorScheme.primary,
            ),
          PlaybackAction(
            icon: TablerIcons.corner_right_down_double,
            tooltip: AppLocalizations.of(context)!.shuffleToNextUp,
            onPressed: (WidgetRef ref) async {
              await queueService.addToNextUp(
                items: (await ref.watch(loadChildTracksProvider(
                      baseItem: baseItem,
                    ).future) ??
                    [])
                  ..shuffle(),
                source: QueueItemSource.fromBaseItem(baseItem,
                    type: QueueItemSourceType.nextUpAlbum),
              );

              GlobalSnackbar.message(
                  (scaffold) =>
                      AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
                  isConfirmation: true);
              Navigator.pop(context);
            },
            iconColor: Theme.of(context).colorScheme.primary,
          ),
          PlaybackAction(
            icon: TablerIcons.playlist,
            tooltip: AppLocalizations.of(context)!.shuffleToQueue,
            onPressed: (WidgetRef ref) async {
              await queueService.addToQueue(
                items: (await ref.watch(loadChildTracksProvider(
                      baseItem: baseItem,
                    ).future) ??
                    [])
                  ..shuffle(),
                source: QueueItemSource.fromBaseItem(baseItem),
              );

              GlobalSnackbar.message(
                  (scaffold) =>
                      AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
                  isConfirmation: true);
              Navigator.pop(context);
            },
            iconColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    };

    List<Widget> menu = [
      SliverPersistentHeader(
        delegate: MenuItemInfoHeader(
          item: baseItem,
        ),
        pinned: true,
      ),
      MenuMask(
        height: 90.0,
        child: SliverToBoxAdapter(
          child: Column(
            verticalDirection: VerticalDirection.up,
            children: [
              SizedBox(
                height: 92,
                child: PageView(
                  controller: pageViewController,
                  allowImplicitScrolling: true,
                  scrollDirection: Axis.horizontal,
                  children: playActionPages.values.toList(),
                ),
              ),
              PlaybackActionPageIndicator(
                pages: playActionPages,
                pageController: pageViewController,
              ),
            ],
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

    return (stackHeight, menu);
  }

  await showThemedBottomSheet(
    context: context,
    item: baseItem,
    routeName: albumMenuRouteName,
    buildSlivers: (context) => getMenuProperties(context),
  );
}

