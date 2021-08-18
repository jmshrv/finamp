import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

const addToPlaylistTooltip = "Add to playlist";

class AddToPlaylistButton extends StatelessWidget {
  const AddToPlaylistButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: AudioService.currentMediaItemStream,
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
