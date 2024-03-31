import 'dart:io';
import 'dart:math';

import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/components/PlayerScreen/player_screen_appbar_title.dart';
import 'package:finamp/services/feedback_helper.dart';
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

    var controller = PlayerHideableController();

    return SimpleGestureDetector(
      onVerticalSwipe: (direction) {
        if (direction == SwipeDirection.down) {
          if (!FinampSettingsHelper.finampSettings.disableGesture) {
            Navigator.of(context).pop();
          }
        } else if (direction == SwipeDirection.up) {
          // This should never actually be called until widget finishes build and controller is initialized
          if (!FinampSettingsHelper.finampSettings.disableGesture ||
              !controller.shouldShow(PlayerHideable.queueButton)) {
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
                      FeedbackHelper.feedback(FeedbackType.selection),
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
                if (MediaQuery.of(context).orientation ==
                    Orientation.landscape) {
                  controller.updateLayoutLandscape(
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
                            if (controller
                                .shouldShow(PlayerHideable.queueButton))
                              const Spacer(flex: 10),
                            if (controller
                                .shouldShow(PlayerHideable.queueButton))
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
                  controller.updateLayoutPortrait(
                      Size(constraints.maxWidth, constraints.maxHeight));
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          height: min(
                              constraints.maxHeight -
                                  controller.getTarget().height,
                              constraints.maxWidth),
                          child: const PlayerScreenAlbumImage()),
                      SongNameContent(controller),
                      ControlArea(controller),
                      if (controller.shouldShow(PlayerHideable.queueButton))
                        const QueueButton(),
                      if (!controller.shouldShow(PlayerHideable.queueButton))
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
  bigPlayButton(14, 14, 1),
  queueButton(0, 27, 2),
  progressSlider(0, 14, 4),
  twoLineTitle(0, 27, 3),
  codecInfo(0, 20, 3),
  loopShuffleButtons(96, 0, 0),
  unhideableElements(144, 162, 0),
  controlsPaddingSmall(0, 8, 2),
  controlsPaddingBig(0, 12, 1);

  // The width/height added to the overall player screen when this item is shown.
  // Calculated by shrinking player screen control area until overflow both with
  // element shown and with element hidden, and then comparing those values.  These
  // are added together to predict the size of a player screen layout before it actually
  // gets built.
  final double width;
  final double height;

  // The maximum amount to shrink the cover image, per side, in order to show this element.
  // Needs to be multiplied by finampSettings.prioritizeCoverFactor.
  final double maxShrink;

  const PlayerHideable(this.width, this.height, this.maxShrink);
}

/// Controls what elements of the player screen are shown/hidden.
class PlayerHideableController {
  final verticalHideOrder = [
    PlayerHideable.controlsPaddingBig,
    PlayerHideable.bigPlayButton,
    PlayerHideable.queueButton,
    PlayerHideable.controlsPaddingSmall,
    PlayerHideable.codecInfo,
    PlayerHideable.twoLineTitle,
    PlayerHideable.progressSlider
  ];

  List<PlayerHideable> _visible = [];
  Size _target = const Size(0, 0);

  /// Update player screen hidden elements based on usable area in portrait mode.
  void updateLayoutPortrait(Size size) {
    _reset();

    var targetWidth = size.width;
    _updateLayoutFromWidth(targetWidth);

    // Update _visible based on a target height.  Removes elements in order of priority
    // until target is met.
    for (var element in verticalHideOrder) {
      // Allow shrinking album by up to (element.maxShrink)% of screen width per side beyond the user specified minimum value
      // if it allows us to show more controls.
      var maxDesiredPadding =
          FinampSettingsHelper.finampSettings.playerScreenCoverMinimumPadding +
              element.maxShrink *
                  FinampSettingsHelper.finampSettings.prioritizeCoverFactor;
      // Calculate max allowable control height to avoid shrinking album cover beyond maxPadding.
      var targetHeight =
          size.height - size.width * (1 - (maxDesiredPadding / 100.0) * 2);
      if (_getSize().height < targetHeight) {
        break;
      }
      _visible.remove(element);
    }
    _target = Size(targetWidth, _getSize().height);
  }

  /// Update player screen hidden elements based on usable area in landscape mode.
  void updateLayoutLandscape(Size size) {
    _reset();
    // We never want to allocate extra width to album covers while some controls
    // are hidden.
    var desiredControlsWidth = min(_getSize().width, size.width - size.height);

    // Never expand the controls beyond 65% unless the remaining space is just album padding
    var maxControlsWidth = max(size.width * 0.65, size.width - size.height);
    _updateLayoutFromWidth(maxControlsWidth);

    var targetHeight = size.height;
    // Prevent allocating extra space between 50% and maxControlsWidth if we're just
    // going to shrink the play button anyway.
    if (_getSize().height >= targetHeight) {
      _visible.remove(PlayerHideable.bigPlayButton);
    }
    // Force controls width to always be at least 50% of screen.
    var minControlsWidth = max(_getSize().width, size.width / 2);
    // If the minimum and maximum sizes do not form a valid range, prioritize the minimum
    // and shrink the album to avoid the controls clipping.
    double targetWidth = desiredControlsWidth.clamp(
        minControlsWidth, max(minControlsWidth, maxControlsWidth));
    _target = Size(targetWidth, targetHeight);

    // Update _visible based on a target height.  Removes elements in order of priority
    // until target is met.
    for (var element in verticalHideOrder) {
      if (_getSize().height < targetHeight) {
        return;
      }
      _visible.remove(element);
    }
  }

  /// Update _visible based on a target width.  Only shrink player button if it would fit the constraints,
  /// otherwise only hide loop & shuffle buttons if that would fit the constraints, otherwise do both.
  void _updateLayoutFromWidth(double target) {
    var maxWidth = _getSize().width;
    if (maxWidth >= target) {
      if (maxWidth - PlayerHideable.bigPlayButton.width < target) {
        _visible.remove(PlayerHideable.bigPlayButton);
      } else if (maxWidth - PlayerHideable.loopShuffleButtons.width < target) {
        _visible.remove(PlayerHideable.loopShuffleButtons);
      } else {
        _visible.remove(PlayerHideable.bigPlayButton);
        _visible.remove(PlayerHideable.loopShuffleButtons);
      }
    }
  }

  /// Reset to use maximum size
  void _reset() {
    _visible = List.from(PlayerHideable.values);
    _target = const Size(0, 0);
    if (FinampSettingsHelper.finampSettings.hideQueueButton) {
      _visible.remove(PlayerHideable.queueButton);
    }
    if (FinampSettingsHelper.finampSettings.suppressPlayerPadding) {
      _visible.remove(PlayerHideable.controlsPaddingSmall);
      _visible.remove(PlayerHideable.controlsPaddingBig);
    }
  }

  /// Gets predicted size of player controls based on current _visible items.
  Size _getSize() {
    double height = 0;
    double width = 0;
    for (var element in _visible) {
      height += element.height;
      width += element.width;
    }
    return Size(width, height);
  }

  /// Get player controls target size
  Size getTarget() {
    return _target;
  }

  /// Get whether a player control element should be shown or hidden based on screen size.
  bool shouldShow(PlayerHideable element) {
    assert(_target.width > 0 && _target.height > 0);
    return _visible.contains(element);
  }
}
