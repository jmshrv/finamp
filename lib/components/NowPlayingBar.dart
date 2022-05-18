import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../components/AlbumImage.dart';
import '../models/JellyfinModels.dart';
import '../services/progressStateStream.dart';
import '../services/FinampSettingsHelper.dart';
import '../services/processArtist.dart';
import '../services/MusicPlayerBackgroundTask.dart';
import 'PlayerScreen/ProgressSlider.dart';

class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // BottomNavBar's default elevation is 8 (https://api.flutter.dev/flutter/material/BottomNavigationBar/elevation.html)
    const elevation = 8.0;
    final color = Theme.of(context).bottomNavigationBarTheme.backgroundColor;

    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<ProgressState>(
      stream: progressStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final playing = snapshot.data!.playbackState.playing;

          // If we have a media item and the player hasn't finished, show
          // the now playing bar.
          if (snapshot.data!.mediaItem != null) {
            return Material(
              color: color,
              elevation: elevation,
              child: SafeArea(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      const ProgressSlider(
                        allowSeeking: false,
                        showBuffer: false,
                        showDuration: false,
                        showPlaceholder: false,
                      ),
                      Dismissible(
                        key: const Key("NowPlayingBar"),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            audioHandler.skipToNext();
                          } else {
                            audioHandler.skipToPrevious();
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
                              item: BaseItemDto.fromJson(
                                  snapshot.data!.mediaItem!.extras!["itemJson"]),
                            ),
                          ),
                          title: Text(
                            snapshot.data!.mediaItem!.title,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          subtitle: Text(
                            processArtist(snapshot.data!.mediaItem!.artist),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (snapshot.data!.playbackState.processingState !=
                                  AudioProcessingState.idle)
                                IconButton(
                                  // We have a key here because otherwise the
                                  // InkWell moves over to the play/pause button
                                  key: const ValueKey("StopButton"),
                                  icon: const Icon(Icons.stop),
                                  onPressed: () => audioHandler.stop(),
                                ),
                              playing
                                  ? IconButton(
                                      icon: const Icon(Icons.pause),
                                      onPressed: () => audioHandler.pause(),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.play_arrow),
                                      onPressed: () => audioHandler.play(),
                                    ),
                            ],
                          ),
                        ),
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
    );
  }
}
