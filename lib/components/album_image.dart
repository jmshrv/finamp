import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:finamp/components/PlayerScreen/player_split_screen_scaffold.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:octo_image/octo_image.dart';

import '../models/jellyfin_models.dart';
import '../services/album_image_provider.dart';
import '../services/theme_provider.dart';

typedef ImageProviderCallback = void Function(ImageProvider theme);

/// This widget provides the default look for album images throughout Finamp -
/// Aspect ratio 1 with a circular border radius of 4. If you don't want these
/// customisations, use [BareAlbumImage] or get an [ImageProvider] directly
/// through [AlbumImageProvider.init].
class AlbumImage extends ConsumerWidget {
  const AlbumImage({
    super.key,
    this.item,
    this.imageListenable,
    this.borderRadius,
    this.placeholderBuilder,
    this.disabled = false,
    this.autoScale = true,
    this.decoration,
  });

  /// The item to get an image for.
  final BaseItemDto? item;

  final ProviderListenable<ThemeImage>? imageListenable;

  final BorderRadius? borderRadius;

  final WidgetBuilder? placeholderBuilder;

  final bool disabled;

  /// Whether to automatically scale the image to the size of the widget.
  final bool autoScale;

  /// The decoration to use for the album image. This is defined in AlbumImage
  /// instead of being used as a separate widget so that non-square images don't
  /// look incorrect due to AlbumImage having an aspect ratio of 1:1
  final Decoration? decoration;

  static final defaultBorderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderRadius = this.borderRadius ?? defaultBorderRadius;
    assert(item == null || imageListenable == null);
    if ((item == null || item!.imageId == null) && imageListenable == null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: decoration,
            child: const _AlbumImageErrorPlaceholder(),
          ),
        ),
      );
    }

    return Semantics(
      // label: item?.name != null ? AppLocalizations.of(context)!.artworkTooltip(item!.name!) : AppLocalizations.of(context)!.artwork, // removed to reduce screen reader verbosity
      excludeSemantics: true,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Align(
          child: ClipRRect(
            borderRadius: borderRadius,
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
                    (constraints.maxWidth * mediaQuery.devicePixelRatio)
                        .toInt();
                physicalHeight =
                    (constraints.maxHeight * mediaQuery.devicePixelRatio)
                        .toInt();
                // If using grid music screen view without fixed size tiles, and if the view is resizable due
                // to being on desktop and using split screen, then clamp album size to reduce server requests when resizing.
                if ((!(Platform.isIOS || Platform.isAndroid) ||
                        usingPlayerSplitScreen) &&
                    !FinampSettingsHelper
                        .finampSettings.useFixedSizeGridTiles &&
                    FinampSettingsHelper.finampSettings.contentViewType ==
                        ContentViewType.grid) {
                  physicalWidth =
                      exp((log(physicalWidth) * 3).ceil() / 3).toInt();
                  physicalHeight =
                      exp((log(physicalHeight) * 3).ceil() / 3).toInt();
                }
              }

              var listenable = imageListenable;
              if (listenable == null) {
                // If the current themeing context has a usable image for this item,
                // use that instead of generating a new request
                if (ref.watch(localThemeInfoProvider.select((request) =>
                    (request?.largeThemeImage ?? false) &&
                    request?.item == item))) {
                  listenable = localImageProvider;
                } else {
                  listenable = albumImageProvider(AlbumImageRequest(
                    item: item!,
                    maxWidth: physicalWidth,
                    maxHeight: physicalHeight,
                  )).select((value) => ThemeImage(value, item?.blurHash));
                }
              }

              var image = Container(
                decoration: decoration,
                child: BareAlbumImage(
                    imageListenable: listenable,
                    placeholderBuilder: placeholderBuilder),
              );
              return disabled
                  ? Opacity(
                      opacity: 0.75,
                      child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.color),
                          child: image))
                  : image;
            }),
          ),
        ),
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
    this.placeholderBuilder,
  });

  final ProviderListenable<ThemeImage> imageListenable;
  final WidgetBuilder? placeholderBuilder;
  final OctoErrorBuilder errorBuilder;
  final ImageProviderCallback? imageProviderCallback;

  static Widget defaultPlaceholderBuilder(BuildContext context) {
    return Container(color: Theme.of(context).cardColor);
  }

  static Widget defaultErrorBuilder(BuildContext context, _, __) {
    return const _AlbumImageErrorPlaceholder();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var ThemeImage(image: image, blurHash: blurHash) =
        ref.watch(imageListenable);
    var localPlaceholder = placeholderBuilder;
    if (blurHash != null) {
      localPlaceholder ??= (_) => Image(
            fit: BoxFit.contain,
            image: BlurHashImage(
              blurHash,
              // Allow scaling blurhashes up to 3200 pixels wide by setting scale
              scale: 0.01,
            ),
          );
    }
    localPlaceholder ??= defaultPlaceholderBuilder;

    if (image != null) {
      if (imageProviderCallback != null) {
        imageProviderCallback!(image);
      }
      return LayoutBuilder(builder: (context, constraints) {
        return OctoImage(
          image: image,
          filterQuality: FilterQuality.medium,
          fadeOutDuration: MediaQuery.of(context).disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 300),
          fadeInDuration: MediaQuery.of(context).disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 300),
          fit: BoxFit.contain,
          placeholderBuilder: localPlaceholder,
          errorBuilder: errorBuilder,
        );
      });
    }

    return Builder(builder: localPlaceholder);
  }
}

class _AlbumImageErrorPlaceholder extends StatelessWidget {
  const _AlbumImageErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: const Icon(Icons.album),
    );
  }
}

class TapToZoomImage extends StatefulWidget {
  final AlbumImage albumImage;
  final bool isDisabled;

  const TapToZoomImage({
    super.key,
    required this.albumImage,
    this.isDisabled = false,
  });

  @override
  _TapToZoomImageState createState() => _TapToZoomImageState();
}

final zoomedImageHeroTag = "zoomed-image";

class _TapToZoomImageState extends State<TapToZoomImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.isDisabled) {
      return widget.albumImage;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(PageRouteBuilder<ZoomedImage>(
            opaque: false,
            barrierDismissible: true,
            transitionDuration: MediaQuery.of(context).disableAnimations
                ? Duration.zero
                : const Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return ZoomedImage(albumImage: widget.albumImage);
            })),
        child: Hero(
          tag: zoomedImageHeroTag,
          child: widget.albumImage,
          placeholderBuilder: (context, heroSize, child) => widget.albumImage,
        ),
      ),
    );
  }
}

class ZoomedImage extends StatelessWidget {
  final AlbumImage albumImage;

  const ZoomedImage({
    super.key,
    required this.albumImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(),
              ),
            ),
          ),
        ),
        Center(
            child: Dismissible(
          key: const Key("zoomed-image-dismiss"),
          direction: DismissDirection.vertical,
          onDismissed: (direction) {
            Navigator.of(context).pop();
          },
          child: InteractiveViewer(
            constrained: true,
            panEnabled: true,
            clipBehavior: Clip.none,
            child: Hero(
              tag: zoomedImageHeroTag,
              child: albumImage,
            ),
          ),
        )),
        Positioned(
          top: 8,
          right: 16,
          child: IconButton(
            icon: const Icon(TablerIcons.x),
            color: Colors.white,
            iconSize: 32.0,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
