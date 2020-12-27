import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../../services/connectIfDisconnected.dart';

/// Creates some text that shows the song's name and the artist.
class SongName extends StatelessWidget {
  const SongName({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem>(
      stream: AudioService.currentMediaItemStream,
      builder: (context, snapshot) {
        connectIfDisconnected();
        final MediaItem mediaItem = snapshot.data;
        if (mediaItem != null) {
          return Column(
            children: [
              Text(
                mediaItem.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Text(
                mediaItem.artist,
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              )
            ],
          );
        } else {
          return Text("No item");
        }
      },
    );
  }
}
