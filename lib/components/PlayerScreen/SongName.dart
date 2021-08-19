import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/MusicPlayerBackgroundTask.dart';

/// Creates some text that shows the song's name and the artist.
class SongName extends StatelessWidget {
  const SongName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
      stream: _audioHandler.mediaItem,
      builder: (context, snapshot) {
        final MediaItem? mediaItem = snapshot.data;

        return Column(
          children: [
            Text(
              mediaItem == null ? "No Item" : mediaItem.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            Text(
              mediaItem == null ? "No Artist" : mediaItem.artist ?? "No Artist",
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
              textAlign: TextAlign.center,
            )
          ],
        );
      },
    );
  }
}
