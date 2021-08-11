import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

class ScreenState {
  final MediaItem? mediaItem;
  final PlaybackState playbackState;
  final Duration position;

  ScreenState(this.mediaItem, this.playbackState, this.position);
}

/// Encapsulate all the different data we're interested in into a single
/// stream so we don't have to nest StreamBuilders.

Stream<ScreenState> get screenStateStream =>
    Rx.combineLatest3<MediaItem?, PlaybackState, Duration, ScreenState>(
        AudioService.currentMediaItemStream,
        AudioService.playbackStateStream,
        AudioService.positionStream,
        (mediaItem, playbackState, position) =>
            ScreenState(mediaItem, playbackState, position));
