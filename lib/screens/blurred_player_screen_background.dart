import 'dart:ui';

import 'package:flutter/material.dart';
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
        customImageProvider ?? ref.watch(currentAlbumImageProvider);

    return Positioned.fill(
      child: ColorFiltered(
        // Force total opacity to always be 100%
        colorFilter: const ColorFilter.matrix(<double>[
          1, 0, 0, 0, 0, // R
          0, 1, 0, 0, 0, // G
          0, 0, 1, 0, 0, // B
          0, 0, 0, 2, 0, // A
        ]),
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: ClipRect(
              // Don't transition between images with identical files/urls
              key: ValueKey(imageProvider.toString()),
              child: imageProvider == null
                  ? const SizedBox.shrink()
                  : OctoImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(seconds: 0),
                      fadeOutDuration: const Duration(seconds: 0),
                      placeholderBuilder: (_) => const SizedBox.shrink(),
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      imageBuilder: (context, child) => ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(clampDouble(
                                    0.675 * opacityFactor, 0.0, 1.0))
                                : Colors.white.withOpacity(clampDouble(
                                    0.75 * opacityFactor, 0.0, 1.0)),
                            BlendMode.srcOver),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 85,
                            sigmaY: 85,
                            tileMode: TileMode.mirror,
                          ),
                          child: SizedBox.expand(child: child),
                        ),
                      ),
                    ),
            )),
      ),
    );
  }
}
