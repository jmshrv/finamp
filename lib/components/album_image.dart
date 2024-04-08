import 'dart:io';
import 'dart:math';

import 'package:finamp/components/PlayerScreen/player_split_screen_scaffold.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    super.key,
    this.item,
    this.imageListenable,
    this.imageProviderCallback,
    this.borderRadius,
    this.placeholderBuilder,
    this.disabled = false,
    this.autoScale = true,
  });

  /// The item to get an image for.
  final BaseItemDto? item;

  final ProviderListenable<ImageProvider?>? imageListenable;

  /// A callback to get the image provider once it has been fetched.
  final ImageProviderCallback? imageProviderCallback;

  final BorderRadius? borderRadius;

  final WidgetBuilder? placeholderBuilder;

  final bool disabled;

  /// Whether to automatically scale the image to the size of the widget.
  final bool autoScale;

  static final defaultBorderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderRadius = this.borderRadius ?? defaultBorderRadius;

    assert(item == null || imageListenable == null);
    if ((item == null || item!.imageId == null) && imageListenable == null) {
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
          int? physicalWidth;
          int? physicalHeight;
          if (autoScale) {
            // LayoutBuilder (and other pixel-related stuff in Flutter) returns logical pixels instead of physical pixels.
            // While this is great for doing layout stuff, we want to get images that are the right size in pixels.
            // Logical pixels aren't the same as the physical pixels on the device, they're quite a bit bigger.
            // If we use logical pixels for the image request, we'll get a smaller image than we want.
            // Because of this, we convert the logical pixels to physical pixels by multiplying by the device's DPI.
            final MediaQueryData mediaQuery = MediaQuery.of(context);
            physicalWidth =
                (constraints.maxWidth * mediaQuery.devicePixelRatio).toInt();
            physicalHeight =
                (constraints.maxHeight * mediaQuery.devicePixelRatio).toInt();
            // If using grid music screen view without fixed size tiles, and if the view is resizable due
            // to being on desktop and using split screen, then clamp album size to reduce server requests when resizing.
            if ((!(Platform.isIOS || Platform.isAndroid) ||
                    usingPlayerSplitScreen) &&
                !FinampSettingsHelper.finampSettings.useFixedSizeGridTiles &&
                FinampSettingsHelper.finampSettings.contentViewType ==
                    ContentViewType.grid) {
              physicalWidth = exp((log(physicalWidth) * 3).ceil() / 3).toInt();
              physicalHeight =
                  exp((log(physicalHeight) * 3).ceil() / 3).toInt();
            }
          }

          var image = BareAlbumImage(
            imageListenable: imageListenable ??
                albumImageProvider(AlbumImageRequest(
                  item: item!,
                  maxWidth: physicalWidth,
                  maxHeight: physicalHeight,
                )),
            imageProviderCallback: imageProviderCallback,
            placeholderBuilder: placeholderBuilder ??
                (item?.blurHash != null
                    ? (_) => Image(
                        fit: BoxFit.contain,
                        image: BlurHashImage(
                          item!.blurHash!,
                        ))
                    : BareAlbumImage.defaultPlaceholderBuilder),
            physicalWidth: physicalWidth,
            physicalHeight: physicalHeight,
          );
          return disabled
              ? Opacity(
                  opacity: 0.75,
                  child: ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.color),
                      child: image))
              : image;
        }),
      ),
    );
  }
}

/// An [AlbumImage] without any of the padding or media size detection.
class BareAlbumImage extends ConsumerWidget {
  const BareAlbumImage({
    super.key,
    required this.imageListenable,
    this.imageProviderCallback,
    this.errorBuilder = defaultErrorBuilder,
    this.placeholderBuilder = defaultPlaceholderBuilder,
    this.physicalWidth,
    this.physicalHeight,
  });

  final ProviderListenable<ImageProvider?> imageListenable;
  final WidgetBuilder placeholderBuilder;
  final OctoErrorBuilder errorBuilder;
  final ImageProviderCallback? imageProviderCallback;
  final int? physicalWidth;
  final int? physicalHeight;

  static Widget defaultPlaceholderBuilder(BuildContext context) {
    return Container(color: Theme.of(context).cardColor);
  }

  static Widget defaultErrorBuilder(BuildContext context, _, __) {
    return const _AlbumImageErrorPlaceholder();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ImageProvider? image = ref.watch(imageListenable);

    if (image != null) {
      if (imageProviderCallback != null) {
        imageProviderCallback!(image);
      }
      return LayoutBuilder(builder: (context, constraints) {
        return OctoImage(
          image: image,
          filterQuality: FilterQuality.medium,
          fadeOutDuration: const Duration(milliseconds: 0),
          fadeInDuration: const Duration(milliseconds: 0),
          fit: BoxFit.contain,
          placeholderBuilder: placeholderBuilder,
          errorBuilder: errorBuilder,
          // Limit memory cached image size to displayed size
          // This is especially important for FileImages, which are downloaded
          // at full resolution
          memCacheHeight: physicalHeight,
          memCacheWidth: physicalWidth,
        );
      });
    }

    return Builder(builder: placeholderBuilder);
  }
}

class _AlbumImageErrorPlaceholder extends StatelessWidget {
  const _AlbumImageErrorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: const Icon(Icons.album),
    );
  }
}
