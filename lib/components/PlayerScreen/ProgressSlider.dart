import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../printDuration.dart';
import '../../services/connectIfDisconnected.dart';
import '../../services/screenStateStream.dart';
import '../../generateMaterialColor.dart';

class ProgressSlider extends StatefulWidget {
  const ProgressSlider({Key key}) : super(key: key);

  @override
  _ProgressSliderState createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  Timer timer;
  Duration currentPosition;

  /// Value used to hold the slider's value.
  /// Will become out of sync with the actual current position while seeking,
  /// which is why we hold it in a separate value instead of just using the current position.
  double sliderValue;

  bool isSeeking = false;

  SliderThemeData _sliderThemeData;

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
          PlaybackState playbackState = snapshot.data.playbackState;
          MediaItem mediaItem = snapshot.data.mediaItem;
          if (mediaItem != null && AudioService.connected) {
            if (playbackState.playing &&
                    playbackState.processingState !=
                        AudioProcessingState.buffering ||
                currentPosition == null) {
              // Update the current position if the player isn't playing/buffering or currentPosition is null (usually when the widget is first showed)
              currentPosition = playbackState.position +
                  Duration(
                      microseconds: (DateTime.now().microsecondsSinceEpoch -
                          playbackState.updateTime.microsecondsSinceEpoch));
            }

            if (!isSeeking) {
              // If we are not currently seeking, set the slider's value to the current position
              sliderValue = currentPosition.inMicroseconds.toDouble();
            }

            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TODO: This text varies in width on iOS, making the slider's length fluctuate
                // TODO: Use sliderValue instead of currentPosition so that this updates as the user seeks
                Text(printDuration(
                  Duration(microseconds: sliderValue.toInt()),
                )),
                Expanded(
                  child: Stack(
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
                        ),
                        child: ExcludeSemantics(
                          child: Slider(
                            min: 0.0,
                            max: mediaItem.duration.inMicroseconds.toDouble(),
                            value: playbackState.bufferedPosition.inMicroseconds
                                .toDouble(),
                            onChanged: (_) {},
                          ),
                        ),
                      ),
                      SliderTheme(
                        data: _sliderThemeData.copyWith(
                          inactiveTrackColor: Colors.transparent,
                        ),
                        child: Slider(
                          value: sliderValue,
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
                          max: mediaItem.duration.inMicroseconds.toDouble(),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(printDuration(
                  mediaItem.duration,
                )),
              ],
            );
          } else if (snapshot.data.mediaItem == null ||
              currentPosition == null ||
              !AudioService.connected) {
            // If nothing is playing or the AudioService isn't connected, return a greyed out slider with some fake numbers
            // We also do this if currentPosition is null, which sometimes happens when the app is closed and reopened
            // If we're not connected, we try to reconnect.
            connectIfDisconnected();
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("00:00"),
                Expanded(
                  child: Slider(
                    value: 0,
                    max: 1,
                    onChanged: null,
                  ),
                ),
                Text("00:00"),
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
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}
