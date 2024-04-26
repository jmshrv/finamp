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
  
  //!!! only use offline metadata if the app is in offline mode
  // Finamp should always use the server metadata when online, if possible
  if (FinampSettingsHelper.finampSettings.isOffline) {
    final downloadItem = await downloadsService.getSongInfo(id: request.item.id);
    if (downloadItem != null) {
      metadataProviderLogger.fine("Got offline metadata for '${request.item.name}'");
      itemInfo = downloadItem.baseItem!;
    }
  } else {
    final requiredAttributes = [request.item.mediaStreams];
    // fetch from server in online mode if needed attributes are missing
    if (requiredAttributes.any((e) => e == null)) {
      metadataProviderLogger.fine("Fetching metadata for '${request.item.name}' (${request.item.id}) from server due to missing attributes");
      try {
        itemInfo = await jellyfinApiHelper.getItemById(request.item.id);
      } catch (e) {
        metadataProviderLogger.severe("Failed to fetch metadata for '${request.item.name}' (${request.item.id})", e);
        if (itemInfo == null) {
          return null;
        } else {
          metadataProviderLogger.warning("Using downloaded metadata for '${request.item.name}' (${request.item.id})");
        }
      }
    }
  }

  if (itemInfo == null) {
    metadataProviderLogger.warning("Couldn't load metadata for '${request.item.name}' (${request.item.id})");
    return null;
  }

  final metadata = MetadataProvider(item: itemInfo);

  if (request.includeLyrics && metadata.hasLyrics) {

    //!!! only use offline metadata if the app is in offline mode
    // Finamp should always use the server metadata when online, if possible
    if (FinampSettingsHelper.finampSettings.isOffline) {
      DownloadedLyrics? downloadedLyrics;
        downloadedLyrics = await downloadsService.getLyricsDownload(baseItem: request.item);
        if (downloadedLyrics != null) {
          metadata.lyrics = downloadedLyrics.lyricDto;
          metadataProviderLogger.fine("Got offline lyrics for '${request.item.name}'");
        }
        else {
          metadataProviderLogger.fine("No offline lyrics for '${request.item.name}'");
        }
    } else {
      metadataProviderLogger.fine("Fetching lyrics for '${request.item.name}' (${request.item.id})");
      try {
        final lyrics = await jellyfinApiHelper.getLyrics(
          itemId: itemInfo.id,
        );
        metadata.lyrics = lyrics;
      } catch (e) {
        metadataProviderLogger.warning("Failed to fetch lyrics for '${request.item.name}' (${request.item.id}). Metadata might be stale", e);
      }
    }
  }

  metadataProviderLogger.fine("Fetched metadata for '${request.item.name}' (${request.item.id}): ${metadata.lyrics} ${metadata.hasLyrics}");

  return metadata;

});
