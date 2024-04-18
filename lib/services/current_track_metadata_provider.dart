import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'metadata_provider.dart';

/// Provider to handle pre-fetching metadata for upcoming tracks
final currentTrackMetadataProvider =
    FutureProvider<MetadataProvider?>((ref) async {
  final List<FinampQueueItem> precacheItems =
      GetIt.instance<QueueService>().peekQueue(next: 3, previous: 1);
  // ImageStream? stream;
  // ImageStreamListener? listener;
  // Set up onDispose function before crossing async boundary
  ref.onDispose(() {
    // if (stream != null && listener != null) {
    //   stream?.removeListener(listener!);
    // }
  });
  for (final itemToPrecache in precacheItems) {
    BaseItemDto? base = itemToPrecache.baseItem;
    if (base != null) {
      final request = MetadataRequest(item: base, includeLyrics: true);
      ref.listen(metadataProvider(request).future, (valueOrNull, value) {
        if (valueOrNull != null) {
          // Cache the returned image
          // stream =
          //     value.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
          // listener = ImageStreamListener((image, synchronousCall) {});
          // stream!.addListener(listener!);
        }
      });
    }
  }

  final currentTrack = ref.watch(currentSongProvider).value?.baseItem;
  if (currentTrack != null) {
    final request = MetadataRequest(
      item: currentTrack,
      includeLyrics: true,
    );
    return ref.watch(metadataProvider(request).future);
  }
  return null;
});

final currentSongProvider = StreamProvider(
    (_) => GetIt.instance<QueueService>().getCurrentTrackStream());
