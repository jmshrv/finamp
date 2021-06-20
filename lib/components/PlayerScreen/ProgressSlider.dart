import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../printDuration.dart';
import '../../services/connectIfDisconnected.dart';
import '../../services/screenStateStream.dart';
import '../../generateMaterialColor.dart';

class ProgressSlider extends StatefulWidget {
  const ProgressSlider({Key? key}) : super(key: key);

  @override
  _ProgressSliderState createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  late Timer timer;
  Duration? currentPosition;

  /// Value used to hold the slider's value.
  /// Will become out of sync with the actual current position while seeking,
  /// which is why we hold it in a separate value instead of just using the current position.
  double? sliderValue;

  bool isSeeking = false;

  late SliderThemeData _sliderThemeData;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ScreenState>(
      stream: screenStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          PlaybackState playbackState = snapshot.data!.playbackState;
          MediaItem? mediaItem = snapshot.data!.mediaItem;

          // If currentPosition is null, set it to the current playback position. This is usually when the widget is first shown.
          if (currentPosition == null) {
            currentPosition = playbackState.position;
          }

          if (mediaItem != null && AudioService.connected) {
            if (playbackState.playing &&
                playbackState.processingState !=
                    AudioProcessingState.buffering) {
              // Update the current position if the player isn't playing/buffering
              currentPosition = playbackState.position +
                  Duration(
                      microseconds: (DateTime.now().microsecondsSinceEpoch -
                          playbackState.updateTime.microsecondsSinceEpoch));
            }

            if (!isSeeking) {
              // If we are not currently seeking, set the slider's value to the current position
              if (currentPosition != null) {
                sliderValue = currentPosition!.inMicroseconds.toDouble();
              }
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    SliderTheme(
                      data: _sliderThemeData.copyWith(
                        thumbShape: HiddenThumbComponentShape(),
                        activeTrackColor: generateMaterialColor(
                                Theme.of(context).primaryColor)
                            .shade300,
                        inactiveTrackColor: generateMaterialColor(
                                Theme.of(context).primaryColor)
                            .shade500,
                        trackShape: CustomTrackShape(),
                      ),
                      child: ExcludeSemantics(
                        child: Slider(
                          min: 0.0,
                          max: mediaItem.duration == null
                              ? playbackState.bufferedPosition.inMicroseconds
                                  .toDouble()
                              : mediaItem.duration!.inMicroseconds.toDouble(),
                          value: playbackState.bufferedPosition.inMicroseconds
                              .clamp(
                                0.0,
                                mediaItem.duration == null
                                    ? playbackState
                                        .bufferedPosition.inMicroseconds
                                    : mediaItem.duration!.inMicroseconds,
                              )
                              .toDouble(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    SliderTheme(
                      data: _sliderThemeData.copyWith(
                        inactiveTrackColor: Colors.transparent,
                        trackShape: CustomTrackShape(),
                      ),
                      child: Slider(
                        min: 0.0,
                        max: mediaItem.duration == null
                            ? playbackState.bufferedPosition.inMicroseconds
                                .toDouble()
                            : mediaItem.duration!.inMicroseconds.toDouble(),
                        value: sliderValue == null
                            ? 0
                            : sliderValue!
                                .clamp(
                                  0.0,
                                  mediaItem.duration == null
                                      ? playbackState
                                          .bufferedPosition.inMicroseconds
                                      : mediaItem.duration!.inMicroseconds,
                                )
                                .toDouble(),
                        onChanged: (newValue) async {
                          // We don't actually tell audio_service to seek here because it would get flooded with seek requests
                          setState(() {
                            sliderValue = newValue;
                          });
                        },
                        onChangeStart: (_) {
                          setState(() {
                            isSeeking = true;
                          });
                          // Pause playback while the user is moving the slider
                          AudioService.pause();
                        },
                        onChangeEnd: (newValue) async {
                          // Seek to the new position
                          await AudioService.seekTo(
                              Duration(microseconds: newValue.toInt()));
                          // Start playback again once the user is done moving the slider
                          AudioService.play();

                          setState(() {
                            isSeeking = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      printDuration(
                        Duration(
                          microseconds:
                              sliderValue == null ? 0 : sliderValue!.toInt(),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Theme.of(context).textTheme.caption?.color),
                    ),
                    Text(
                      printDuration(mediaItem.duration),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Theme.of(context).textTheme.caption?.color),
                    ),
                  ],
                ),
              ],
            );
          } else if (snapshot.data!.mediaItem == null ||
              currentPosition == null ||
              !AudioService.connected) {
            // If nothing is playing or the AudioService isn't connected, return a greyed out slider with some fake numbers
            // We also do this if currentPosition is null, which sometimes happens when the app is closed and reopened
            // If we're not connected, we try to reconnect.
            connectIfDisconnected();
            return Column(
              children: [
                SliderTheme(
                  data: _sliderThemeData.copyWith(
                    trackShape: CustomTrackShape(),
                  ),
                  child: Slider(
                    value: 0,
                    max: 1,
                    onChanged: null,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "00:00",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Theme.of(context).textTheme.caption?.color),
                    ),
                    Text(
                      "00:00",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Theme.of(context).textTheme.caption?.color),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Text(
                "Snapshot has data and MediaItem or currentPosition aren't null and AudioService is connected?");
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}

/// Track shape used to remove horizontal padding.
/// https://github.com/flutter/flutter/issues/37057
class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
