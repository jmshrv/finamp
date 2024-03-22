import 'dart:io';

import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/components/PlayerScreen/player_screen_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/control_area.dart';
import '../components/PlayerScreen/queue_button.dart';
import '../components/PlayerScreen/queue_list.dart';
import '../components/PlayerScreen/song_info.dart';
import '../components/finamp_app_bar_button.dart';
import '../services/finamp_settings_helper.dart';
import '../services/player_screen_theme_provider.dart';
import 'blurred_player_screen_background.dart';

const _toolbarHeight = 52.0;

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  static const routeName = "/nowplaying";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageTheme =
        ref.watch(playerScreenThemeProvider(Theme.of(context).brightness));

    return AnimatedTheme(
      duration: const Duration(milliseconds: 500),
      data: ThemeData(
        colorScheme: imageTheme.copyWith(
          brightness: Theme.of(context).brightness,
        ),
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: imageTheme.primary,
            ),
      ),
      child: const _PlayerScreenContent(),
    );
  }
}

class _PlayerScreenContent extends StatelessWidget {
  const _PlayerScreenContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleGestureDetector(
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
          toolbarHeight: _toolbarHeight,
          title: const PlayerScreenAppBarTitle(),
          leading: FinampAppBarButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            if (Platform.isIOS)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AirPlayRoutePickerView(
                  tintColor: IconTheme.of(context).color ?? Colors.white,
                  activeTintColor: jellyfinBlueColor,
                  onShowPickerView: () =>
                      Vibrate.feedback(FeedbackType.selection),
                ),
              ),
          ],
        ),
        // Required for sleep timer input
        resizeToAvoidBottomInset: false, extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            if (FinampSettingsHelper.finampSettings.showCoverAsPlayerBackground)
              const BlurredPlayerScreenBackground(),
            const SafeArea(
              minimum: EdgeInsets.only(top: _toolbarHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(flex: 1000, fit: FlexFit.tight, child: SongInfo()),
                  // Flexible(
                  //     flex: 40, fit: FlexFit.loose, child: ControlArea()),
                  ControlArea(),
                  Flexible(flex: 10, child: SizedBox.shrink()),
                  QueueButton(),
                  Flexible(flex: 2, child: SizedBox.shrink()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
