import 'dart:async';

import 'package:finamp/menus/components/menuEntries/adaptive_download_lock_delete_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/instant_mix_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/add_to_playlist_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/delete_from_server_menu_entry.dart';
import 'package:finamp/menus/components/menuEntries/go_to_genre_menu_entry.dart';
import 'package:finamp/menus/components/menu_item_info_header.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/menus/components/menuEntries/toggle_favorite_menu_entry.dart';
import 'package:finamp/menus/components/playbackActions/playback_action_row.dart';
import 'package:finamp/menus/components/playbackActions/playback_actions.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';

const Duration artistMenuDefaultAnimationDuration = Duration(milliseconds: 750);
const Curve artistMenuDefaultInCurve = Curves.easeOutCubic;
const Curve artistMenuDefaultOutCurve = Curves.easeInCubic;
const artistMenuRouteName = "/artist-menu";

Future<void> showModalArtistMenu({
  required BuildContext context,
  required BaseItemDto baseItem,
}) async {
  // Normal menu entries, excluding headers
  List<Widget> getMenuEntries(BuildContext context) {
    return [
      AddToPlaylistMenuEntry(baseItem: baseItem),
      InstantMixMenuEntry(baseItem: baseItem),
      AdaptiveDownloadLockDeleteMenuEntry(baseItem: baseItem),
      ToggleFavoriteMenuEntry(baseItem: baseItem),
      GoToGenreMenuEntry(baseItem: baseItem),
      DeleteFromServerMenuEntry(baseItem: baseItem),
    ];
  }

  (double, List<Widget>) getMenuProperties(BuildContext context) {
    var stackHeight = infoHeaderFullHeight + playActionRowHeight;
    var menuEntries = getMenuEntries(context);
    stackHeight += menuEntries
            .where((element) =>
                switch (element) { Visibility e => e.visible, _ => true })
            .length *
        56;

    final pageViewController = PageController();

    List<Widget> menu = [
      SliverPersistentHeader(
        delegate: MenuItemInfoHeader(
          item: baseItem,
        ),
        pinned: true,
      ),
      MenuMask(
        height: playActionRowHeight + 8.0,
        child: SliverToBoxAdapter(
          child: PlaybackActionRow(
            controller: pageViewController,
            playbackActionPages: getPlaybackActionPages(baseItem),
          ),
        ),
      ),
      MenuMask(
        height: MenuMask.defaultHeight,
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
    routeName: artistMenuRouteName,
    buildSlivers: (context) => getMenuProperties(context),
  );
}

