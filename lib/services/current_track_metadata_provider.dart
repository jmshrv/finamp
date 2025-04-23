import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'metadata_provider.dart';

/// Provider to handle pre-fetching metadata for upcoming tracks
final currentTrackMetadataProvider =
    AutoDisposeProvider<AsyncValue<MetadataProvider?>>((ref) {
  final List<FinampQueueItem> precacheItems =
      GetIt.instance<QueueService>().peekQueue(next: 3, previous: 1);
  for (final itemToPrecache in precacheItems) {
    BaseItemDto? base = itemToPrecache.baseItem;
    if (base != null) {
      // only fetch lyrics for the current track
      final request = MetadataRequest(
          item: base,
          queueItem: itemToPrecache,
          includeLyrics: true,
          checkIfSpeedControlNeeded:
              ref.watch(finampSettingsProvider.playbackSpeedVisibility) ==
                  PlaybackSpeedVisibility.automatic);
      ref.listen(metadataProvider(request), (_, __) {});
    }
  }

  final currentTrack = ref.watch(currentTrackProvider).value;
  if (currentTrack?.baseItem != null) {
    final request = MetadataRequest(
      item: currentTrack!.baseItem!,
      queueItem: currentTrack,
      includeLyrics: true,
      checkIfSpeedControlNeeded:
          ref.watch(finampSettingsProvider.playbackSpeedVisibility) ==
              PlaybackSpeedVisibility.automatic,
    );
    return ref.watch(metadataProvider(request));
  }
  return const AsyncValue.data(null);
});

final currentTrackProvider = StreamProvider(
    (_) => GetIt.instance<QueueService>().getCurrentTrackStream());
