import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    Key? key,
    required this.item,
    this.onlyIfFav = false
  }) : super(key: key);

  final BaseItemDto item;
  final bool onlyIfFav;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    bool isFav = widget.item.userData!.isFavorite;

    if (widget.onlyIfFav) {
      return Icon(
        isFav ? Icons.favorite : null,
        color: Colors.red,
        size: 24.0,
      );
    } else {
      return IconButton(
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_outline,
          color: isFav ? Colors.red : Colors.white, // todo: default color from theme
          size: 24.0,
        ),
        onPressed: () async {
          try {
            UserItemDataDto? newUserData;
            if (isFav) {
              newUserData =
                await jellyfinApiHelper.removeFavourite(widget.item.id);
            } else {
              newUserData =
                await jellyfinApiHelper.addFavourite(widget.item.id);
            }
            setState(() {
              widget.item.userData = newUserData;
              audioHandler.mediaItem.valueOrNull!.extras!['itemJson'] =
                  widget.item.toJson();
            });
          } catch (e) {
            errorSnackbar(e, context);
          }
        },
      );
    }
  }
}
