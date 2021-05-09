import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'JellyfinApiData.dart';
import '../models/JellyfinModels.dart';
import 'MusicPlayerBackgroundTask.dart';
import '../services/FinampSettingsHelper.dart';

/// Just some functions to make talking to AudioService a bit neater.
class AudioServiceHelper {
  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();
  final audioServiceHelperLogger = Logger("AudioServiceHelper");

  /// Replaces the queue with the given list of items. If startAtIndex is specified, Any items below it
  /// will be ignored. This is used for when the user taps in the middle of an album to start from that point.
  Future<void> replaceQueueWithItem(
      {@required List<BaseItemDto> itemList,
      int startAtIndex = 0,
      bool shuffle = false}) async {
    try {
      if (startAtIndex > itemList.length) {
        return Future.error(
            "startAtIndex is bigger than the itemList! ($startAtIndex > ${itemList.length})");
      }
      List<MediaItem> queue = [];
      for (int i = startAtIndex; i < itemList.length; i++) {
        // Adds itemList[i] to the queue in MediaItem form.
        // There's probably a neater way to do this for loop but it works ¯\_(ツ)_/¯
        queue.add(
          MediaItem(
            id: itemList[i].id,
            album: itemList[i].album,
            artist: itemList[i].albumArtist,
            artUri: FinampSettingsHelper.finampSettings.isOffline
                ? null
                : "${_jellyfinApiData.currentUser.baseUrl}/Items/${itemList[i].parentId}/Images/Primary?format=jpg",
            title: itemList[i].name,
            extras: {"parentId": itemList[i].parentId},
            // Jellyfin returns microseconds * 10 for some reason
            duration: Duration(
              microseconds: (itemList[i].runTimeTicks ~/ 10),
            ),
          ),
        );
      }
      if (!AudioService.running) {
        await startAudioService();
      }
      if (shuffle) {
        await AudioService.setShuffleMode(AudioServiceShuffleMode.all);
      } else {
        await AudioService.setShuffleMode(AudioServiceShuffleMode.none);
      }
      await AudioService.updateQueue(queue);
      _jellyfinApiData
          .reportPlaybackStart(PlaybackProgressInfo(itemId: queue[0].id));
      await AudioService.play();
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  /// Starts the background audio service. I only wrote this function to keep
  /// _backgroundTaskEntrypoint in one place.
  Future<void> startAudioService() async {
    try {
      await AudioService.start(
        backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
        androidStopForegroundOnPause:
            FinampSettingsHelper.finampSettings.androidStopForegroundOnPause,
        androidEnableQueue: true,
        androidNotificationChannelName: "Playback",
      );
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }
}

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => MusicPlayerBackgroundTask());
}
