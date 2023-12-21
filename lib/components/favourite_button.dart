import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    Key? key,
    required this.item,
    this.onToggle,
    this.onlyIfFav = false,
    this.inPlayer = false,
  }) : super(key: key);

  final BaseItemDto? item;
  final void Function(bool isFavorite)? onToggle;
  final bool onlyIfFav;
  final bool inPlayer;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    if (widget.item == null) {
      return const SizedBox.shrink();
    }

    bool isFav = widget.item!.userData!.isFavorite;
    if (widget.onlyIfFav) {
      if (isFav) {
        return Icon(
          Icons.favorite,
          color: Colors.red,
          size: 24.0,
          semanticLabel: AppLocalizations.of(context)!.favourite,
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return IconButton(
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_outline,
          color: isFav ? Theme.of(context).colorScheme.secondary : null,
          size: 24.0,
        ),
        tooltip: AppLocalizations.of(context)!.favourite,
        onPressed: () async {
          try {
            UserItemDataDto? newUserData;
            if (isFav) {
              newUserData =
                  await jellyfinApiHelper.removeFavourite(widget.item!.id);
            } else {
              newUserData =
                  await jellyfinApiHelper.addFavourite(widget.item!.id);
            }
            setState(() {
              widget.item!.userData = newUserData;
              if (widget.inPlayer) {
                audioHandler.mediaItem.valueOrNull!.extras!['itemJson'] =
                    widget.item!.toJson();
              }
            });

            if (widget.onToggle != null) {
              widget.onToggle!(widget.item!.userData!.isFavorite);
            }
          } catch (e) {
            errorSnackbar(e, context);
          }
        },
      );
    }
  }
}
