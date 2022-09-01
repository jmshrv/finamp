import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

import '../models/jellyfin_models.dart';
import '../services/album_image_provider.dart';

/// This widget provides the default look for album images throughout Finamp -
/// Aspect ratio 1 with a circular border radius of 4. If you don't want these
/// customisations, use [BareAlbumImage] or get an [ImageProvider] directly
/// through [AlbumImageProvider.init].
class AlbumImage extends StatelessWidget {
  const AlbumImage({Key? key, this.item}) : super(key: key);

  final BaseItemDto? item;

  static final BorderRadius borderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    if (item == null || item!.imageId == null) {
      return const _AlbumImageErrorPlaceholder();
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
          );
        }),
      ),
    );
  }
}

class BareAlbumImage extends StatefulWidget {
  BareAlbumImage({
    Key? key,
    required this.item,
    this.maxWidth,
    this.maxHeight,
    this.errorBuilder,
    this.placeholderBuilder,
  }) : super(key: key);

  final BaseItemDto item;
  final int? maxWidth;
  final int? maxHeight;
  WidgetBuilder? placeholderBuilder;
  // ignore: prefer_function_declarations_over_variables
  OctoErrorBuilder? errorBuilder =
      (context, _, __) => const _AlbumImageErrorPlaceholder();

  @override
  State<BareAlbumImage> createState() => _BareAlbumImageState();
}

class _BareAlbumImageState extends State<BareAlbumImage> {
  late Future<ImageProvider> _albumImageContentFuture;

  @override
  void initState() {
    super.initState();
    _albumImageContentFuture = AlbumImageProvider.init(
      widget.item,
      maxWidth: widget.maxWidth,
      maxHeight: widget.maxHeight,
    );
    widget.placeholderBuilder ??= (context) => Container(
          color: Theme.of(context).cardColor,
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
      future: _albumImageContentFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return OctoImage(
            image: snapshot.data!,
            fit: BoxFit.cover,
            placeholderBuilder: widget.placeholderBuilder,
            errorBuilder: widget.errorBuilder,
          );
        }

        if (snapshot.hasError) {
          return const _AlbumImageErrorPlaceholder();
        }
        return Builder(builder: widget.placeholderBuilder!);
      },
    );
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
