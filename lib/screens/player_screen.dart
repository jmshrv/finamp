import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/PlayerScreen/finamp_back_button_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:octo_image/octo_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/song_info.dart';
import '../components/favourite_button.dart';
import '../services/current_album_image_provider.dart';
import '../services/finamp_settings_helper.dart';
import '../services/music_player_background_task.dart';
import '../models/jellyfin_models.dart';
import '../components/PlayerScreen/progress_slider.dart';
import '../components/PlayerScreen/player_buttons.dart';
import '../components/PlayerScreen/queue_button.dart';
import '../components/PlayerScreen/playback_mode.dart';

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
              const _BlurredPlayerScreenBackground(),
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

/// Same as [_PlayerScreenAlbumImage], but with a BlurHash instead. We also
/// filter the BlurHash so that it works as a background image.
class _BlurredPlayerScreenBackground extends ConsumerWidget {
  const _BlurredPlayerScreenBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageProvider = ref.watch(currentAlbumImageProvider);

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
