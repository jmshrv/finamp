import 'dart:async';

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
import 'package:finamp/menus/components/shuffle_menu_entry.dart';
import 'package:finamp/menus/components/speed_menu.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/PlayerScreen/queue_list.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_cancel_dialog.dart';
import 'package:finamp/components/PlayerScreen/sleep_timer_dialog.dart';
import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/menus/components/toggle_favorite_menu_entry.dart';
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
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final queueService = GetIt.instance<QueueService>();

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
      PlayMenuEntry(baseItem: baseItem),
      ShuffleMenuEntry(baseItem: baseItem),
      PlayNextMenuEntry(baseItem: baseItem),
      AddToNextUpMenuEntry(baseItem: baseItem),
      AddToQueueMenuEntry(baseItem: baseItem),
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
    var stackHeight = 155.0;
    var menuEntries = getMenuEntries(context);
    stackHeight += menuEntries
            .where((element) =>
                switch (element) { Visibility e => e.visible, _ => true })
            .length *
        56;

    List<Widget> menu = [
      SliverPersistentHeader(
        delegate: MenuItemInfoHeader(
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
