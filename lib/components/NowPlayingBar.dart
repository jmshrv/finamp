import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../components/AlbumImage.dart';
import '../services/screenStateStream.dart';
import '../services/connectIfDisconnected.dart';
import '../services/FinampSettingsHelper.dart';
import '../services/processArtist.dart';

class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // BottomNavBar's default elevation is 8 (https://api.flutter.dev/flutter/material/BottomNavigationBar/elevation.html)
    const elevation = 8.0;
    final color = Theme.of(context).bottomNavigationBarTheme.backgroundColor;

    return Material(
      color: color,
      elevation: elevation,
      child: SafeArea(
        child: StreamBuilder<ScreenState>(
          stream: screenStateStream,
          builder: (context, snapshot) {
            connectIfDisconnected();
            if (snapshot.hasData) {
              final screenState = snapshot.data!;
              final mediaItem = screenState.mediaItem;
              final state = screenState.playbackState;
              final playing = state.playing;
              if (mediaItem != null) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Dismissible(
                    key: const Key("NowPlayingBar"),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        AudioService.skipToNext();
                      } else {
                        AudioService.skipToPrevious();
                      }
                      return false;
                    },
                    background: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          AspectRatio(
                            aspectRatio: 1,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Icon(Icons.skip_previous),
                              ),
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Icon(Icons.skip_next),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: ListTile(
                      onTap: () =>
                          Navigator.of(context).pushNamed("/nowplaying"),
                      // We put the album image in a ValueListenableBuilder so that it reacts to offline changes
                      leading: ValueListenableBuilder(
                        valueListenable:
                            FinampSettingsHelper.finampSettingsListener,
                        builder: (context, _, widget) => AlbumImage(
                          itemId: mediaItem.extras!["parentId"],
                        ),
                      ),
                      title: Text(
                        mediaItem.title,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                      subtitle: Text(
                        processArtist(mediaItem.artist),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          playing
                              ? IconButton(
                                  icon: const Icon(Icons.pause),
                                  onPressed: () => AudioService.pause(),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () => AudioService.play(),
                                ),
                          IconButton(
                            icon: const Icon(Icons.stop),
                            onPressed: () => AudioService.stop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox(
                  width: 0,
                  height: 0,
                );
              }
            } else {
              return const SizedBox(
                width: 0,
                height: 0,
              );
            }
          },
        ),
      ),
    );
  }
}
