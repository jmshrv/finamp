import 'package:finamp/components/AlbumScreen/song_menu.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/add_to_playlist_screen.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

enum PlayerButtonsMoreItems { shuffle, repeat, addToPlaylist, sleepTimer }

class PlayerButtonsMore extends ConsumerWidget {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final BaseItemDto? item;

  PlayerButtonsMore({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconTheme(
      data: IconThemeData(
        color: IconTheme.of(context).color,
        size: 24,
      ),
      child: GestureDetector(
        onLongPress: () {
          FeedbackHelper.feedback(FeedbackType.medium);
          Navigator.of(context)
              .pushNamed(AddToPlaylistScreen.routeName, arguments: item!.id);
        },
        child: IconButton(
          icon: const Icon(
            TablerIcons.menu_2,
          ),
          visualDensity: VisualDensity.compact,
          onPressed: () async {
            if (item == null) return;
            await showModalSongMenu(
              context: context,
              item: item!,
              playerScreenTheme: Theme.of(context).colorScheme,
              showPlaybackControls: true, // show controls on player screen
              isInPlaylist: false,
            );
          },
        ),
      ),
    );
  }
}
