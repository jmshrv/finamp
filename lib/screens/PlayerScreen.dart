import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/AlbumImage.dart';
import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../models/JellyfinModels.dart';
import '../components/PlayerScreen/SongName.dart';
import '../components/PlayerScreen/ProgressSlider.dart';
import '../components/PlayerScreen/PlayerButtons.dart';
import '../components/PlayerScreen/ExitButton.dart';
import '../services/screenStateStream.dart';
import '../components/PlayerScreen/QueueList.dart';
import '../services/connectIfDisconnected.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key key}) : super(key: key);

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
                          children: [
                            Align(
                              child: ExitButton(),
                              alignment: Alignment.center,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  icon: Icon(Icons.queue_music),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(8)),
                                      ),
                                      context: context,
                                      builder: (context) {
                                        return DraggableScrollableSheet(
                                          expand: false,
                                          builder: (context, scrollController) {
                                            return QueueList(
                                              scrollController:
                                                  scrollController,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }),
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
  const _PlayerScreenAlbumImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem>(
        stream: AudioService.currentMediaItemStream,
        builder: (context, snapshot) {
          connectIfDisconnected();
          return FractionallySizedBox(
              widthFactor: 0.85,
              child: snapshot.hasData
                  ? AlbumImage(itemId: snapshot.data.id)
                  : Center(
                      child: CircularProgressIndicator(),
                    ));
        });
  }
}
