import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:finamp/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'album_image_provider.dart';

/// Provider to handle syncing up the current playing item's image provider.
/// Used on the player screen to sync up loading the blurred background.
/// Use ListenableImage as output to allow directly overriding localImageProvider
final currentAlbumImageProvider = Provider<ListenableImage>((ref) {
  final List<FinampQueueItem> precacheItems =
      GetIt.instance<QueueService>().peekQueue(next: 3, previous: 1);
  for (final itemToPrecache in precacheItems) {
    BaseItemDto? base = itemToPrecache.baseItem;
    if (base != null) {
      final request = AlbumImageRequest(item: base);
      var image = ref.watch(albumImageProvider(request));
      if (image != null) {
        // Cache the returned image
        var stream =
            image.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
        var listener = ImageStreamListener((image, synchronousCall) {});
        ref.onDispose(() {
          stream.removeListener(listener);
        });
        stream.addListener(listener);
      }
    }
  }

  final currentTrack = ref.watch(currentTrackProvider).value?.baseItem;
  if (currentTrack != null) {
    final request = AlbumImageRequest(
      item: currentTrack,
    );
    return (
      ref.watch(albumImageProvider(request)),
      currentTrack.blurHash,
      true
    );
  }
  return (null, null, true);
});

final currentTrackProvider = StreamProvider(
    (_) => GetIt.instance<QueueService>().getCurrentTrackStream());
