import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'finamp_settings_helper.dart';
import 'isar_downloads.dart';
import 'jellyfin_api_helper.dart';

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
  final isardownloader = GetIt.instance<IsarDownloads>();

  final downloadedImage =
      await isardownloader.getImageDownload(item: request.item);

  if (downloadedImage == null) {
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

  return FileImage(downloadedImage.file);
});
