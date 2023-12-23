import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/print_duration.dart';
import 'package:finamp/services/progress_state_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';

typedef DragCallback = void Function(double? value);

class ProgressSlider extends StatefulWidget {
  const ProgressSlider({
    Key? key,
    this.allowSeeking = true,
    this.showBuffer = true,
    this.showDuration = true,
    this.showPlaceholder = true,
  }) : super(key: key);

  final bool allowSeeking;
  final bool showBuffer;
  final bool showDuration;
  final bool showPlaceholder;

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  /// Value used to hold the slider's value when dragging.
  double? _dragValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // The slider always needs to be LTR, so we use Directionality to save
    // putting TextDirection.ltr all over the place
    return Directionality(
      textDirection: TextDirection.ltr,
      // The slider can refresh up to 60 times per second, so we wrap it in a
      // RepaintBoundary to avoid more areas being repainted than necessary
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 4.0,
          trackShape: CustomTrackShape(),
        ),
        child: StreamBuilder<ProgressState>(
          stream: progressStateStream,
          builder: (context, snapshot) {
            if (snapshot.data?.mediaItem == null) {
              // If nothing is playing or the AudioService isn't connected, return a
              // greyed out slider with some fake numbers. We also do this if
              // currentPosition is null, which sometimes happens when the app is
              // closed and reopened.
              return widget.showPlaceholder
                  ? Column(
                      children: [
                        const Slider(
                          value: 0,
                          max: 1,
                          onChanged: null,
                        ),
                        if (widget.showDuration)
                          const _ProgressSliderDuration(
                            position: Duration(),
                          )
                      ],
                    )
                  : const SizedBox.shrink();
            } else if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      // Slider displaying buffer status.
                      if (widget.showBuffer)
                        _BufferSlider(
                          mediaItem: snapshot.data?.mediaItem,
                          playbackState: snapshot.data!.playbackState,
                        ),
                      // Slider displaying playback progress.
                      _PlaybackProgressSlider(
                        allowSeeking: widget.allowSeeking,
                        playbackState: snapshot.data!.playbackState,
                        position: snapshot.data!.position,
                        mediaItem: snapshot.data!.mediaItem,
                        onDrag: (value) => setState(() {
                          _dragValue = value;
                        }),
                      ),
                    ],
                  ),
                  if (widget.showDuration)
                    _ProgressSliderDuration(
                      position: _dragValue == null
                          ? snapshot.data!.position
                          : Duration(microseconds: _dragValue!.toInt()),
                      itemDuration: snapshot.data!.mediaItem?.duration,
                    ),
                ],
              );
            } else {
              return const Text(
                  "Snapshot doesn't have data and MediaItem isn't null and AudioService is connected?");
            }
          },
        ),
      ),
    );
  }
}

class _BufferSlider extends StatelessWidget {
  const _BufferSlider({
    Key? key,
    this.mediaItem,
    required this.playbackState,
  }) : super(key: key);

  final MediaItem? mediaItem;
  final PlaybackState playbackState;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      // Why doesn't this inherit 💀
      data: SliderTheme.of(context).copyWith(
        thumbShape: HiddenThumbComponentShape(),
        trackShape: BufferTrackShape(),
        trackHeight: 4.0,
        inactiveTrackColor: IconTheme.of(context).color!.withOpacity(0.35),
        // thumbColor: Colors.white,
        // overlayColor: Colors.white,
        activeTrackColor: IconTheme.of(context).color!.withOpacity(0.6),
        // disabledThumbColor: Colors.white,
        // activeTickMarkColor: Colors.white,
        // valueIndicatorColor: Colors.white,
        // inactiveTickMarkColor: Colors.white,
        // disabledActiveTrackColor: Colors.white,
      ),
      child: ExcludeSemantics(
        child: Slider(
          min: 0.0,
          max: mediaItem?.duration == null
              ? playbackState.bufferedPosition.inMicroseconds.toDouble()
              : mediaItem!.duration!.inMicroseconds.toDouble(),
          // We do this check to not show buffer status on
          // downloaded songs.
          value: mediaItem?.extras?["downloadedSongJson"] == null
              ? playbackState.bufferedPosition.inMicroseconds
                  .clamp(
                    0.0,
                    mediaItem!.duration == null
                        ? playbackState.bufferedPosition.inMicroseconds
                        : mediaItem!.duration!.inMicroseconds,
                  )
                  .toDouble()
              : 0,
          onChanged: (_) {},
        ),
      ),
    );
  }
}

