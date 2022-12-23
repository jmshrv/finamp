import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:octo_image/octo_image.dart';
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

final _albumImageProvider =
    StateProvider.autoDispose<ImageProvider?>((_) => null);

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  static const routeName = "/nowplaying";

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return SimpleGestureDetector(
      onVerticalSwipe: (direction) {
        if (direction == SwipeDirection.down) {
          Navigator.of(context).pop();
        }
      },
      onHorizontalSwipe: (direction) {
        switch (direction) {
          case SwipeDirection.left:
            audioHandler.skipToNext();
            break;
          case SwipeDirection.right:
            audioHandler.skipToPrevious();
            break;
          default:
            break;
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
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            if (FinampSettingsHelper.finampSettings.showCoverAsPlayerBackground)
              const _BlurredPlayerScreenBackground(),
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
class _PlayerScreenAlbumImage extends ConsumerWidget {
  const _PlayerScreenAlbumImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final item = snapshot.data?.extras?["itemJson"] == null
              ? null
              : BaseItemDto.fromJson(snapshot.data!.extras!["itemJson"]);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: item == null
                ? AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: AlbumImage.borderRadius,
                      child: Container(color: Theme.of(context).cardColor),
                    ),
                  )
                : AlbumImage(
                    item: item,
                    imageProviderCallback: (imageProvider) =>
                        // We need a post frame callback because otherwise this
                        // widget rebuilds on the same frame
                        WidgetsBinding.instance.addPostFrameCallback((_) => ref
                            .read(_albumImageProvider.notifier)
                            .state = imageProvider),
                    // Here we awkwardly get the next 3 queue items so that we
                    // can precache them (so that the image is already loaded
                    // when the next song comes on).
                    itemsToPrecache: audioHandler.queue.value
                        .sublist(min(
                            (audioHandler.playbackState.value.queueIndex ?? 0) +
                                1,
                            audioHandler.queue.value.length))
                        .take(3)
                        .map((e) => BaseItemDto.fromJson(e.extras!["itemJson"]))
                        .toList(),
                  ),
          );
        });
  }
}

/// Same as [_PlayerScreenAlbumImage], but with a BlurHash instead. We also
/// filter the BlurHash so that it works as a background image.
class _BlurredPlayerScreenBackground extends ConsumerWidget {
  const _BlurredPlayerScreenBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageProvider = ref.watch(_albumImageProvider);

    return ClipRect(
      child: imageProvider == null
          ? const SizedBox.shrink()
          : OctoImage(
              image: imageProvider,
              fit: BoxFit.cover,
              placeholderBuilder: (_) => const SizedBox.shrink(),
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              imageBuilder: (context, child) => ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.35)
                        : Colors.white.withOpacity(0.75),
                    BlendMode.srcOver),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                      sigmaX: 100, sigmaY: 100, tileMode: TileMode.mirror),
                  child: SizedBox.expand(child: child),
                ),
              ),
            ),
    );
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
