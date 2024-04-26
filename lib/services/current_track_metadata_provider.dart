import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'metadata_provider.dart';

KeepAliveLink? metadataKeepAliveLink; // this can be used to reset the provider

/// Provider to handle pre-fetching metadata for upcoming tracks
final currentTrackMetadataProvider =
    AutoDisposeFutureProvider<MetadataProvider?>((ref) async {
  final List<FinampQueueItem> precacheItems =
      GetIt.instance<QueueService>().peekQueue(next: 3, previous: 1);
  for (final itemToPrecache in precacheItems) {
    BaseItemDto? base = itemToPrecache.baseItem;
    if (base != null) {
      // only fetch lyrics for the current track
      final request = MetadataRequest(item: base, includeLyrics: true);
      unawaited(ref.watch(metadataProvider(request).future));
    }
  }

  final currentTrack = ref.watch(currentSongProvider).value?.baseItem;
  if (currentTrack != null) {
    final request = MetadataRequest(
      item: currentTrack,
      includeLyrics: true,
    );
    metadataKeepAliveLink = ref.keepAlive();
    return ref.watch(metadataProvider(request).future);
  }
  return null;
});

final currentSongProvider = StreamProvider(
    (_) => GetIt.instance<QueueService>().getCurrentTrackStream());
