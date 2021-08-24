import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../services/MusicPlayerBackgroundTask.dart';

class MediaState {
  final MediaItem? mediaItem;
  final PlaybackState playbackState;

  MediaState(this.mediaItem, this.playbackState);
}

/// A stream reporting the combined state of the current media item and its
/// current position.
Stream<MediaState> get mediaStateStream {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  return Rx.combineLatest2<MediaItem?, PlaybackState, MediaState>(
      audioHandler.mediaItem,
      audioHandler.playbackState,
      (mediaItem, playbackState) => MediaState(mediaItem, playbackState));
}
