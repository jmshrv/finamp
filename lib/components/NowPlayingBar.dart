import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../components/AlbumImage.dart';
import '../services/screenStateStream.dart';
import '../services/connectIfDisconnected.dart';

class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ScreenState>(
      stream: screenStateStream,
      builder: (context, snapshot) {
        connectIfDisconnected();
        if (snapshot.hasData) {
          final screenState = snapshot.data;
          final queue = screenState.queue;
          final mediaItem = screenState.mediaItem;
          final state = screenState.playbackState;
          final processingState =
              state?.processingState ?? AudioProcessingState.none;
          final playing = state?.playing ?? false;
          if (mediaItem != null) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                onTap: () => Navigator.of(context).pushNamed("/nowplaying"),
                leading: AlbumImage(itemId: mediaItem.id),
                title: mediaItem == null
                    ? null
                    : Text(
                        mediaItem.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                subtitle: mediaItem == null
                    ? null
                    : Text(
                        mediaItem.album,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () => AudioService.skipToPrevious(),
                        icon: Icon(Icons.skip_previous)),
                    if (playing)
                      IconButton(
                          onPressed: () => AudioService.pause(),
                          icon: Icon(Icons.pause))
                    else
                      IconButton(
                          onPressed: () => AudioService.play(),
                          icon: Icon(Icons.play_arrow)),
                    IconButton(
                        onPressed: () => AudioService.skipToNext(),
                        icon: Icon(Icons.skip_next)),
                  ],
                ),
              ),
            );
          } else {
            return _NothingPlayingListTile();
          }
        } else {
          return _NothingPlayingListTile();
        }
      },
    );
  }
}

class _NothingPlayingListTile extends StatelessWidget {
  const _NothingPlayingListTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        // The child below looks pretty stupid but it's actually genius.
        // I wanted the NowPlayingBar to stay the same length when it doesn't have data
        // but I didn't want to actually use a ListTile to tell the user that.
        // I use a ListTile to create a box with the right height, and put whatever I want on top.
        // I could just make a container with the length of a ListTile, but that value could change in the future.
        child: Stack(
          alignment: Alignment.center,
          children: [
            ListTile(),
            Text(
              "Nothing Playing...",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            )
          ],
        ));
  }
}
