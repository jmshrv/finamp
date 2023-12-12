import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../models/jellyfin_models.dart';
import 'album_image_provider.dart';

/// Provider to handle syncing up the current playing item's image provider.
/// Used on the player screen to sync up loading the blurred background.
final currentAlbumImageProvider = FutureProvider.autoDispose<ImageProvider?>((ref) async {
  final currentTrack = ref.watch(currentSongProvider.select((data) => data.value?.item));
  if (currentTrack != null) {
    final currentTrackBaseItem = currentTrack.extras?["itemJson"] != null
        ? BaseItemDto.fromJson(
            currentTrack.extras!["itemJson"] as Map<String, dynamic>)
        : null;
    if (currentTrackBaseItem != null) {
      final request = AlbumImageRequest(
        item: currentTrackBaseItem,
        maxWidth: 100,
        maxHeight: 100,
      );
      return ref.read(albumImageProvider(request).future);
    }
  }
  return null;
});

final currentSongProvider = StreamProvider(
    (_) => GetIt.instance<QueueService>().getCurrentTrackStream());
