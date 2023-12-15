import 'dart:async';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'album_image_provider.dart';

/// Provider to handle syncing up the current playing item's image provider.
/// Used on the player screen to sync up loading the blurred background.
final currentAlbumImageProvider = FutureProvider<ImageProvider?>((ref) async {
  final List<FinampQueueItem> precacheItems =
      GetIt.instance<QueueService>().getNextXTracksInQueue(3, reverse: 1);
  for (final itemToPrecache in precacheItems) {
    BaseItemDto? base = itemToPrecache.baseItem;
    if (base != null) {
      final request = AlbumImageRequest(item: base);
      unawaited(ref.read(albumImageProvider(request).future).then((value) {
        if (value != null) {
          // Cache the returned image
          var stream =
              value.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
          var listener = ImageStreamListener((image, synchronousCall) {});
          ref.onDispose(() {
            stream.removeListener(listener);
          });
          stream.addListener(listener);
        }
      }));
    }
  }

  final currentTrack = ref.watch(currentSongProvider).value?.baseItem;
  if (currentTrack != null) {
    final request = AlbumImageRequest(
      item: currentTrack,
    );
    return ref.read(albumImageProvider(request).future);
  }
  return null;
});

final currentSongProvider = StreamProvider(
    (_) => GetIt.instance<QueueService>().getCurrentTrackStream());
