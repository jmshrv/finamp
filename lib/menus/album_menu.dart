import 'dart:async';

import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/menus/components/menuEntries/adaptive_download_lock_delete_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/add_to_playlist_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/delete_from_server_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/instant_mix_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/toggle_favorite_menu_entry.dart';
import 'package:finamp/menus/components/menu_item_info_header.dart';
import 'package:finamp/menus/components/playbackActions/playback_action_row.dart';
import 'package:finamp/menus/components/playbackActions/playback_actions.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';

import 'components/menuEntries/menu_entry.dart';

const Duration albumMenuDefaultAnimationDuration = Duration(milliseconds: 750);
const Curve albumMenuDefaultInCurve = Curves.easeOutCubic;
const Curve albumMenuDefaultOutCurve = Curves.easeInCubic;
const albumMenuRouteName = "/album-menu";

Future<void> showModalAlbumMenu({required BuildContext context, required BaseItemDto baseItem}) async {
  // Normal menu entries, excluding headers
  List<HideableMenuEntry> getMenuEntries(BuildContext context) {
    return [
      AddToPlaylistMenuEntry(baseItem: baseItem),
      InstantMixMenuEntry(baseItem: baseItem),
      AdaptiveDownloadLockDeleteMenuEntry(baseItem: baseItem),
      ToggleFavoriteMenuEntry(baseItem: baseItem),
      DeleteFromServerMenuEntry(baseItem: baseItem),
    ];
  }

  (double, List<Widget>) getMenuProperties(BuildContext context) {
    final menuEntries = getMenuEntries(context);
    final stackHeight = ThemedBottomSheet.calculateStackHeight(context: context, menuEntries: menuEntries);

    final pageViewController = PageController();

    List<Widget> menu = [
      SliverPersistentHeader(delegate: MenuItemInfoSliverHeader(item: baseItem), pinned: true),
      MenuMask(
        height: MenuItemInfoSliverHeader.defaultHeight,
        child: SliverToBoxAdapter(
          child: PlaybackActionRow(
            controller: pageViewController,
            playbackActionPages: getPlaybackActionPages(context: context, baseItem: baseItem),
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