class _ProgressSliderDuration extends StatelessWidget {
  const _ProgressSliderDuration({
    Key? key,
    required this.position,
    this.itemDuration,
  }) : super(key: key);

  final Duration position;
  final Duration? itemDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          printDuration(
            Duration(microseconds: position.inMicroseconds),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
                height: 0.5, // reduce line height
              ),
        ),
        Text(
          printDuration(itemDuration),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
                height: 0.5, // reduce line height
              ),
        ),
      ],
    );
  }
}

class _PlaybackProgressSlider extends ConsumerStatefulWidget {
  const _PlaybackProgressSlider({
    Key? key,
    required this.allowSeeking,
    this.mediaItem,
    required this.playbackState,
    required this.position,
    required this.onDrag,
  }) : super(key: key);

  final bool allowSeeking;
  final MediaItem? mediaItem;
  final PlaybackState playbackState;
  final Duration position;
  final DragCallback onDrag; // should probably be nullable but its never null

  @override
  ConsumerState<_PlaybackProgressSlider> createState() =>
      __PlaybackProgressSliderState();
}

class __PlaybackProgressSliderState
    extends ConsumerState<_PlaybackProgressSlider> {
  /// Value used to hold the slider's value when dragging.
  double? _dragValue;

  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: widget.allowSeeking
          // ? _sliderThemeData.copyWith(
          ? SliderTheme.of(context).copyWith(
              inactiveTrackColor: Colors.transparent,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            )
          // )
          // : _sliderThemeData.copyWith(
          : SliderTheme.of(context).copyWith(
              inactiveTrackColor: Colors.transparent,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.1),
              // gets rid of both horizontal and vertical padding
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.1),
              trackShape: const RectangularSliderTrackShape(),
              // rectangular shape is thinner than round
              trackHeight: 4.0,
            ),
      // ),
      child: Slider(
        min: 0.0,
        max: widget.mediaItem?.duration == null
            ? widget.playbackState.bufferedPosition.inMicroseconds.toDouble()
            : widget.mediaItem!.duration!.inMicroseconds.toDouble(),
        value: (_dragValue ?? widget.position.inMicroseconds)
            .clamp(0, widget.mediaItem!.duration!.inMicroseconds.toDouble())
            .toDouble(),
        onChanged: widget.allowSeeking
            ? (newValue) async {
                // We don't actually tell audio_service to seek here
                // because it would get flooded with seek requests
                setState(() {
                  _dragValue = newValue;
                });
                widget.onDrag(newValue);
              }
            : (_) {},
        onChangeStart: widget.allowSeeking
            ? (value) {
                setState(() {
                  _dragValue = value;
                });
                widget.onDrag(value);
              }
            : (_) {},
        onChangeEnd: widget.allowSeeking
            ? (newValue) async {
                // Seek to the new position
                await _audioHandler
                    .seek(Duration(microseconds: newValue.toInt()));

                // Clear drag value so that the slider uses the play
                // duration again.
                setState(() {
                  _dragValue = null;
                });
                widget.onDrag(null);
              }
            : (_) {},
      ),
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

/// Track shape used to remove horizontal padding.
/// https://github.com/flutter/flutter/issues/37057
class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
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

/// https://stackoverflow.com/a/68481487/8532605
class BufferTrackShape extends CustomTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: 0,
    );
  }
}
