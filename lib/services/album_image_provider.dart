import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import '../models/jellyfin_models.dart';
import 'downloads_service.dart';
import 'finamp_settings_helper.dart';
import 'jellyfin_api_helper.dart';

final albumImageProviderLogger = Logger("AlbumImageProvider");
/// This file is used as a fallback if no image is available for an album or track. It needs to be resolved asynchronously, so this is done in `_setupProviders` in main.dart
late File fallbackImageFile;

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
        return FileImage(fallbackImageFile, scale: 0.25);
      }

      final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
      final isarDownloader = GetIt.instance<DownloadsService>();

      DownloadItem? downloadedImage = isarDownloader.getImageDownload(item: request.item);

      if (downloadedImage?.file == null) {
        if (ref.watch(finampSettingsProvider.isOffline)) {
          return FileImage(fallbackImageFile, scale: 0.25);
        }

        Uri? imageUrl = jellyfinApiHelper.getImageUrl(
          item: request.item,
          maxWidth: request.maxWidth,
          maxHeight: request.maxHeight,
        );

        if (imageUrl == null) {
          return getResizedImage(FileImage(fallbackImageFile), request);
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
      ImageProvider out = getResizedImage(FileImage(downloadedImage!.file!, scale: 0.25), request);

      return out;
    });

ImageProvider getResizedImage(ImageProvider image, AlbumImageRequest request) {
  if (request.maxWidth != null && request.maxHeight != null) {
    // Limit memory cached image size to twice displayed size
    // This helps keep cache usage by fileImages in check
    // Caching smaller at 2X size results in blurriness comparable to
    // NetworkImages fetched with display size
    return ResizeImage(
      image,
      width: request.maxWidth! * 2,
      height: request.maxHeight! * 2,
      policy: ResizeImagePolicy.fit,
    );
  } else {
    return image;
  }
}

Future<File> getImageFile(String imagePath) async {
  final Directory tempDir = await getTemporaryDirectory();
  final String tempPath = tempDir.path;
  final String fileName = imagePath.split('/').last;

  // test if file already exists
  final File file = File('$tempPath/$fileName');
  if (await file.existsSync()) {
    return file;
  }

  // if not, load asset and write to file
  final ByteData byteData = await rootBundle.load(imagePath);
  final Uint8List bytes = byteData.buffer.asUint8List();

  await file.writeAsBytes(bytes);

  return file;
}

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
