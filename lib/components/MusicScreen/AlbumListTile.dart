import 'package:flutter/material.dart';

import '../../models/JellyfinModels.dart';
import '../../services/processArtist.dart';
import '../../services/processProductionYear.dart';
import '../AlbumImage.dart';

class AlbumListTile extends StatelessWidget {
  const AlbumListTile({
    Key? key,
    required this.album,
    this.parentType,
    this.onTap,
  }) : super(key: key);

  final BaseItemDto album;
  final String? parentType;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // This widget is used on the add to playlist screen, so we allow a custom
      // onTap to be passed as an argument.
      onTap: onTap ??
          () {
            if (album.type == "MusicArtist" || album.type == "MusicGenre") {
              Navigator.of(context)
                  .pushNamed("/music/artistscreen", arguments: album);
            } else {
              Navigator.of(context)
                  .pushNamed("/music/albumscreen", arguments: album);
            }
          },
      leading: AlbumImage(itemId: album.id),
      title: Text(
        album.name ?? "Unknown Name",
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: _generateSubtitle(album, parentType),
    );
  }

  Widget? _generateSubtitle(BaseItemDto item, String? parentType) {
    // TODO: Make it so that album subtitle on the artist screen isn't the artist's name (maybe something like the number of songs in the album)

    // If the parentType is MusicArtist, this is being called by an AlbumListTile in an AlbumView of an artist.
    if (parentType == "MusicArtist") {
      return Text(processProductionYear(item.productionYear));
    }

    switch (item.type) {
      case "MusicAlbum":
        return Text(processArtist(item.albumArtist));
      case "Playlist":
        return Text("${item.childCount} Songs");
      // case "MusicGenre":
      // case "MusicArtist":
      //   return Text("${item.albumCount} Albums");
      default:
        return null;
    }
  }
}
