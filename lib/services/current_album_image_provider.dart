import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'album_image_provider.dart';

/// Provider to handle syncing up the current playing item's image provider.
/// Used on the player screen to sync up loading the blurred background.
final currentAlbumImageProvider = Provider<(ImageProvider?, String?)>((ref) {
  final List<FinampQueueItem> precacheItems =
      GetIt.instance<QueueService>().peekQueue(next: 3, previous: 1);
  ImageStream? stream;
  ImageStreamListener? listener;
  // Set up onDispose function before crossing async boundary
  ref.onDispose(() {
    if (stream != null && listener != null) {
      stream.removeListener(listener);
    }
  });
  for (final itemToPrecache in precacheItems) {
    BaseItemDto? base = itemToPrecache.baseItem;
    if (base != null) {
      final request = AlbumImageRequest(item: base);
      var image = ref.read(albumImageProvider(request));
      if (image != null) {
        // Cache the returned image
        stream = image.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
        listener = ImageStreamListener((image, synchronousCall) {});
        stream.addListener(listener);
      }
    }
  }

  final currentTrack = ref.watch(currentSongProvider).value?.baseItem;
  if (currentTrack != null) {
    final request = AlbumImageRequest(
      item: currentTrack,
    );
    return (ref.read(albumImageProvider(request)), currentTrack.blurHash);
  }
  return (null, null);
});

final currentSongProvider = StreamProvider(
    (_) => GetIt.instance<QueueService>().getCurrentTrackStream());
