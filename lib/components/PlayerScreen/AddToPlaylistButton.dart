import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/MusicPlayerBackgroundTask.dart';

const addToPlaylistTooltip = "Add to playlist";

class AddToPlaylistButton extends StatelessWidget {
  const AddToPlaylistButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return IconButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(
              "/music/addtoplaylist",
              arguments: snapshot.data!.extras!["itemId"],
            ),
            icon: const Icon(Icons.playlist_add),
            tooltip: addToPlaylistTooltip,
          );
        } else {
          return const IconButton(
            icon: Icon(Icons.playlist_add),
            onPressed: null,
            tooltip: addToPlaylistTooltip,
          );
        }
      },
    );
  }
}
