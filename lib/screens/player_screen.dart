import 'dart:ui';

import 'package:finamp/components/PlayerScreen/player_screen_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:octo_image/octo_image.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/control_area.dart';
import '../components/PlayerScreen/song_info.dart';
import '../components/PlayerScreen/queue_button.dart';
import '../components/finamp_app_bar_button.dart';
import '../components/PlayerScreen/queue_list.dart';
import '../services/current_album_image_provider.dart';
import '../services/finamp_settings_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:get_it/get_it.dart';
import '../models/finamp_models.dart';

import '../services/player_screen_theme_provider.dart';

const _toolbarHeight = 75.0;

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  static const routeName = "/nowplaying";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageTheme = ref.watch(playerScreenThemeProvider);

    return Theme(
      data: ThemeData(
        fontFamily: "LexendDeca",
        colorScheme: imageTheme,
        brightness: Theme.of(context).brightness,
        iconTheme: Theme.of(context).iconTheme.copyWith(
          color: imageTheme?.primary,
        ),
      ),
      child: SimpleGestureDetector(
        onVerticalSwipe: (direction) {
          if (!FinampSettingsHelper.finampSettings.disableGesture) {
            if (direction == SwipeDirection.down) {
              Navigator.of(context).pop();
            } else if (direction == SwipeDirection.up) {
              showQueueBottomSheet(context);
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leadingWidth: 48 + 24,
            toolbarHeight: _toolbarHeight,
            title: const PlayerScreenAppBarTitle(),
            leading: FinampAppBarButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Required for sleep timer input
          resizeToAvoidBottomInset: false, extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              if (FinampSettingsHelper
                  .finampSettings.showCoverAsPlayerBackground)
                const _BlurredPlayerScreenBackground(),
              const SafeArea(
                minimum: EdgeInsets.only(top: _toolbarHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [SongInfo(), ControlArea(), QueueButton()],
                ),
              ),
            ],
          ),
        ),
      ),
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
                        ? Colors.black.withOpacity(0.75)
                        : Colors.white.withOpacity(0.50),
                    BlendMode.srcOver),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 85,
                    sigmaY: 85,
                    tileMode: TileMode.mirror,
                  ),
                  child: SizedBox.expand(child: child),
                ),
              ),
            ),
    );
  }
}
