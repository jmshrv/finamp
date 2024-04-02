import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:octo_image/octo_image.dart';

import '../services/current_album_image_provider.dart';

/// Same as [_PlayerScreenAlbumImage], but with a BlurHash instead. We also
/// filter the BlurHash so that it works as a background image.
class BlurredPlayerScreenBackground extends ConsumerWidget {
  /// should never be less than 1.0
  final double opacityFactor;
  final ImageProvider? customImageProvider;

  const BlurredPlayerScreenBackground({
    super.key,
    this.customImageProvider,
    this.opacityFactor = 1.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageProvider =
        customImageProvider ?? ref.watch(currentAlbumImageProvider).value;

    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        switchOutCurve: const Threshold(0.0),
        child: imageProvider == null
            ? const SizedBox.shrink()
            : OctoImage(
                // Don't transition between images with identical files/urls
                key: ValueKey(imageProvider.toString()),
                image: imageProvider,
                fit: BoxFit.cover,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(
                        ui.clampDouble(0.675 * opacityFactor, 0.0, 1.0))
                    : Colors.white.withOpacity(
                        ui.clampDouble(0.75 * opacityFactor, 0.0, 1.0)),
                colorBlendMode: BlendMode.srcOver,
                filterQuality: FilterQuality.none,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                imageBuilder: (context, child) => CachePaint(
                    imageKey: imageProvider.toString(),
                    child: ImageFiltered(
                      imageFilter: ui.ImageFilter.blur(
                        sigmaX: 85,
                        sigmaY: 85,
                        tileMode: TileMode.mirror,
                      ),
                      child: SizedBox.expand(child: child),
                    ))));
  }
}

class CachePaint extends SingleChildRenderObjectWidget {
  const CachePaint({super.key, super.child, required this.imageKey});

  final String imageKey;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCachePaint(MediaQuery.sizeOf(context), imageKey);
  }
}

class RenderCachePaint extends RenderProxyBox {
  RenderCachePaint(this.screenSize, var imageKey)
      : _imageKey = imageKey + screenSize.toString();

  final Size screenSize;

  final String _imageKey;

  bool hasCache = false;

  static Map<String, (int, ui.Image)> cache = {};

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    if (cache[_imageKey] != null) {
      if (!hasCache) {
        // Increment count of widgets using cached image if on first load
        hasCache = true;
        cache[_imageKey] = (cache[_imageKey]!.$1 + 1, cache[_imageKey]!.$2);
      }
      // Use cached child
      context.canvas.drawImage(cache[_imageKey]!.$2, offset, Paint());
    } else {
      // Paint our child
      super.paint(context, offset);
      // Save image of child to cache
      final OffsetLayer offsetLayer = layer! as OffsetLayer;
      hasCache = true;
      Future.sync(() async {
        cache[_imageKey] = (1, await offsetLayer.toImage(offset & screenSize));
        // Schedule repaint next frame because the image is lighter than the full
        // child during compositing, which is more frequent than paints.
        markNeedsPaint();
      });
    }
  }

  @override
  void dispose() {
    if (hasCache) {
      if (cache[_imageKey]!.$1 <= 1) {
        // If we are last user of image, dispose
        cache[_imageKey]!.$2.dispose();
        cache.remove(_imageKey);
      } else {
        // Decrement count of image users
        cache[_imageKey] = (cache[_imageKey]!.$1 - 1, cache[_imageKey]!.$2);
      }
    }
    hasCache = false;
    super.dispose();
  }
}
