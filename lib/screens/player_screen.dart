import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/favourite_button.dart';
import '../services/finamp_settings_helper.dart';
import '../services/music_player_background_task.dart';
import '../models/jellyfin_models.dart';
import '../components/album_image.dart';
import '../components/PlayerScreen/song_name.dart';
import '../components/PlayerScreen/progress_slider.dart';
import '../components/PlayerScreen/player_buttons.dart';
import '../components/PlayerScreen/queue_button.dart';
import '../components/PlayerScreen/playback_mode.dart';
import '../components/PlayerScreen/add_to_playlist_button.dart';
import '../components/PlayerScreen/sleep_timer_button.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  static const routeName = "/nowplaying";

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
        resizeToAvoidBottomInset: false, extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            if (FinampSettingsHelper.finampSettings.showCoverAsPlayerBackground)
              const _PlayerScreenBlurHash(),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Expanded(
                      child: _PlayerScreenAlbumImage(),
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
                                  child: _PlayerScreenFavoriteButton(),
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
          ],
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
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
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

/// Same as [_PlayerScreenAlbumImage], but with a BlurHash instead. We also
/// filter the BlurHash so that it works as a background image.
class _PlayerScreenBlurHash extends StatelessWidget {
  const _PlayerScreenBlurHash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          Widget? dynWidget;
          if (snapshot.hasData) {
            final item =
                BaseItemDto.fromJson(snapshot.data!.extras!["itemJson"]);

            final blurHash = item.imageBlurHashes?.primary?.values.first;

            if (blurHash != null) {
              dynWidget = ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.35)
                        : Colors.white.withOpacity(0.75),
                    BlendMode.srcOver),
                key: ValueKey<String>(blurHash),
                child: BlurHash(
                  hash: blurHash,
                  imageFit: BoxFit.cover,
                ),
              );
            }
          }

          dynWidget ??= const SizedBox.shrink();

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: dynWidget,
          );
        });
  }
}

class _PlayerScreenFavoriteButton extends StatelessWidget {
  const _PlayerScreenFavoriteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          return FavoriteButton(
            item: snapshot.data?.extras?["itemJson"] == null
                ? null
                : BaseItemDto.fromJson(snapshot.data!.extras!["itemJson"]),
            inPlayer: true,
          );
        });
  }
}
