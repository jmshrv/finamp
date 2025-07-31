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
  const MetadataRequest({required this.item, this.includeLyrics = false}) : super();

  final BaseItemDto item;

  final bool includeLyrics;

  @override
  bool operator ==(Object other) {
    return other is MetadataRequest && other.includeLyrics == includeLyrics && other.item.id == item.id;
  }

  @override
  int get hashCode => Object.hash(item.id, includeLyrics);
}

/// A storage container for metadata about a track.  The codec information will reflect
/// the downloaded file if appropriate, even for transcoded downloads.  Online
/// transcoding will not be reflected.
class MetadataProvider {
  static const speedControlGenres = ["audiobook", "podcast", "speech"];
  static const speedControlLongTrackDuration = Duration(minutes: 15);
  static const speedControlLongAlbumDuration = Duration(hours: 3);

  final MediaSourceInfo mediaSourceInfo;
  LyricDto? lyrics;
  bool isDownloaded;
  bool qualifiesForPlaybackSpeedControl;
  double? parentNormalizationGain;

  MetadataProvider({
    required this.mediaSourceInfo,
    this.lyrics,
    this.isDownloaded = false,
    this.qualifiesForPlaybackSpeedControl = false,
    this.parentNormalizationGain,
  });

  bool get hasLyrics => mediaSourceInfo.mediaStreams.any((e) => e.type == "Lyric");
}

