import '../models/JellyfinModels.dart';
import 'processProductionYear.dart';
import 'processArtist.dart';

/// Creates the subtitle text used on AlbumItemListTile and AlbumItemCard
String? generateSubtitle(BaseItemDto item, String? parentType) {
  // TODO: Make it so that album subtitle on the artist screen isn't the artist's name (maybe something like the number of songs in the album)

  // If the parentType is MusicArtist, this is being called by an AlbumListTile in an AlbumView of an artist.
  if (parentType == "MusicArtist") {
    return processProductionYear(item.productionYear);
  }

  switch (item.type) {
    case "MusicAlbum":
      return processArtist(item.albumArtist);
    case "Playlist":
      return "${item.childCount} Songs";
    // case "MusicGenre":
    // case "MusicArtist":
    //   return Text("${item.albumCount} Albums");
    default:
      return null;
  }
}
