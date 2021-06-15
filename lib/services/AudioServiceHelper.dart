import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

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
  Future<void> replaceQueueWithItem({
    required List<BaseItemDto> itemList,
    int initialIndex = 0,
    bool shuffle = false,
  }) async {
    try {
      if (initialIndex > itemList.length) {
        return Future.error(
            "startAtIndex is bigger than the itemList! ($initialIndex > ${itemList.length})");
      }
      final uuid = Uuid();

      List<MediaItem> queue = itemList
          .map((e) => MediaItem(
                id: uuid.v4(),
                album: e.album ?? "Unknown Album",
                artist: e.albumArtist,
                artUri: FinampSettingsHelper.finampSettings.isOffline
                    ? null
                    : Uri.parse(
                        "${_jellyfinApiData.currentUser!.baseUrl}/Items/${e.parentId}/Images/Primary?format=jpg"),
                title: e.name ?? "Unknown Name",
                extras: {
                  "parentId": e.parentId,
                  "itemId": e.id,
                },
                // Jellyfin returns microseconds * 10 for some reason
                duration: Duration(
                  microseconds:
                      (e.runTimeTicks == null ? 0 : e.runTimeTicks! ~/ 10),
                ),
              ))
          .toList();

      if (!AudioService.running) {
        await startAudioService();
      }
      if (shuffle) {
        await AudioService.setShuffleMode(AudioServiceShuffleMode.all);
      } else {
        await AudioService.setShuffleMode(AudioServiceShuffleMode.none);
      }

      // Give the audio service our next initial index so that playback starts
      // at that index.
      await AudioService.customAction("setNextInitialIndex", initialIndex);

      await AudioService.updateQueue(queue);
      // TODO: Same as progress info update on MusicPlayerBackgroundTask
      // _jellyfinApiData.reportPlaybackStart(
      //     await AudioService.customAction("generatePlaybackProgressInfo"));
      AudioService.play();
    } catch (e) {
      audioServiceHelperLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> addQueueItem(BaseItemDto item) async {
    try {
      final uuid = Uuid();

      final itemMediaItem = MediaItem(
        id: uuid.v4(),
        album: item.album ?? "Unknown Album",
        artist: item.albumArtist,
        artUri: FinampSettingsHelper.finampSettings.isOffline
            ? null
            : Uri.parse(
                "${_jellyfinApiData.currentUser!.baseUrl}/Items/${item.parentId}/Images/Primary?format=jpg"),
        title: item.name ?? "Unknown Name",
        extras: {
          "parentId": item.parentId,
          "itemId": item.id,
        },
        // Jellyfin returns microseconds * 10 for some reason
        duration: Duration(
          microseconds:
              (item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10),
        ),
      );

      bool wasRunning = true;

      if (!AudioService.running) {
        wasRunning = false;
        await startAudioService();
      }

      if (wasRunning) {
        await AudioService.addQueueItem(itemMediaItem);
      } else {
        await AudioService.updateQueue([itemMediaItem]);
        AudioService.play();
      }
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
