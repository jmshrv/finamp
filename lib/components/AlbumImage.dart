import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/JellyfinModels.dart';
import '../services/JellyfinApiData.dart';
import '../services/FinampSettingsHelper.dart';

class AlbumImage extends StatelessWidget {
  AlbumImage({Key? key, this.item}) : super(key: key);

  final BaseItemDto? item;

  final JellyfinApiData _jellyfinApiData = GetIt.instance<JellyfinApiData>();

  static final BorderRadius borderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    Uri? imageUrl =
        item == null ? null : _jellyfinApiData.getImageUrl(item: item!);

    if (FinampSettingsHelper.finampSettings.isOffline ||
        item == null ||
        imageUrl == null) {
      // If we're in offline mode, don't show images since they could be loaded online
      return const _AlbumImageErrorPlaceholder();
    } else if (kDebugMode) {
      // If Flutter encounters an error, such as a 404, when getting an image, it will throw an exception.
      // This is super annoying while debugging since every blank album stops the whole app.
      // Because of this, I don't load images while the app is in debug mode.
      return AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            color: Theme.of(context).cardColor,
            child: const Placeholder(),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: borderRadius,
        child: AspectRatio(
          aspectRatio: 1,
          child: CachedNetworkImage(
            imageUrl: imageUrl.toString(),
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Theme.of(context).cardColor,
            ),
            errorWidget: (_, __, ___) => const _AlbumImageErrorPlaceholder(),
          ),
        ),
      );
    }
  }
}

class _AlbumImageErrorPlaceholder extends StatelessWidget {
  const _AlbumImageErrorPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: AlbumImage.borderRadius,
        child: Container(
          color: Theme.of(context).cardColor,
          child: const Icon(Icons.album),
        ),
      ),
    );
  }
}
