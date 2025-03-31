import 'dart:async';

import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:progress_border/progress_border.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AudioFadeProgressVisualizerContainer extends StatefulWidget {
  const AudioFadeProgressVisualizerContainer({
    required super.key,
    required this.child,
    this.border,
    this.borderRadius,
    this.width,
    this.height,
  });

  final Widget child;
  final Border? border;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  @override
  State<AudioFadeProgressVisualizerContainer> createState() =>
      _AudioFadeProgressVisualizerContainerState();
}

class _AudioFadeProgressVisualizerContainerState
    extends State<AudioFadeProgressVisualizerContainer>
    with SingleTickerProviderStateMixin {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  late FadeState _state;
  late Animation<double> _animation;
  late final StreamSubscription<FadeState> _stateSubscription;
  late final AnimationController _controller;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: FinampSettingsHelper.finampSettings.audioFadeInDuration,
        vsync: this);

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    resetFade();

    _stateSubscription = _audioHandler.fadeState.listen((state) async {
      if (_isVisible && state.fadeDirection != _state.fadeDirection) {
        if (state.fadeDirection == FadeDirection.fadeOut) {
          if (_state.fadeDirection == FadeDirection.fadeIn) {
            startFadeOut(from: state.fadeVolumePercent);
          } else {
            startFadeOut();
          }
        } else if (state.fadeDirection == FadeDirection.fadeIn) {
          if (_state.fadeDirection == FadeDirection.fadeOut) {
            startFadeIn(from: state.fadeVolumePercent);
          } else {
            startFadeIn();
          }
        }
      }
      setState(() {
        _state = state;
      });
    });
  }

  void resetFade() {
    setState(() {
      _state = _audioHandler.fadeState.value;
    });

    if (_state.fadeDirection != FadeDirection.none) {
      if (_state.fadeDirection == FadeDirection.fadeOut) {
        startFadeOut(from: _state.fadeVolumePercent);
      } else if (_state.fadeDirection == FadeDirection.fadeIn) {
        startFadeIn(from: _state.fadeVolumePercent);
      }
    }
  }

  void startFadeIn({double? from}) {
    _controller.duration =
        FinampSettingsHelper.finampSettings.audioFadeInDuration;
    _controller.forward(from: from ?? 0.0);
  }

  void startFadeOut({double? from}) {
    _controller.duration =
        FinampSettingsHelper.finampSettings.audioFadeOutDuration;
    _controller.reverse(from: from ?? 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _stateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: widget.key!,
        onVisibilityChanged: (visibleState) {
          final bool visible = visibleState.visibleFraction > 0.0;

          if (!context.mounted) return;

          // If visible state changed to visible
          if (visible != _isVisible && visible) {
            resetFade();
          }

          setState(() {
            _isVisible = visible;
          });
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  border: _controller.status == AnimationStatus.forward ||
                          _controller.status == AnimationStatus.reverse
                      ? ProgressBorder.all(
                          color: IconTheme.of(context).color!.withAlpha(128),
                          width: 4,
                          progress: _animation.value,
                        )
                      : null,
                ),
                child: widget.child);
          },
        ));
  }
}
