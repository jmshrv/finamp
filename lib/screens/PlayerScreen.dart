import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/AlbumImage.dart';
import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/SongName.dart';
import '../components/PlayerScreen/ProgressSlider.dart';
import '../components/PlayerScreen/PlayerButtons.dart';
import '../components/PlayerScreen/ExitButton.dart';
import '../components/PlayerScreen/QueueButton.dart';
import '../components/PlayerScreen/PlaybackMode.dart';
import '../services/connectIfDisconnected.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleGestureDetector(
      onVerticalSwipe: (direction) {
        if (direction == SwipeDirection.down) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PlayerScreenAlbumImage(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SongName(),
                        ProgressSlider(),
                        PlayerButtons(),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: PlaybackMode()),
                            Align(
                              alignment: Alignment.center,
                              child: ExitButton(),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: QueueButton(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// This widget is just an AlbumImage in a StreamBuilder to get the song id.
class _PlayerScreenAlbumImage extends StatelessWidget {
  const _PlayerScreenAlbumImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;

    final imageWidth = isPortrait
        ? MediaQuery.of(context).size.width * 0.85
        : MediaQuery.of(context).size.height * 0.5;

    return StreamBuilder<MediaItem?>(
        stream: AudioService.currentMediaItemStream,
        builder: (context, snapshot) {
          connectIfDisconnected();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: imageWidth,
              child: snapshot.hasData
                  ? AlbumImage(itemId: snapshot.data!.extras!["parentId"])
                  // : AspectRatio(
                  //     aspectRatio: 1,
                  //     child: ClipRRect(
                  //       borderRadius:
                  //           BorderRadius.circular(AlbumImage.borderRadius),
                  //       child: Container(color: Theme.of(context).cardColor),
                  //     ),
                  //   ),
                  : Container(
                      width: 100,
                      height: 100,
                    ),
            ),
          );
        });
  }
}
