import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../models/jellyfin_models.dart';
import 'downloads_service.dart';
import 'finamp_settings_helper.dart';
import 'jellyfin_api_helper.dart';

final albumImageProviderLogger = Logger("AlbumImageProvider");

class AlbumImageRequest {
  const AlbumImageRequest({
    required this.item,
    this.maxWidth,
    this.maxHeight,
  }) : super();

  final BaseItemDto item;

  final int? maxWidth;

  final int? maxHeight;

  @override
  bool operator ==(Object other) {
    return other is AlbumImageRequest &&
        other.maxHeight == maxHeight &&
        other.maxWidth == maxWidth &&
        other.item.id == item.id;
  }

  @override
  int get hashCode => Object.hash(item.id, maxHeight, maxWidth);
}

final AutoDisposeFutureProviderFamily<ImageProvider?, AlbumImageRequest>
    albumImageProvider = FutureProvider.autoDispose
        .family<ImageProvider?, AlbumImageRequest>((ref, request) async {
  if (request.item.imageId == null) {
    return null;
  }

  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final isardownloader = GetIt.instance<DownloadsService>();

  DownloadItem? downloadedImage;
  try {
    downloadedImage = await isardownloader.getImageDownload(item: request.item);
  } catch (e) {
    albumImageProviderLogger.warning(
        "Couldn't get the offline image for track '${request.item.name}' because it's missing a blurhash");
  }

  if (downloadedImage?.file == null) {
    if (FinampSettingsHelper.finampSettings.isOffline) {
      return null;
    }

    Uri? imageUrl = jellyfinApiHelper.getImageUrl(
      item: request.item,
      maxWidth: request.maxWidth,
      maxHeight: request.maxHeight,
    );

    if (imageUrl == null) {
      return null;
    }

    return NetworkImage(imageUrl.toString());
  }

  return FileImage(downloadedImage!.file!);
});
