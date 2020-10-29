import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

class ScreenState {
  final MediaItem mediaItem;
  final PlaybackState playbackState;

  ScreenState(this.mediaItem, this.playbackState);
}

/// Encapsulate all the different data we're interested in into a single
/// stream so we don't have to nest StreamBuilders.

Stream<ScreenState> get screenStateStream =>
    Rx.combineLatest2<MediaItem, PlaybackState, ScreenState>(
        AudioService.currentMediaItemStream,
        AudioService.playbackStateStream,
        (mediaItem, playbackState) => ScreenState(mediaItem, playbackState));
