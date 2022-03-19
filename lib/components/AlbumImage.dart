import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:octo_image/octo_image.dart';

import '../models/JellyfinModels.dart';
import '../services/JellyfinApiData.dart';
import '../services/DownloadsHelper.dart';
import '../services/FinampSettingsHelper.dart';

class AlbumImage extends StatelessWidget {
  AlbumImage({Key? key, this.item}) : super(key: key);

  final BaseItemDto? item;

  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();

  static final BorderRadius borderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    if (item == null || item!.imageId == null) {
      return const _AlbumImageErrorPlaceholder();
    }

    final downloadedImage = _downloadsHelper.getDownloadedImage(item!);

    return ClipRRect(
      borderRadius: borderRadius,
      child: AspectRatio(
        aspectRatio: 1,
        child: downloadedImage == null &&
                !FinampSettingsHelper.finampSettings.isOffline
            ? LayoutBuilder(builder: (context, constraints) {
                // LayoutBuilder (and other pixel-related stuff in Flutter) returns logical pixels instead of physical pixels.
                // While this is great for doing layout stuff, we want to get images that are the right size in pixels.
                // Logical pixels aren't the same as the physical pixels on the device, they're quite a bit bigger.
                // If we use logical pixels for the image request, we'll get a smaller image than we want.
                // Because of this, we convert the logical pixels to physical pixels by multiplying by the device's DPI.
                final MediaQueryData mediaQuery = MediaQuery.of(context);
                final int physicalWidth =
                    (constraints.maxWidth * mediaQuery.devicePixelRatio)
                        .toInt();
                final int physicalHeight =
                    (constraints.maxHeight * mediaQuery.devicePixelRatio)
                        .toInt();

                Uri? imageUrl = _jellyfinApiData.getImageUrl(
                  item: item!,
                  maxWidth: physicalWidth,
                  maxHeight: physicalHeight,
                );

                return OctoImage(
                  image: NetworkImage(imageUrl.toString()),
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) => Container(
                    color: Theme.of(context).cardColor,
                  ),
                  errorBuilder: (_, __, ___) =>
                      const _AlbumImageErrorPlaceholder(),
                );
              })
            : downloadedImage == null
                ? const _AlbumImageErrorPlaceholder()
                : _CheckedDownloadedImage(downloadedImage: downloadedImage),
      ),
    );
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

class _CheckedDownloadedImage extends StatefulWidget {
  const _CheckedDownloadedImage({
    Key? key,
    required this.downloadedImage,
  }) : super(key: key);

  final DownloadedImage downloadedImage;

  @override
  State<_CheckedDownloadedImage> createState() =>
      __CheckedDownloadedImageState();
}

class __CheckedDownloadedImageState extends State<_CheckedDownloadedImage> {
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  late Future<bool> _checkedDownloadedImageFuture;

  @override
  void initState() {
    super.initState();
    _checkedDownloadedImageFuture =
        _downloadsHelper.verifyDownloadedImage(widget.downloadedImage);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkedDownloadedImageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return Image.file(widget.downloadedImage.file);
          }
        }

        return const _AlbumImageErrorPlaceholder();
      },
    );
  }
}
