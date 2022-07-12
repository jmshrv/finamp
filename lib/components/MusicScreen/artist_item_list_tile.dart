import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../album_image.dart';
import '../error_snackbar.dart';

enum ArtistListTileMenuItems {
  addToFavourite,
  removeFromFavourite,
  addToMixList,
  removeFromMixList,
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
  State<ArtistListTile> createState() => _ArtistListTileState();
}

class _ArtistListTileState extends State<ArtistListTile> {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

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
      trailing:
          _jellyfinApiHelper.selectedMixArtistsIds.contains(mutableItem.id)
              ? const Icon(Icons.explore)
              : null,
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
                      value: ArtistListTileMenuItems.removeFromFavourite,
                      child: ListTile(
                        leading: Icon(Icons.star_border),
                        title: Text("Remove Favourite"),
                      ),
                    )
                  : const PopupMenuItem<ArtistListTileMenuItems>(
                      value: ArtistListTileMenuItems.addToFavourite,
                      child: ListTile(
                        leading: Icon(Icons.star),
                        title: Text("Add Favourite"),
                      ),
                    ),
              _jellyfinApiHelper.selectedMixArtistsIds.contains(mutableItem.id)
                  ? PopupMenuItem<ArtistListTileMenuItems>(
                      enabled: !isOffline,
                      value: ArtistListTileMenuItems.removeFromMixList,
                      child: ListTile(
                        leading: const Icon(Icons.explore_off),
                        title: const Text("Remove From Mix"),
                        enabled: isOffline ? false : true,
                      ),
                    )
                  : PopupMenuItem<ArtistListTileMenuItems>(
                      value: ArtistListTileMenuItems.addToMixList,
                      enabled: !isOffline,
                      child: ListTile(
                        leading: const Icon(Icons.explore),
                        title: const Text("Add To Mix"),
                        enabled: !isOffline,
                      ),
                    ),
            ],
          );

          if (!mounted) return;

          switch (selection) {
            case ArtistListTileMenuItems.addToFavourite:
              try {
                final newUserData =
                    await _jellyfinApiHelper.addFavourite(mutableItem.id);

                if (!mounted) return;

                setState(() {
                  mutableItem.userData = newUserData;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Favourite added.")));
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case ArtistListTileMenuItems.removeFromFavourite:
              try {
                final newUserData =
                    await _jellyfinApiHelper.removeFavourite(mutableItem.id);

                if (!mounted) return;

                setState(() {
                  mutableItem.userData = newUserData;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Favourite removed.")));
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case ArtistListTileMenuItems.addToMixList:
              try {
                _jellyfinApiHelper.addArtistToMixBuilderList(mutableItem);
                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case ArtistListTileMenuItems.removeFromMixList:
              try {
                _jellyfinApiHelper.removeArtistFromBuilderList(mutableItem);
                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case null:
              break;
          }
        },
        child: listTile);
  }
}
