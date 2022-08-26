import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/PlayerScreen/finamp_back_button_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/song_info.dart';
import '../components/favourite_button.dart';
import '../services/finamp_settings_helper.dart';
import '../services/music_player_background_task.dart';
import '../models/jellyfin_models.dart';
import '../components/album_image.dart';
import '../components/PlayerScreen/song_name_content.dart';
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
          centerTitle: true,
          leadingWidth: 48 + 24,
          toolbarHeight: 75,
          // actions: const [
          //   SleepTimerButton(),
          //   AddToPlaylistButton(),
          // ],
          // title: Baseline(
          //   baselineType: TextBaseline.alphabetic,
          //   baseline: 0,
          //   child: Text.rich(
          //     textAlign: TextAlign.center,
          //     TextSpan(
          //       style: GoogleFonts.montserrat(),
          //       children: [
          //         TextSpan(
          //           text: "Playing From\n",
          //           style: TextStyle(
          //               fontSize: 12,
          //               color: Colors.white.withOpacity(0.7),
          //               height: 3),
          //         ),
          //         const TextSpan(
          //           text: "Your Likes",
          //           style: TextStyle(
          //             fontSize: 16,
          //             color: Colors.white,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          title: Baseline(
            baselineType: TextBaseline.alphabetic,
            baseline: 0,
            child: Column(
              children: [
                Text(
                  "Playing From",
                  style: GoogleFonts.lexendDeca(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                Text(
                  "Somewhere",
                  style: GoogleFonts.lexendDeca(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
            child: PlayerScreenAppBarItemButton(
              icon: const FinampBackButtonIcon(),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
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
                    const SongInfo(),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // const SongName(),
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

class PlayerScreenAppBarItemButton extends StatelessWidget {
  const PlayerScreenAppBarItemButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(48 / 2),
        ),
        alignment: Alignment.center,
        child: icon,
      ),
      onPressed: onPressed,
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
          return snapshot.hasData
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

            dynWidget ??= const SizedBox.shrink();

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: dynWidget,
            );
          } else {
            return const SizedBox.shrink();
          }
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
