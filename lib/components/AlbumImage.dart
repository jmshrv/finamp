import 'package:cached_network_image/cached_network_image.dart';
import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/JellyfinApiData.dart';

class AlbumImage extends StatefulWidget {
  AlbumImage({Key key, @required this.itemId}) : super(key: key);

  final String itemId;

  @override
  _AlbumImageState createState() => _AlbumImageState();
}

class _AlbumImageState extends State<AlbumImage> {
  Future<String> albumImageFuture;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  @override
  void initState() {
    super.initState();
    albumImageFuture = jellyfinApiData.getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      // If Flutter encounters an error, such as a 404, when getting an image, it will throw an exception.
      // This is super annoying while debugging since every blank album stops the whole app.
      // Because of this, I don't load images while the app is in debug mode.
      return FutureBuilder<String>(
          future: albumImageFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
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
                        (constraints.maxWidth * mediaQuery.devicePixelRatio)
                            .toInt();
                    final int physicalHeight =
                        (constraints.maxHeight * mediaQuery.devicePixelRatio)
                            .toInt();
                    try {
                      return CachedNetworkImage(
                        imageUrl:
                            "${snapshot.data}/Items/${widget.itemId}/Images/Primary?format=webp&MaxWidth=$physicalWidth&MaxHeight=$physicalHeight",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).cardColor,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.album),
                      );
                    } catch (e) {
                      print(e);
                      return Container(
                        color: Theme.of(context).cardColor,
                      );
                    }
                  }),
                ),
              );
            } else {
              return ClipRRect(
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: Theme.of(context).cardColor,
                      )));
            }
          });
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          child: Container(
            color: Theme.of(context).cardColor,
          ),
        ),
      );
    }
  }
}
