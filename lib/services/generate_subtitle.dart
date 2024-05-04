import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/jellyfin_models.dart';
import 'process_artist.dart';

/// Creates the subtitle text used on AlbumItemListTile and AlbumItemCard
String? generateSubtitle(
    BaseItemDto item, String? parentType, BuildContext context) {
  // If the parentType is MusicArtist, this is being called by an AlbumListTile in an AlbumView of an artist.
  if (parentType == "MusicArtist") {
    return item.productionYearString;
  }

  switch (item.type) {
    case "MusicAlbum":
      return item.albumArtists != null &&
              item.albumArtists!.isNotEmpty &&
              (item.albumArtists!.length > 1 ||
                  item.albumArtists?.first.name != item.albumArtist)
          ? item.albumArtists
              ?.map((e) => processArtist(e.name, context))
              .join(", ")
          : processArtist(item.albumArtist, context);
    case "Playlist":
      return AppLocalizations.of(context)!.songCount(item.childCount!);
    // case "MusicGenre":
    // case "MusicArtist":
    //   return Text("${item.albumCount} Albums");
    default:
      return null;
  }
}
