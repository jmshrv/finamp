import 'dart:async';

import "package:super_sliver_list/super_sliver_list.dart";
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/menus/components/menuEntries/adaptive_download_lock_delete_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/add_to_playlist_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/instant_mix_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/restore_queue_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/toggle_favorite_menu_entry.dart';
import 'package:finamp/menus/components/menu_item_info_header.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';

import 'components/menuEntries/menu_entry.dart';

const Duration genreMenuDefaultAnimationDuration = Duration(milliseconds: 750);
const Curve genreMenuDefaultInCurve = Curves.easeOutCubic;
const Curve genreMenuDefaultOutCurve = Curves.easeInCubic;
const genreMenuRouteName = "/genre-menu";

Future<void> showModalGenreMenu({
  required BuildContext context,
  required BaseItemDto baseItem,
  FinampStorableQueueInfo? queueInfo,
}) async {
  // Normal menu entries, excluding headers
  List<HideableMenuEntry> getMenuEntries(BuildContext context) {
    return [
      if (queueInfo != null) RestoreQueueMenuEntry(queueInfo: queueInfo),
      AddToPlaylistMenuEntry(baseItem: baseItem),
      InstantMixMenuEntry(baseItem: baseItem),
      AdaptiveDownloadLockDeleteMenuEntry(baseItem: baseItem),
      ToggleFavoriteMenuEntry(baseItem: baseItem),
    ];
  }

  (double, List<Widget>) getMenuProperties(BuildContext context) {
    final menuEntries = getMenuEntries(context);
    final stackHeight = ThemedBottomSheet.calculateStackHeight(
      context: context,
      menuEntries: menuEntries,
      includePlaybackrow: false,
    );

    final pageViewController = PageController();

    List<Widget> menu = [
      SliverPersistentHeader(
        delegate: MenuItemInfoSliverHeader(item: baseItem),
        pinned: true,
      ),
      //!!! temporarily disabled due to performance issues with large queues
      // MenuMask(
      //   height: MenuMask.defaultHeight,
      //   child: SliverToBoxAdapter(
      //     child: PlaybackActionRow(
      //       controller: pageViewController,
      //       playbackActionPages: getPlaybackActionPages(
      //         context: context,
      //         baseItem: baseItem,
      //       ),
      //     ),
      //   ),
      // ),
      MenuMask(
        height: MenuItemInfoSliverHeader.defaultHeight,
        child: SliverPadding(
          padding: const EdgeInsets.only(left: 8.0),
          sliver: SuperSliverList(
            delegate: SliverChildListDelegate(menuEntries),
          ),
        ),
      ),
    ];

    return (stackHeight, menu);
  }

  await showThemedBottomSheet(
    context: context,
    item: baseItem,
    routeName: genreMenuRouteName,
    buildSlivers: (context) => getMenuProperties(context),
  );
}
