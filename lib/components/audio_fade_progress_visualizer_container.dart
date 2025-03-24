import 'dart:async';

import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:progress_border/progress_border.dart';

class FadeProgressContainer extends StatefulWidget {
  const FadeProgressContainer({
    super.key,
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
  State<FadeProgressContainer> createState() => _FadeProgressContainerState();
}

class _FadeProgressContainerState extends State<FadeProgressContainer>
    with SingleTickerProviderStateMixin {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  late FadeState _state;
  late Animation<double> _animation;
  late StreamSubscription<FadeState> _stateSubscription;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _state = audioHandler.fadeState.value;

    _controller = AnimationController(
        duration: FinampSettingsHelper.finampSettings.audioFadeInDuration,
        vsync: this);

    if (_state.fadeDirection != FadeDirection.none) {
      if (_state.fadeDirection == FadeDirection.fadeOut) {
        startFadeOut(from: _state.fadeVolumePercent);
      } else if (_state.fadeDirection == FadeDirection.fadeIn) {
        startFadeIn(from: _state.fadeVolumePercent);
      }
    }

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _stateSubscription = audioHandler.fadeState.listen((state) {
      if (state.fadeDirection != _state.fadeDirection) {
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

  void startFadeIn({double? from}) {
    final duration = FinampSettingsHelper.finampSettings.audioFadeInDuration;
    _controller.duration = from != null ? duration * (1.0 - from) : duration;
    _controller.forward(from: from ?? 0.0);
  }

  void startFadeOut({double? from}) {
    final duration = FinampSettingsHelper.finampSettings.audioFadeOutDuration;
    _controller.duration = from != null ? duration * (1.0 - from) : duration;
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              border: _controller.status != AnimationStatus.dismissed &&
                      _controller.status != AnimationStatus.completed
                  ? ProgressBorder.all(
                      color: IconTheme.of(context).color!.withAlpha(128),
                      width: 4,
                      progress: _animation.value,
                    )
                  : null,
            ),
            child: widget.child);
      },
    );
  }
}
