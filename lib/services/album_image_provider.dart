import 'dart:async';

import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  const AlbumImageRequest({required this.item, this.maxWidth, this.maxHeight}) : super();

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

final Map<String?, AlbumImageRequest> albumRequestsCache = {};

final AutoDisposeProviderFamily<ImageProvider?, AlbumImageRequest> albumImageProvider = Provider.autoDispose
    .family<ImageProvider?, AlbumImageRequest>((ref, request) {
      String? requestCacheKey = request.item.blurHash ?? request.item.imageId;

      if (albumRequestsCache.containsKey(requestCacheKey)) {
        if ((request.maxHeight ?? 999999) > (albumRequestsCache[requestCacheKey]!.maxHeight ?? 999999)) {
          albumRequestsCache[requestCacheKey] = request;
        }
      } else {
        albumRequestsCache[requestCacheKey] = request;
      }
      ref.onDispose(() {
        if (albumRequestsCache.containsKey(requestCacheKey)) {
          if (albumRequestsCache[requestCacheKey] == request) {
            albumRequestsCache.remove(requestCacheKey);
          }
        }
      });

      if (request.item.imageId == null) {
        return null;
      }

      final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
      final isardownloader = GetIt.instance<DownloadsService>();

      DownloadItem? downloadedImage = isardownloader.getImageDownload(item: request.item);

      if (downloadedImage?.file == null) {
        if (ref.watch(finampSettingsProvider.isOffline)) {
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

        String? key;
        if (request.item.blurHash != null) {
          key = request.item.blurHash! + request.maxWidth.toString() + request.maxHeight.toString();
        }
        // Allow drawing albums up to 4X intrinsic size by setting scale
        return CachedImage(NetworkImage(imageUrl.toString(), scale: 0.25), key);
      }

      // downloads are already de-dupped by blurHash and do not need CachedImage
      // Allow drawing albums up to 4X intrinsic size by setting scale
      ImageProvider out = FileImage(downloadedImage!.file!, scale: 0.25);
      if (request.maxWidth != null && request.maxHeight != null) {
        // Limit memory cached image size to twice displayed size
        // This helps keep cache usage by fileImages in check
        // Caching smaller at 2X size results in blurriness comparable to
        // NetworkImages fetched with display size
        out = ResizeImage(
          out,
          width: request.maxWidth! * 2,
          height: request.maxHeight! * 2,
          policy: ResizeImagePolicy.fit,
        );
      }
      return out;
    });

class CachedImage extends ImageProvider<CachedImage> {
  CachedImage(ImageProvider base, this.cacheKey) : _base = base;

  final ImageProvider _base;

  final String? cacheKey;

  double get scale => switch (_base) {
    NetworkImage() => _base.scale,
    FileImage() => _base.scale,
    _ => throw UnimplementedError(),
  };

  String get location => switch (_base) {
    NetworkImage() => _base.url,
    FileImage() => _base.file.path,
    _ => throw UnimplementedError(),
  };

  @override
  ImageStreamCompleter loadBuffer(CachedImage key, DecoderBufferCallback decode) => _base.loadBuffer(key._base, decode);

  @override
  ImageStreamCompleter loadImage(CachedImage key, ImageDecoderCallback decode) => _base.loadImage(key._base, decode);

  @override
  Future<CachedImage> obtainKey(ImageConfiguration configuration) => SynchronousFuture<CachedImage>(this);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (cacheKey != null) {
      return other is CachedImage && other.cacheKey == cacheKey && other.scale == scale;
    }
    return other is CachedImage && other.location == location && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(cacheKey ?? location, scale);

  @override
  String toString() => 'CachedImage("$location", scale: ${scale.toStringAsFixed(1)})';
}
