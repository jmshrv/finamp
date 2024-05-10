import 'package:finamp/components/AlbumScreen/song_menu.dart';
import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/add_to_playlist_screen.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';

enum PlayerButtonsMoreItems { shuffle, repeat, addToPlaylist, sleepTimer }

class PlayerButtonsMore extends ConsumerWidget {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final BaseItemDto? item;
  final FinampQueueItem? queueItem;

  PlayerButtonsMore({super.key, required this.item, required this.queueItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconTheme(
      data: IconThemeData(
        color: IconTheme.of(context).color,
        size: 24,
      ),
      child: GestureDetector(
        onLongPress: () async {
          if (FinampSettingsHelper.finampSettings.isOffline) {
            return GlobalSnackbar.message((context) =>
                AppLocalizations.of(context)!.notAvailableInOfflineMode);
          }

          bool inPlaylist = queueItemInPlaylist(queueItem);
          if (inPlaylist) {
            await showModalQuickActionsMenu(
              context: context,
              item: item!,
              parentItem: queueItem!.source.item,
              usePlayerTheme: true,
            );
          } else {
            FeedbackHelper.feedback(FeedbackType.medium);
            await Navigator.of(context)
                .pushNamed(AddToPlaylistScreen.routeName, arguments: item!.id);
          }
        },
        child: IconButton(
          icon: const Icon(
            TablerIcons.menu_2,
          ),
          visualDensity: VisualDensity.compact,
          onPressed: () async {
            if (item == null) return;
            var inPlaylist = queueItemInPlaylist(queueItem);
            await showModalSongMenu(
              context: context,
              item: item!,
              usePlayerTheme: true,
              showPlaybackControls: true, // show controls on player screen
              parentItem: inPlaylist ? queueItem!.source.item : null,
              isInPlaylist: inPlaylist,
            );
          },
        ),
      ),
    );
  }
}
