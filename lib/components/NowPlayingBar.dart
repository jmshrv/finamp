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
    // BottomNavBar's default elevation is 8 (https://api.flutter.dev/flutter/material/BottomNavigationBar/elevation.html)
    const elevation = 8.0;
    final color = Theme.of(context).bottomNavigationBarTheme.backgroundColor;

    return StreamBuilder<ScreenState>(
      stream: screenStateStream,
      builder: (context, snapshot) {
        connectIfDisconnected();
        if (snapshot.hasData) {
          final screenState = snapshot.data;
          final mediaItem = screenState.mediaItem;
          final state = screenState.playbackState;
          final playing = state?.playing ?? false;
          if (mediaItem != null) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Dismissible(
                key: Key("NowPlayingBar"),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    AudioService.skipToNext();
                  } else {
                    AudioService.skipToPrevious();
                  }
                  return false;
                },
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.skip_previous),
                      Icon(Icons.skip_next)
                    ],
                  ),
                ),
                child: Material(
                  elevation: elevation,
                  child: ListTile(
                    onTap: () => Navigator.of(context).pushNamed("/nowplaying"),
                    leading: AlbumImage(itemId: mediaItem.extras["parentId"]),
                    tileColor: color,
                    title: mediaItem == null
                        ? null
                        : Text(
                            mediaItem.title,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
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
                        if (playing)
                          IconButton(
                              onPressed: () => AudioService.pause(),
                              icon: Icon(Icons.pause))
                        else
                          IconButton(
                              onPressed: () => AudioService.play(),
                              icon: Icon(Icons.play_arrow)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return _NothingPlayingListTile(
              color: color,
              elevation: elevation,
            );
          }
        } else {
          return _NothingPlayingListTile(
            color: color,
            elevation: elevation,
          );
        }
      },
    );
  }
}

class _NothingPlayingListTile extends StatelessWidget {
  const _NothingPlayingListTile(
      {Key key, @required this.elevation, @required this.color})
      : super(key: key);

  final double elevation;
  final Color color;

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
            Material(
              elevation: elevation,
              child: ListTile(
                tileColor: color,
              ),
            ),
            Text(
              "Nothing Playing...",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            )
          ],
        ));
  }
}
