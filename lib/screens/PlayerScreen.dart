import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/FavoriteButton.dart';
import '../services/MusicPlayerBackgroundTask.dart';
import '../models/JellyfinModels.dart';
import '../components/AlbumImage.dart';
import '../components/PlayerScreen/SongName.dart';
import '../components/PlayerScreen/ProgressSlider.dart';
import '../components/PlayerScreen/PlayerButtons.dart';
import '../components/PlayerScreen/QueueButton.dart';
import '../components/PlayerScreen/PlaybackMode.dart';
import '../components/PlayerScreen/AddToPlaylistButton.dart';
import '../components/PlayerScreen/SleepTimerButton.dart';

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [
            SleepTimerButton(),
            AddToPlaylistButton(),
          ],
        ),
        // Required for sleep timer input
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                  child: const _PlayerScreenAlbumImage(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SongName(),
                        const ProgressSlider(),
                        const PlayerButtons(),
                        Stack(
                          alignment: Alignment.center,
                          children: const [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: PlaybackMode(),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: const FavoriteButton(),
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
    final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
        stream: _audioHandler.mediaItem,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: snapshot.hasData
                ? AlbumImage(
                    item: snapshot.data?.extras?["itemJson"] == null
                        ? null
                        : BaseItemDto.fromJson(
                            snapshot.data!.extras!["itemJson"]))
                : AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: AlbumImage.borderRadius,
                      child: Container(color: Theme.of(context).cardColor),
                    ),
                  ),
          );
        });
  }
}
