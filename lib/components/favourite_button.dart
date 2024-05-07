import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    Key? key,
    required this.item,
    this.onToggle,
    this.onlyIfFav = false,
    this.inPlayer = false,
    this.color,
    this.size,
    this.visualDensity,
  }) : super(key: key);

  final BaseItemDto? item;
  final void Function(bool isFavorite)? onToggle;
  final bool onlyIfFav;
  final bool inPlayer;
  final Color? color;
  final double? size;
  final VisualDensity? visualDensity;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    final isOffline = FinampSettingsHelper.finampSettings.isOffline;

    if (widget.item == null) {
      return const SizedBox.shrink();
    }

    bool isFav = widget.item?.userData?.isFavorite ?? false;
    if (widget.onlyIfFav) {
      if (isFav && !FinampSettingsHelper.finampSettings.onlyShowFavourite) {
        return Icon(
          Icons.favorite,
          color: Colors.red,
          size: widget.size ?? 24.0,
          semanticLabel: AppLocalizations.of(context)!.favourite,
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return IconButton(
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_outline,
          size: widget.size ?? 24.0,
        ),
        color: widget.color ?? IconTheme.of(context).color,
        disabledColor:
            (widget.color ?? IconTheme.of(context).color)!.withOpacity(0.3),
        visualDensity: widget.visualDensity ?? VisualDensity.compact,
        tooltip: AppLocalizations.of(context)!.favourite,
        onPressed: isOffline
            ? null
            : () async {
                if (isOffline) {
                  FeedbackHelper.feedback(FeedbackType.error);
                  GlobalSnackbar.message((context) =>
                      AppLocalizations.of(context)!.notAvailableInOfflineMode);
                  return;
                }

                try {
                  UserItemDataDto? newUserData;
                  if (isFav) {
                    newUserData = await jellyfinApiHelper
                        .removeFavourite(widget.item!.id);
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
                    FeedbackHelper.feedback(FeedbackType.success);
                    widget.onToggle!(widget.item!.userData!.isFavorite);
                  }
                } catch (e) {
                  GlobalSnackbar.error(e);
                }
              },
      );
    }
  }
}
