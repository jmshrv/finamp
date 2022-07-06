import 'package:audio_service/audio_service.dart';
import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../screens/AlbumScreen.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/MusicPlayerBackgroundTask.dart';

/// Creates some text that shows the song's name, album and the artist.
class SongName extends StatelessWidget {
  const SongName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final jellyfinApiData = GetIt.instance<JellyfinApiData>();

    return StreamBuilder<MediaItem?>(
      stream: _audioHandler.mediaItem,
      builder: (context, snapshot) {
        final MediaItem? mediaItem = snapshot.data;

        return Column(
          children: [
            GestureDetector(
              onTap: () => {
                if (mediaItem?.extras?["itemJson"] != null)
                  jellyfinApiData.getItemById(
                      BaseItemDto.fromJson(mediaItem?.extras?["itemJson"]).albumId as String
                  ).then((album) =>
                      Navigator.of(context).pushNamed(AlbumScreen.routeName, arguments: album)
                  )
              },
              child: Text(
                mediaItem == null ? "No Album" : mediaItem.album ?? "No Album",
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
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
