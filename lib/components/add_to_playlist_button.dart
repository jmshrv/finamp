import 'package:finamp/components/AlbumScreen/song_menu.dart';
import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

class AddToPlaylistButton extends StatefulWidget {
  const AddToPlaylistButton({
    Key? key,
    required this.item,
    this.queueItem,
    this.color,
    this.size,
    this.visualDensity,
  }) : super(key: key);

  final BaseItemDto? item;
  final FinampQueueItem? queueItem;
  final Color? color;
  final double? size;
  final VisualDensity? visualDensity;

  @override
  State<AddToPlaylistButton> createState() => _AddToPlaylistButtonState();
}

class _AddToPlaylistButtonState extends State<AddToPlaylistButton> {
  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    final isOffline = FinampSettingsHelper.finampSettings.isOffline;

    if (widget.item == null) {
      return const SizedBox.shrink();
    }

    bool isFav = widget.item?.userData?.isFavorite ?? false;
    return GestureDetector(
      onDoubleTap: () async {
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
            if (widget.queueItem != null) {
              audioHandler.mediaItem.valueOrNull!.extras!['itemJson'] =
                  widget.item!.toJson();
            }
          });

          FeedbackHelper.feedback(FeedbackType.success);
        } catch (e) {
          GlobalSnackbar.error(e);
        }
      },
      child: IconButton(
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_outline,
          size: widget.size ?? 24.0,
        ),
        color: widget.color ?? IconTheme.of(context).color,
        disabledColor:
            (widget.color ?? IconTheme.of(context).color)!.withOpacity(0.3),
        visualDensity: widget.visualDensity ?? VisualDensity.compact,
        // tooltip: AppLocalizations.of(context)!.addToPlaylistTooltip,
        onPressed: () async {
          if (FinampSettingsHelper.finampSettings.isOffline) {
            return GlobalSnackbar.message((context) =>
                AppLocalizations.of(context)!.notAvailableInOfflineMode);
          }

          bool inPlaylist = queueItemInPlaylist(widget.queueItem);
          await showModalQuickActionsMenu(
            context: context,
            item: widget.item!,
            parentPlaylist: inPlaylist ? widget.queueItem!.source.item : null,
            usePlayerTheme: true,
          );
        }
      ),
    );
  }
}
