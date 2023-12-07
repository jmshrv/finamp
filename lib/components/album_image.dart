import 'package:finamp/services/current_album_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:octo_image/octo_image.dart';

import '../models/jellyfin_models.dart';
import '../services/album_image_provider.dart';

typedef ImageProviderCallback = void Function(ImageProvider? imageProvider);

/// This widget provides the default look for album images throughout Finamp -
/// Aspect ratio 1 with a circular border radius of 4. If you don't want these
/// customisations, use [BareAlbumImage] or get an [ImageProvider] directly
/// through [AlbumImageProvider.init].
class AlbumImage extends ConsumerWidget {
  const AlbumImage({
    Key? key,
    this.item,
    this.updateProvider = false,
    this.itemsToPrecache,
    this.borderRadius,
    this.placeholderBuilder,
  }) : super(key: key);

  /// The item to get an image for.
  final BaseItemDto? item;

  /// A callback to get the image provider once it has been fetched.
  final bool updateProvider;

  /// A list of items to precache
  final List<BaseItemDto>? itemsToPrecache;

  final BorderRadius? borderRadius;

  final WidgetBuilder? placeholderBuilder;

  static final defaultBorderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderRadius = this.borderRadius ?? defaultBorderRadius;

    if (item == null || item!.imageId == null) {
      if (updateProvider) {
        BareAlbumImage.registerThemeUpdate(null, ref);
      }

      return ClipRRect(
        borderRadius: borderRadius,
        child: const AspectRatio(
          aspectRatio: 1,
          child: _AlbumImageErrorPlaceholder(),
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(builder: (context, constraints) {
          // LayoutBuilder (and other pixel-related stuff in Flutter) returns logical pixels instead of physical pixels.
          // While this is great for doing layout stuff, we want to get images that are the right size in pixels.
          // Logical pixels aren't the same as the physical pixels on the device, they're quite a bit bigger.
          // If we use logical pixels for the image request, we'll get a smaller image than we want.
          // Because of this, we convert the logical pixels to physical pixels by multiplying by the device's DPI.
          final MediaQueryData mediaQuery = MediaQuery.of(context);
          final int physicalWidth =
              (constraints.maxWidth * mediaQuery.devicePixelRatio).toInt();
          final int physicalHeight =
              (constraints.maxHeight * mediaQuery.devicePixelRatio).toInt();

          return BareAlbumImage(
            item: item!,
            maxWidth: physicalWidth,
            maxHeight: physicalHeight,
            updateProvider: updateProvider,
            itemsToPrecache: itemsToPrecache,
            placeholderBuilder: placeholderBuilder ?? BareAlbumImage.defaultPlaceholderBuilder,
          );
        }),
      ),
    );
  }
}

/// An [AlbumImage] without any of the padding or media size detection.
class BareAlbumImage extends ConsumerWidget {
  const BareAlbumImage({
    Key? key,
    required this.item,
    this.maxWidth,
    this.maxHeight,
    this.errorBuilder = defaultErrorBuilder,
    this.placeholderBuilder = defaultPlaceholderBuilder,
    this.itemsToPrecache,
    this.updateProvider = false,
  }) : super(key: key);

  final BaseItemDto item;
  final int? maxWidth;
  final int? maxHeight;
  final bool updateProvider;
  final WidgetBuilder placeholderBuilder;
  final OctoErrorBuilder errorBuilder;

  /// A list of items to precache
  final List<BaseItemDto>? itemsToPrecache;

  static Widget defaultPlaceholderBuilder(BuildContext context) {
    return Container(color: Theme.of(context).cardColor);
  }

  static Widget defaultErrorBuilder(BuildContext context, _, __) {
    return const _AlbumImageErrorPlaceholder();
  }

  static void registerThemeUpdate(ImageProvider? imageProvider, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Do not update provider if values are == to prevent redraw loops.
      // Redraw loops can also occur if multiple albums are fighting to update this
      if (ref.read(currentAlbumImageProvider.notifier).state == imageProvider) {
        return;
      }
      Logger("AlbumImage").fine("Replaced theme image with ${imageProvider.toString()}");
      ref.read(currentAlbumImageProvider.notifier).state = imageProvider;
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    for (final itemToPrecache in itemsToPrecache ?? []) {
      ref.listen(
          albumImageProvider(AlbumImageRequest(
              item: itemToPrecache,
              maxWidth: maxWidth,
              maxHeight: maxHeight)), (previous, next) {
        if ((previous == null || previous.valueOrNull == null) &&
            next.valueOrNull != null) {
          precacheImage(next.value!, context);
        }
      });
    }

    AsyncValue<ImageProvider?> image =
        ref.watch(albumImageProvider(AlbumImageRequest(
      item: item,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    )));

    if (image.hasValue) {
      if (updateProvider) {
        BareAlbumImage.registerThemeUpdate(image.value, ref);
      }
      return OctoImage(
        image: image.value!,
        fit: BoxFit.cover,
        placeholderBuilder: placeholderBuilder,
        errorBuilder: errorBuilder,
      );
    }

    if (image.hasError) {
      if (updateProvider) {
        BareAlbumImage.registerThemeUpdate(null, ref);
      }
      return const _AlbumImageErrorPlaceholder();
    }

    return Builder(builder: placeholderBuilder);
  }
}

class _AlbumImageErrorPlaceholder extends StatelessWidget {
  const _AlbumImageErrorPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: const Icon(Icons.album),
    );
  }
}
