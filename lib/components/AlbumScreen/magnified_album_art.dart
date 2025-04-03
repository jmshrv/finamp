import '../album_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/jellyfin_models.dart';

class MagnifiedAlbumArt extends StatelessWidget {
  final BaseItemDto album;
  final VoidCallback onDismiss;

  const MagnifiedAlbumArt({
    Key? key,
    required this.album,
    required this.onDismiss
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: TransformationController(),
      onInteractionEnd: (details) {
        // Check if the image has been "thrown" far enough away
        if (details.velocity.pixelsPerSecond.dx.abs() > 200 || details.velocity.pixelsPerSecond.dy.abs() > 200) { // Adjust threshold as needed
          onDismiss();
        }
      },
      child: AlbumImage(item: album), // Or a simple Image widget
    );
  }
}