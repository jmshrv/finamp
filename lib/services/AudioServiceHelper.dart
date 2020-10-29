import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import 'JellyfinApiData.dart';
import '../models/JellyfinModels.dart';
import 'MusicPlayerBackgroundTask.dart';

/// Just some functions to make talking to AudioService a bit neater.
class AudioServiceHelper {
  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();

  /// Replaces the queue with the given list of items. If startAtIndex is specified, Any items below it
  /// will be ignored. This is used for when the user taps in the middle of an album to start from that point.
  Future<void> replaceQueueWithItem(
      {@required List<BaseItemDto> itemList, int startAtIndex = 0}) async {
    if (startAtIndex > itemList.length) {
      return Future.error(
          "startAtIndex is bigger than the itemList! ($startAtIndex > ${itemList.length})");
    }
    String baseUrl = await _jellyfinApiData.getBaseUrl();

    // List<MediaItem> queue =
    //     await Future.wait(itemList.map((BaseItemDto item) async {
    //   if (startAtIndex >= count) {
    //     count += 1;
    //     return MediaItem(
    //     id: item.id,
    //     album: item.album,
    //     artist: item.albumArtist,
    //     artUri: "$baseUrl/Items/${item.id}/Images/Primary?format=webp",
    //     title: item.name,
    //     duration: Duration(
    //       microseconds: (item.runTimeTicks ~/ 10),
    //     ),
    //   );
    //   }
    //   count += 1;
    // }));
    List<MediaItem> queue = [];
    for (int i = startAtIndex; i < itemList.length; i++) {
      // Adds itemList[i] to the queue in MediaItem form.
      // There's probably a neater way to do this for loop but it works ¯\_(ツ)_/¯
      queue.add(MediaItem(
        id: itemList[i].id,
        album: itemList[i].album,
        artist: itemList[i].albumArtist,
        artUri: "$baseUrl/Items/${itemList[i].id}/Images/Primary?format=webp",
        title: itemList[i].name,
        // Jellyfin returns microseconds * 10 for some reason
        duration: Duration(
          microseconds: (itemList[i].runTimeTicks ~/ 10),
        ),
      ));
    }
    if (!AudioService.running) {
      await startAudioService();
    }
    await AudioService.updateQueue(queue);
    await AudioService.play();
  }

  /// Starts the background audio service. I only wrote this function to keep
  /// _backgroundTaskEntrypoint in one place.
  Future<void> startAudioService() async {
    await AudioService.start(
        backgroundTaskEntrypoint: _backgroundTaskEntrypoint);
  }
}

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => MusicPlayerBackgroundTask());
}
