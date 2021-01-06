import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../printDuration.dart';
import '../../services/connectIfDisconnected.dart';
import '../../services/screenStateStream.dart';

class ProgressSlider extends StatefulWidget {
  const ProgressSlider({Key key}) : super(key: key);

  @override
  _ProgressSliderState createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  Timer timer;
  Duration currentPosition;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
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
            } else if (!playbackState.playing) {
            } else if (playbackState.processingState ==
                AudioProcessingState.buffering) {}
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TODO: This text varies in width on iOS, making the slider's length fluctuate
                Text(printDuration(
                  currentPosition,
                )),
                Expanded(
                  child: Slider(
                    value: currentPosition.inMicroseconds.toDouble(),
                    onChanged: (value) {
                      AudioService.seekTo(
                          Duration(microseconds: value.toInt()));
                    },
                    max: mediaItem.duration.inMicroseconds.toDouble(),
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
