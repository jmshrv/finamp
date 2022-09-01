import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/jellyfin_models.dart';
import '../services/downloads_helper.dart';
import '../services/finamp_settings_helper.dart';
import '../services/jellyfin_api_helper.dart';

/// A class that handles returning ImageProviders for Jellyfin items. This class
/// only has one static function to handle this, and has no constructors. It's a
/// bit of a jank way to do this, so if you know a better way, please let me
/// know :)
class AlbumImageProvider {
  static Future<ImageProvider> init(BaseItemDto item,
      {int? maxWidth, int? maxHeight}) async {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final downloadsHelper = GetIt.instance<DownloadsHelper>();

    final downloadedImage = downloadsHelper.getDownloadedImage(item);

    if (downloadedImage == null) {
      if (FinampSettingsHelper.finampSettings.isOffline) {
        return Future.error(
            "Item ${item.id} does not have a downloaded image and the app is in offline mode - refusing to return image");
      }

      Uri? imageUrl = jellyfinApiHelper.getImageUrl(
        item: item,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      final networkImage = NetworkImage(imageUrl.toString());

      return networkImage;
    }

    if (await downloadsHelper.verifyDownloadedImage(downloadedImage)) {
      return FileImage(downloadedImage.file);
    }

    // If we've got this far, the download image has failed to verify.
    // We recurse, which will either return a NetworkImage or an error depending
    // on if the app is offline.
    return init(item, maxWidth: maxWidth, maxHeight: maxHeight);
  }
}
