import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'music_player_background_task.dart';

class MediaState {
  final MediaItem? mediaItem;
  final PlaybackState playbackState;
  final bool audioFading;

  MediaState(this.mediaItem, this.playbackState, this.audioFading);
}

/// A stream reporting the combined state of the current media item and its
/// current position.
Stream<MediaState> get mediaStateStream {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  return Rx.combineLatest3<MediaItem?, PlaybackState, bool, MediaState>(
      audioHandler.mediaItem,
      audioHandler.playbackState,
      audioHandler.fading,
      (mediaItem, playbackState, fading) =>
          MediaState(mediaItem, playbackState, fading));
}
