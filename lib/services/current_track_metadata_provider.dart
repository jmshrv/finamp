import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'metadata_provider.dart';

/// Provider to handle pre-fetching metadata for upcoming tracks
final currentTrackMetadataProvider = AutoDisposeProvider<AsyncValue<MetadataProvider?>>((ref) {
  final List<FinampQueueItem> precacheItems = GetIt.instance<QueueService>().peekQueue(next: 3, previous: 1);
  for (final itemToPrecache in precacheItems) {
    BaseItemDto? base = itemToPrecache.baseItem;
    if (base != null) {
      ref.listen(metadataProvider(base), (_, __) {});
    }
  }

  final currentTrack = ref.watch(currentTrackProvider).value;
  if (currentTrack?.baseItem != null) {
    return ref.watch(metadataProvider(currentTrack!.baseItem!));
  }
  return const AsyncValue.data(null);
});

final currentTrackProvider = StreamProvider((_) => GetIt.instance<QueueService>().getCurrentTrackStream());
