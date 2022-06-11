import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../screens/ArtistScreen.dart';
import '../../services/AudioServiceHelper.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/FinampSettingsHelper.dart';
import '../../services/MusicPlayerBackgroundTask.dart';
import '../AlbumImage.dart';
import '../errorSnackbar.dart';

enum ArtistListTileMenuItems {
  AddToFavourite,
  RemoveFromFavourite,
  AddToMixList,
  RemoveFromMixList,
}

class ArtistListTile extends StatefulWidget {
  const ArtistListTile({
    Key? key,
    required this.item,
    this.index,
    this.parentId,
  }) : super(key: key);

  final BaseItemDto item;
  final int? index;
  final String? parentId;

  @override
  _ArtistListTileState createState() => _ArtistListTileState();
}

class _ArtistListTileState extends State<ArtistListTile> {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();

  late BaseItemDto mutableItem = widget.item;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final listTile = ListTile(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ArtistScreen.routeName, arguments: mutableItem);
      },
      leading: AlbumImage(item: mutableItem),
      title: Text(
        mutableItem.name ?? "Unknown Name",
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: null,
      trailing: _jellyfinApiData.selectedMixArtistsIds.contains(mutableItem.id) ? const Icon(Icons.explore) : null,
    );

    return GestureDetector(
      onLongPressStart: (details) async {
        Feedback.forLongPress(context);
        // Some options are disabled in offline mode
        final isOffline = FinampSettingsHelper.finampSettings.isOffline;

        final selection = await showMenu<ArtistListTileMenuItems>(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            screenSize.width - details.globalPosition.dx,
            screenSize.height - details.globalPosition.dy,
          ),
          items: [
            mutableItem.userData!.isFavorite
                ? const PopupMenuItem<ArtistListTileMenuItems>(
              value: ArtistListTileMenuItems.RemoveFromFavourite,
              child: ListTile(
                leading: Icon(Icons.star_border),
                title: Text("Remove Favourite"),
              ),
            )
                : const PopupMenuItem<ArtistListTileMenuItems>(
              value: ArtistListTileMenuItems.AddToFavourite,
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text("Add Favourite"),
              ),
            ),
            _jellyfinApiData.selectedMixArtistsIds.contains(mutableItem.id) ?
            const PopupMenuItem<ArtistListTileMenuItems>(
              value: ArtistListTileMenuItems.RemoveFromMixList,
              child: ListTile(
                leading: Icon(Icons.explore_off),
                title: Text("Remove From Mix List"),
              ),
            ) : const PopupMenuItem<ArtistListTileMenuItems>(
              value: ArtistListTileMenuItems.AddToMixList,
              child: ListTile(
                leading: Icon(Icons.explore),
                title: Text("Add To Mix List"),
              ),
            ),
          ],
        );

        switch (selection) {
          case ArtistListTileMenuItems.AddToFavourite:
            try {
              final newUserData =
              await _jellyfinApiData.addFavourite(mutableItem.id);
              setState(() {
                mutableItem.userData = newUserData;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Favourite added.")));
            } catch (e) {
              errorSnackbar(e, context);
            }
            break;
          case ArtistListTileMenuItems.RemoveFromFavourite:
            try {
              final newUserData =
              await _jellyfinApiData.removeFavourite(mutableItem.id);
              setState(() {
                mutableItem.userData = newUserData;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Favourite removed.")));
            } catch (e) {
              errorSnackbar(e, context);
            }
            break;
          case ArtistListTileMenuItems.AddToMixList:
            try {
              _jellyfinApiData.addArtistToMixBuilderList(mutableItem);
              setState(() {});
            } catch (e){
              errorSnackbar(e, context);
            }
            break;
          case ArtistListTileMenuItems.RemoveFromMixList:
            try {
              _jellyfinApiData.removeArtistFromBuilderList(mutableItem);
              setState(() {});
            } catch (e){
              errorSnackbar(e, context);
            }
            break;
          case null:
            break;
        }
      },
      child: listTile
    );
  }
}
