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
                var controller = PlayerHideableController();
                if (MediaQuery.of(context).orientation ==
                    Orientation.landscape) {
                  controller.setSizeLandscape(
                      Size(constraints.maxWidth, constraints.maxHeight));
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding:
                                EdgeInsets.all(constraints.maxHeight * 0.03),
                            child: const PlayerScreenAlbumImage()),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: controller.getTarget().width),
                        child: Column(
                          children: [
                            const Spacer(flex: 4),
                            SongNameContent(controller),
                            const Spacer(flex: 4),
                            ControlArea(controller),
                            if (controller.shown(PlayerHideable.queueButton))
                              const Spacer(flex: 10),
                            if (controller.shown(PlayerHideable.queueButton))
                              const QueueButton(),
                            const Spacer(
                              flex: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  controller.setSizePortrait(
                      Size(constraints.maxWidth, constraints.maxHeight));
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Flexible(child: PlayerScreenAlbumImage()),
                      SongNameContent(controller),
                      ControlArea(controller),
                      if (controller.shown(PlayerHideable.queueButton))
                        const QueueButton(),
                      if (!controller.shown(PlayerHideable.queueButton))
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

enum PlayerHideable {
  bigPlayButton(14, 14),
  queueButton(0, 27),
  progressSlider(0, 14),
  twoLineTitle(0, 27),
  codecInfo(0, 20),
  loopShuffleButtons(96, 0);

  final double width;
  final double height;

  const PlayerHideable(this.width, this.height);
}

class PlayerHideableController {
  final verticalHideOrder = [
    PlayerHideable.bigPlayButton,
    PlayerHideable.queueButton,
    PlayerHideable.codecInfo,
    PlayerHideable.twoLineTitle,
    PlayerHideable.progressSlider
  ];

  List<PlayerHideable> _visible = [];
  Size? _target;

  void setSizePortrait(Size size) {
    _visible = List.from(PlayerHideable.values);

    var maxPadding =
        FinampSettingsHelper.finampSettings.playerScreenCoverMinimumPadding + 8;
    var targetHeight =
        size.height + size.width * ((maxPadding / 100.0) * 2 - 1);
    var targetWidth = size.width;
    _target = Size(targetWidth, targetHeight);

    if (_getSize().width >= targetWidth) {
      _visible.remove(PlayerHideable.bigPlayButton);
      if (_getSize().width >= targetWidth) {
        _visible.add(PlayerHideable.bigPlayButton);
        _visible.remove(PlayerHideable.loopShuffleButtons);
        if (_getSize().width >= targetWidth) {
          _visible.remove(PlayerHideable.bigPlayButton);
        }
      }
    }

    for (var element in verticalHideOrder) {
      if (_getSize().height < targetHeight) {
        return;
      }
      _visible.remove(element);
    }
  }

  void setSizeLandscape(Size size) {
    _visible = List.from(PlayerHideable.values);

    var targetHeight = size.height - 5;
    if (_getSize().width >= size.width * 0.6) {
      _visible.remove(PlayerHideable.bigPlayButton);
      if (_getSize().width >= size.width * 0.6) {
        _visible.add(PlayerHideable.bigPlayButton);
        _visible.remove(PlayerHideable.loopShuffleButtons);
        if (_getSize().width >= size.width * 0.6) {
          _visible.remove(PlayerHideable.bigPlayButton);
        }
      }
    }
    // Prevent allocating extra space between 50% and 60% of width if we're just
    // going to shrink the play button anyway.
    if (_getSize().height >= targetHeight) {
      _visible.remove(PlayerHideable.bigPlayButton);
    }
    var targetWidth = max(_getSize().width, size.width / 2);
    _target = Size(targetWidth, targetHeight);

    for (var element in verticalHideOrder) {
      if (_getSize().height < targetHeight) {
        return;
      }
      _visible.remove(element);
    }
  }

  Size _getSize() {
    double height = 162;
    double width = 144;
    for (var element in _visible) {
      height += element.height;
      width += element.width;
    }
    return Size(width, height);
  }

  Size getTarget() {
    return _target ?? _getSize();
  }

  bool shown(PlayerHideable element) {
    return _visible.contains(element);
  }
}