final AutoDisposeFutureProviderFamily<MetadataProvider?, MetadataRequest> metadataProvider = FutureProvider.autoDispose
    .family<MetadataProvider?, MetadataRequest>((ref, request) async {
      // watch settings to trigger re-fetching metadata when offline mode changes
      ref.watch(finampSettingsProvider.isOffline);

      Future<BaseItemDto?>? parentFuture;
      if (request.item.parentId != null) {
        parentFuture = ref.watch(albumProvider(request.item.parentId!).future);
      }

      final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
      final downloadsService = GetIt.instance<DownloadsService>();

      metadataProviderLogger.fine("Fetching metadata for '${request.item.name}' (${request.item.id})");

      MediaSourceInfo? playbackInfo;
      MediaSourceInfo? localPlaybackInfo;

      final downloadStub = await downloadsService.getTrackInfo(id: request.item.id);
      if (downloadStub != null) {
        final downloadItem = await ref.watch(downloadsService.itemProvider(downloadStub).future);
        if (downloadItem != null && downloadItem.state.isComplete) {
          metadataProviderLogger.fine("Got offline metadata for '${request.item.name}'");
          var profile = downloadItem.fileTranscodingProfile;
          // We could explicitly get a mediaSource of type Default, but just grabbing
          // the first seems to generally work?
          var codec = profile?.codec != FinampTranscodingCodec.original
              ? profile?.codec.name
              : downloadItem.baseItem!.mediaSources?.first.container;
          var bitrate = profile?.codec != FinampTranscodingCodec.original
              ? profile?.stereoBitrate
              : downloadItem.baseItem!.mediaSources?.first.bitrate;

          // We cannot create accurate MediaStreams for a transcoded item,so
          // just return the lyrics stream, as those are not affected and will not
          // be shown if the mediaStream is not present
          List<MediaStream> mediaStream = profile?.codec != FinampTranscodingCodec.original
              ? downloadItem.baseItem!.mediaStreams?.where((x) => x.type == "Lyric").toList() ?? []
              : downloadItem.baseItem!.mediaStreams ?? [];

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
            mediaStreams: mediaStream,
            readAtNativeFramerate: false,
            ignoreDts: false,
            ignoreIndex: false,
            genPtsInput: false,
            bitrate: bitrate,
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
        metadataProviderLogger.fine(
          "Fetching metadata for '${request.item.name}' (${request.item.id}) from server due to missing attributes",
        );
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
          // Use lyrics mediastream from online item, but take all other streams
          // from downloaded item
          playbackInfo.mediaStreams = playbackInfo.mediaStreams.where((x) => x.type == "Lyric").toList();
          playbackInfo.mediaStreams.addAll(localPlaybackInfo.mediaStreams.where((x) => x.type != "Lyric"));
          playbackInfo.container = localPlaybackInfo.container;
          playbackInfo.size = localPlaybackInfo.size;
        }
      }

      if (playbackInfo == null) {
        metadataProviderLogger.warning("Couldn't load metadata for '${request.item.name}' (${request.item.id})");
        return null;
      }

      BaseItemDto? parent;
      if (parentFuture != null) {
        parent = await parentFuture;
      }

      final metadata = MetadataProvider(
        mediaSourceInfo: playbackInfo,
        isDownloaded: localPlaybackInfo != null,
        parentNormalizationGain: parent?.normalizationGain,
      );

      for (final genre in request.item.genres ?? []) {
        if (MetadataProvider.speedControlGenres.contains(genre.toLowerCase())) {
          metadata.qualifiesForPlaybackSpeedControl = true;
          break;
        }
      }
      if (!metadata.qualifiesForPlaybackSpeedControl &&
          (metadata.mediaSourceInfo.runTimeTicks ?? 0) >
              MetadataProvider.speedControlLongTrackDuration.inMicroseconds * 10) {
        // we might want playback speed control for long tracks (like podcasts or audiobook chapters)
        metadata.qualifiesForPlaybackSpeedControl = true;
      }

      // check if item qualifies for having playback speed control available
      if (!metadata.qualifiesForPlaybackSpeedControl &&
          parent != null &&
          (parent.runTimeTicks ?? 0) > MetadataProvider.speedControlLongAlbumDuration.inMicroseconds * 10) {
        metadata.qualifiesForPlaybackSpeedControl = true;
      }

      if (request.includeLyrics && metadata.hasLyrics) {
        //!!! only use offline metadata if the app is in offline mode
        // Finamp should always use the server metadata when online, if possible
        if (FinampSettingsHelper.finampSettings.isOffline) {
          DownloadedLyrics? downloadedLyrics;
          downloadedLyrics = await downloadsService.getLyricsDownload(baseItem: request.item);
          if (downloadedLyrics != null) {
            metadata.lyrics = downloadedLyrics.lyricDto;
            metadataProviderLogger.fine("Got offline lyrics for '${request.item.name}'");
          } else {
            metadataProviderLogger.fine("No offline lyrics for '${request.item.name}'");
          }
        } else {
          metadataProviderLogger.fine("Fetching lyrics for '${request.item.name}' (${request.item.id})");
          try {
            final lyrics = await jellyfinApiHelper.getLyrics(itemId: request.item.id);
            metadata.lyrics = lyrics;
          } catch (e) {
            metadataProviderLogger.warning(
              "Failed to fetch lyrics for '${request.item.name}' (${request.item.id}). Metadata might be stale",
              e,
            );
          }
        }
      }

      metadataProviderLogger.fine(
        "Fetched metadata for '${request.item.name}' (${request.item.id}): ${metadata.lyrics} ${metadata.hasLyrics}",
      );

      return metadata;
    });

final AutoDisposeFutureProviderFamily<BaseItemDto?, BaseItemId> albumProvider = FutureProvider.autoDispose
    .family<BaseItemDto?, BaseItemId>((ref, parentId) async {
      final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
      final downloadsService = GetIt.instance<DownloadsService>();

      if (ref.watch(finampSettingsProvider.isOffline)) {
        final parentInfo = await downloadsService.getCollectionInfo(id: parentId);
        if (parentInfo == null) {
          metadataProviderLogger.warning("Couldn't find parent collection '$parentId' in offline mode");
        } else if (parentInfo.baseItem == null) {
          metadataProviderLogger.warning("Offline metadata for '$parentId' does not include jellyfin BaseItemDto");
        } else {
          return parentInfo.baseItem;
        }
      } else {
        try {
          return await jellyfinApiHelper.getItemById(parentId);
        } catch (e) {
          metadataProviderLogger.warning("Failed to get parent item '$parentId'", e);
        }
      }
      return null;
    });
