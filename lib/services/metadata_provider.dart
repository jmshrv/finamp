import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/jellyfin_api.dart';
import 'package:flutter/material.dart';
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

  //TODO fetch from downloads once implemented
  
  final itemInfo = await jellyfinApiHelper.getItemById(request.item.id);

  final metadata = MetadataProvider(item: itemInfo);

  if (
    metadata.hasLyrics
    && request.includeLyrics
  ) {
    metadataProviderLogger.fine("Fetching lyrics for '${request.item.name}' (${request.item.id})");
    final lyrics = await jellyfinApiHelper.getLyrics(
      itemId: itemInfo.id,
    );
    metadata.lyrics = lyrics;
  }

  return metadata;

});
