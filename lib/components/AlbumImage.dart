import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get_it/get_it.dart';

import '../services/JellyfinApiData.dart';
import '../services/FinampSettingsHelper.dart';

class AlbumImage extends StatelessWidget {
  AlbumImage({
    Key? key,
    this.itemId,
    this.blurHash,
  }) : super(key: key);

  final String? itemId;
  final String? blurHash;

  final JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  static const double borderRadius = 4;

  @override
  Widget build(BuildContext context) {
    if (FinampSettingsHelper.finampSettings.isOffline || itemId == null) {
      // If we're in offline mode, don't show images since they could be loaded online
      return AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: blurHash == null
              ? Container(
                  color: Theme.of(context).cardColor,
                  child: Icon(Icons.album),
                )
              : BlurHash(hash: blurHash!),
        ),
      );
    } else if (kDebugMode) {
      // If Flutter encounters an error, such as a 404, when getting an image, it will throw an exception.
      // This is super annoying while debugging since every blank album stops the whole app.
      // Because of this, I don't load images while the app is in debug mode.
      return AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          child: Container(
            color: Theme.of(context).cardColor,
            child: Placeholder(),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
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

            return CachedNetworkImage(
              imageUrl:
                  "${jellyfinApiData.currentUser!.baseUrl}/Items/$itemId/Images/Primary?format=webp&MaxWidth=$physicalWidth&MaxHeight=$physicalHeight",
              fit: BoxFit.cover,
              placeholder: (context, url) => blurHash == null
                  ? Container(
                      color: Theme.of(context).cardColor,
                      child: Icon(Icons.album))
                  : BlurHash(hash: blurHash!),
              errorWidget: (context, url, error) => blurHash == null
                  ? Container(
                      color: Theme.of(context).cardColor,
                      child: Icon(Icons.album))
                  : BlurHash(hash: blurHash!),
            );
          }),
        ),
      );
    }
  }
}
