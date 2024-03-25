import 'dart:io';
import 'dart:math';

import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/components/PlayerScreen/player_screen_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/control_area.dart';
import '../components/PlayerScreen/player_screen_album_image.dart';
import '../components/PlayerScreen/queue_button.dart';
import '../components/PlayerScreen/queue_list.dart';
import '../components/PlayerScreen/song_name_content.dart';
import '../components/finamp_app_bar_button.dart';
import '../services/finamp_settings_helper.dart';
import '../services/player_screen_theme_provider.dart';
import 'blurred_player_screen_background.dart';

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
    double toolbarHeight = 53.0;
    int maxToolbarLines = 2;
    // If in landscape, only show 2 lines in toolbar instead of 3
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      toolbarHeight = 36.0;
      maxToolbarLines = 1;
    }

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
          toolbarHeight: toolbarHeight,
          title: PlayerScreenAppBarTitle(
            maxLines: maxToolbarLines,
          ),
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
            SafeArea(
              minimum: EdgeInsets.only(top: toolbarHeight),
              child: LayoutBuilder(builder: (context, constraints) {
                double targetHeight;
                if (MediaQuery.of(context).orientation ==
                    Orientation.landscape) {
                  targetHeight = constraints.maxHeight - 5;
                  double targetWidth;
                  // We want controls to be half the screen, but allow expanding
                  // up to 2/3 if that allows all buttons to show.  Never go narrower
                  // than 160 to allow showing basic play controls.
                  if (constraints.maxWidth * 2 / 3 > 260) {
                    targetWidth = max(260, constraints.maxWidth / 2);
                  } else {
                    targetWidth = max(160, constraints.maxWidth / 2);
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding:
                                EdgeInsets.all(constraints.maxHeight * 0.03),
                            child: PlayerScreenAlbumImage(targetHeight)),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: targetWidth),
                        child: Column(
                          children: [
                            const Spacer(flex: 4),
                            SongNameContent(targetHeight),
                            const Spacer(flex: 4),
                            ControlArea(targetHeight),
                            if (targetHeight >= 250) const Spacer(flex: 10),
                            if (targetHeight >= 250) const QueueButton(),
                            const Spacer(
                              flex: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  var maxPadding = FinampSettingsHelper
                          .finampSettings.playerScreenCoverMinimumPadding +
                      10;
                  targetHeight = constraints.maxHeight +
                      constraints.maxWidth * ((maxPadding / 100.0) * 2 - 1);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(child: PlayerScreenAlbumImage(targetHeight)),
                      SongNameContent(targetHeight),
                      ControlArea(targetHeight),
                      if (targetHeight >= 250) const QueueButton(),
                      if (targetHeight < 250)
                        const SizedBox(
                          height: 5,
                        )
                    ],
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
