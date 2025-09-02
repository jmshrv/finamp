import 'dart:async';

import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/menus/components/menuEntries/adaptive_download_lock_delete_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/add_to_playlist_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/delete_from_server_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/instant_mix_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/restore_queue_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/toggle_favorite_menu_entry.dart';
import 'package:finamp/menus/components/menu_item_info_header.dart';
import 'package:finamp/menus/components/playbackActions/playback_action_row.dart';
import 'package:finamp/menus/components/playbackActions/playback_actions.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'components/menuEntries/menu_entry.dart';

const Duration albumMenuDefaultAnimationDuration = Duration(milliseconds: 750);
const Curve albumMenuDefaultInCurve = Curves.easeOutCubic;
const Curve albumMenuDefaultOutCurve = Curves.easeInCubic;
const albumMenuRouteName = "/album-menu";

Future<void> showModalAlbumMenu({
  required BuildContext context,
  required PlayableItem item,
  FinampStorableQueueInfo? queueInfo,
}) async {
  final BaseItemDto baseItem = switch (item) {
    AlbumDisc() => item.parent,
    BaseItemDto() => item,
  };

  // Normal menu entries, excluding headers
  List<HideableMenuEntry> getMenuEntries(BuildContext context) {
    return [
      if (queueInfo != null) RestoreQueueMenuEntry(queueInfo: queueInfo),
      AddToPlaylistMenuEntry(item: item),
      // instant mix from arbitrary collection of tracks is not supported
      if (item is BaseItemDto) InstantMixMenuEntry(baseItem: item),
      // download system is not that flexible
      if (item is BaseItemDto) AdaptiveDownloadLockDeleteMenuEntry(baseItem: item),
      // backend is not flexible too
      if (item is BaseItemDto) ToggleFavoriteMenuEntry(baseItem: item),
      if (item is BaseItemDto) DeleteFromServerMenuEntry(baseItem: item),
    ];
  }

  (double, List<Widget>) getMenuProperties(BuildContext context) {
    final menuEntries = getMenuEntries(context);
    final stackHeight = ThemedBottomSheet.calculateStackHeight(context: context, menuEntries: menuEntries);
    final ref = GetIt.instance<ProviderContainer>();
    final queueService = GetIt.instance<QueueService>();

    final lastUsedPlaybackActionRowPage = ref.read(finampSettingsProvider.lastUsedPlaybackActionRowPage);
    final lastUsedPlaybackActionRowPageIndex = lastUsedPlaybackActionRowPage.pageIndexFor(
      nextUpIsEmpty: queueService.getQueue().nextUp.isEmpty,
    );
    final initialPageViewIndex = ref.read(finampSettingsProvider.rememberLastUsedPlaybackActionRowPage)
        ? lastUsedPlaybackActionRowPageIndex
        : 0;
    final pageViewController = PageController(initialPage: initialPageViewIndex);

    List<Widget> menu = [
      SliverPersistentHeader(delegate: MenuItemInfoSliverHeader(item: item), pinned: true),
      MenuMask(
        height: MenuItemInfoSliverHeader.defaultHeight,
        child: SliverToBoxAdapter(
          child: PlaybackActionRow(
            controller: pageViewController,
            playbackActionPages: getPlaybackActionPages(context: context, item: item),
          ),
        ),
      ),
      MenuMask(
        height: MenuItemInfoSliverHeader.defaultHeight,
        child: SliverPadding(
          padding: const EdgeInsets.only(left: 8.0),
          sliver: SliverList(delegate: SliverChildListDelegate(menuEntries)),
        ),
      ),
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
