import 'dart:async';

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

  final MediaSourceInfo mediaSourceInfo;
  LyricDto? lyrics;
  bool isDownloaded;

  MetadataProvider({
    required this.mediaSourceInfo,
    this.lyrics,
    this.isDownloaded = false,
  });

  bool get hasLyrics => mediaSourceInfo.mediaStreams.any((e) => e.type == "Lyric");

}

final AutoDisposeFutureProviderFamily<MetadataProvider?, MetadataRequest>
    metadataProvider = FutureProvider.autoDispose.family<MetadataProvider?, MetadataRequest>((ref, request) async {

  unawaited(ref.watch(FinampSettingsHelper.finampSettingsProvider.selectAsync((settings) => settings?.isOffline))); // watch settings to trigger re-fetching metadata when offline mode changes

  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();

  metadataProviderLogger.fine("Fetching metadata for '${request.item.name}' (${request.item.id})");

  MediaSourceInfo? playbackInfo;
  MediaSourceInfo? localPlaybackInfo;
  
  final downloadStub = await downloadsService.getSongInfo(id: request.item.id);
  if (downloadStub != null) {
    final downloadItem = await ref.watch(downloadsService.itemProvider(downloadStub).future);
    if (downloadItem != null && downloadItem.state == DownloadItemState.complete) {
      metadataProviderLogger.fine("Got offline metadata for '${request.item.name}'");
      var profile = downloadItem.fileTranscodingProfile;
      var codec = profile?.codec.name ?? FinampTranscodingCodec.original.name;
      localPlaybackInfo = MediaSourceInfo(
        id: downloadItem.baseItem!.id,
        protocol: "File",
        type: "Default",
        isRemote: false,
        supportsTranscoding: false,
        supportsDirectStream: false,
        supportsDirectPlay: true,
        isInfiniteStream: false,
        requiresOpening: false,
        requiresClosing: false,
        requiresLooping: false,
        supportsProbing: false,
        mediaStreams: downloadItem.baseItem!.mediaStreams ?? [],
        readAtNativeFramerate: false,
        ignoreDts: false,
        ignoreIndex: false,
        genPtsInput: false,
        bitrate: profile?.stereoBitrate,
        container: codec,
        name: downloadItem.baseItem!.mediaSources?.first.name,
        size: await downloadsService.getFileSize(downloadStub),
      );
    }
  }
  
  //!!! only use offline metadata if the app is in offline mode
  // Finamp should always use the server metadata when online, if possible
  if (FinampSettingsHelper.finampSettings.isOffline) {
    playbackInfo = localPlaybackInfo;
  } else {
    // fetch from server in online mode
    metadataProviderLogger.fine("Fetching metadata for '${request.item.name}' (${request.item.id}) from server due to missing attributes");
    try {
      playbackInfo = (await jellyfinApiHelper.getPlaybackInfo(request.item.id))?.first;
    } catch (e) {
      metadataProviderLogger.severe("Failed to fetch metadata for '${request.item.name}' (${request.item.id})", e);
      return null;
    }

    // update **PARTS** of playbackInfo with localPlaybackInfo if available
    if (localPlaybackInfo != null && playbackInfo != null) {
      playbackInfo.protocol = localPlaybackInfo.protocol;
      playbackInfo.bitrate = localPlaybackInfo.bitrate;
      playbackInfo.container = localPlaybackInfo.container;
      playbackInfo.size = localPlaybackInfo.size;
    }
  }

  if (playbackInfo == null) {
    metadataProviderLogger.warning("Couldn't load metadata for '${request.item.name}' (${request.item.id})");
    return null;
  }

  final metadata = MetadataProvider(mediaSourceInfo: playbackInfo, isDownloaded: localPlaybackInfo != null);

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
          itemId: request.item.id,
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
