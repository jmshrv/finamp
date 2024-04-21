import 'package:finamp/models/finamp_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../models/jellyfin_models.dart';
import 'downloads_service.dart';
import 'finamp_settings_helper.dart';
import 'jellyfin_api_helper.dart';

final metadataProviderLogger = Logger("MetadataProvider");

class MetadataRequest {
  const MetadataRequest({
    required this.item,
    this.includeLyrics = false,
  }) : super();

  final BaseItemDto item;

  final bool includeLyrics;

  @override
  bool operator ==(Object other) {
    return other is MetadataRequest &&
        other.includeLyrics == includeLyrics &&
        other.item.id == item.id;
  }

  @override
  int get hashCode => Object.hash(item.id, includeLyrics);
}

class MetadataProvider {

  final BaseItemDto item;
  LyricDto? lyrics;

  MetadataProvider({
    required this.item,
    this.lyrics,
  });

  bool get hasLyrics => item.mediaStreams?.any((e) => e.type == "Lyric") ?? false;

}

final AutoDisposeFutureProviderFamily<MetadataProvider?, MetadataRequest>
    metadataProvider = FutureProvider.autoDispose.family<MetadataProvider?, MetadataRequest>((ref, request) async {

  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();

  metadataProviderLogger.fine("Fetching metadata for '${request.item.name}' (${request.item.id})");

  BaseItemDto? itemInfo;
  try {
    final downloadItem = await downloadsService.getSongInfo(id: request.item.id);
    if (downloadItem != null) {
      metadataProviderLogger.fine("Got offline metadata for '${request.item.name}'");
      itemInfo = downloadItem.baseItem!;
    }
  } catch (e) {
    metadataProviderLogger.warning("Couldn't get the offline metadata for track '${request.item.name}'");
  }

  // try to fetch from server if not found in downloads
  itemInfo ??= await jellyfinApiHelper.getItemById(request.item.id);

  LyricsItem? downloadedLyrics;
  try {
    downloadedLyrics = await downloadsService.getLyricsDownload(baseItem: request.item);
    if (downloadedLyrics != null) {
      metadataProviderLogger.fine("Got offline lyrics for '${request.item.name}'");
    }
    else {
      metadataProviderLogger.fine("No offline lyrics for '${request.item.name}'");
    }
  } catch (e) {
    metadataProviderLogger.warning("Couldn't get the offline lyrics for track '${request.item.name}'");
  }
  
  final metadata = MetadataProvider(item: itemInfo);

  if (request.includeLyrics) {
    if (downloadedLyrics != null) {
      metadata.lyrics = downloadedLyrics.lyricDto;
    }
    else if (
      metadata.hasLyrics && !FinampSettingsHelper.finampSettings.isOffline
    ) {
      metadataProviderLogger.fine("Fetching lyrics for '${request.item.name}' (${request.item.id})");
      final lyrics = await jellyfinApiHelper.getLyrics(
        itemId: itemInfo.id,
      );
      metadata.lyrics = lyrics;
    }
  }

  metadataProviderLogger.fine("Fetched metadata for '${request.item.name}' (${request.item.id}): ${metadata.lyrics} ${metadata.hasLyrics}");

  return metadata;

});
