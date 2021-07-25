import 'package:finamp/services/FinampSettingsHelper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/processArtist.dart';
import '../../services/processProductionYear.dart';
import '../AlbumImage.dart';
import '../errorSnackbar.dart';

enum AlbumListTileMenuItems {
  AddFavourite,
  RemoveFavourite,
}

class AlbumListTile extends StatefulWidget {
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
  _AlbumListTileState createState() => _AlbumListTileState();
}

class _AlbumListTileState extends State<AlbumListTile> {
  late BaseItemDto mutableAlbum;

  @override
  void initState() {
    super.initState();
    mutableAlbum = widget.album;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onLongPressStart: (details) async {
        Feedback.forLongPress(context);

        if (FinampSettingsHelper.finampSettings.isOffline) {
          // If offline, don't show the context menu since the only options here
          // are for online.
          return;
        }

        final selection = await showMenu<AlbumListTileMenuItems>(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            screenSize.width - details.globalPosition.dx,
            screenSize.height - details.globalPosition.dy,
          ),
          items: [
            mutableAlbum.userData!.isFavorite
                ? PopupMenuItem<AlbumListTileMenuItems>(
                    value: AlbumListTileMenuItems.RemoveFavourite,
                    child: ListTile(
                      leading: Icon(Icons.star_border),
                      title: Text("Remove Favourite"),
                    ),
                  )
                : PopupMenuItem<AlbumListTileMenuItems>(
                    value: AlbumListTileMenuItems.AddFavourite,
                    child: ListTile(
                      leading: Icon(Icons.star),
                      title: Text("Add Favourite"),
                    ),
                  ),
          ],
        );

        final jellyfinApiData = GetIt.instance<JellyfinApiData>();

        switch (selection) {
          case AlbumListTileMenuItems.AddFavourite:
            try {
              final newUserData =
                  await jellyfinApiData.addFavourite(mutableAlbum.id);
              setState(() {
                mutableAlbum.userData = newUserData;
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Favourite added.")));
            } catch (e) {
              errorSnackbar(e, context);
            }
            break;
          case AlbumListTileMenuItems.RemoveFavourite:
            try {
              final newUserData =
                  await jellyfinApiData.removeFavourite(mutableAlbum.id);
              setState(() {
                mutableAlbum.userData = newUserData;
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Favourite removed.")));
            } catch (e) {
              errorSnackbar(e, context);
            }
            break;
          case null:
            break;
        }
      },
      child: ListTile(
        // This widget is used on the add to playlist screen, so we allow a custom
        // onTap to be passed as an argument.
        onTap: widget.onTap ??
            () {
              if (mutableAlbum.type == "MusicArtist" ||
                  mutableAlbum.type == "MusicGenre") {
                Navigator.of(context)
                    .pushNamed("/music/artistscreen", arguments: mutableAlbum);
              } else {
                Navigator.of(context)
                    .pushNamed("/music/albumscreen", arguments: mutableAlbum);
              }
            },
        leading: AlbumImage(itemId: mutableAlbum.id),
        title: Text(
          mutableAlbum.name ?? "Unknown Name",
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: _generateSubtitle(mutableAlbum, widget.parentType),
      ),
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
