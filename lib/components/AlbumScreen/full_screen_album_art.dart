import 'package:finamp/models/jellyfin_models.dart';

import '../album_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FullScreenAlbumArt extends StatelessWidget {

  const FullScreenAlbumArt({
    Key? key,
    required this.album
  }) : super(key: key);

  final BaseItemDto album;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: album.hashCode,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(child: AlbumImage(item: album)),
          ),
        ),
      ]
    );
  }
}