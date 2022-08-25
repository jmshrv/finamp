import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/jellyfin_models.dart';
import 'process_artist.dart';

/// Creates the subtitle text used on AlbumItemListTile and AlbumItemCard
String? generateSubtitle(
    BaseItemDto item, String? parentType, BuildContext context) {
  // TODO: Make it so that album subtitle on the artist screen isn't the artist's name (maybe something like the number of songs in the album)

  // If the parentType is MusicArtist, this is being called by an AlbumListTile in an AlbumView of an artist.
  if (parentType == "MusicArtist") {
    return item.productionYearString;
  }

  switch (item.type) {
    case "MusicAlbum":
      return processArtist(item.albumArtist, context);
    case "Playlist":
      return AppLocalizations.of(context)!.songCount(item.childCount!);
    // case "MusicGenre":
    // case "MusicArtist":
    //   return Text("${item.albumCount} Albums");
    default:
      return null;
  }
}
