import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/favorite_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

import 'playlist_actions_menu.dart';

class AddToPlaylistButton extends ConsumerStatefulWidget {
  const AddToPlaylistButton({
    super.key,
    required this.item,
    this.queueItem,
    this.color,
    this.size,
    this.visualDensity,
  });

  final BaseItemDto? item;
  final FinampQueueItem? queueItem;
  final Color? color;
  final double? size;
  final VisualDensity? visualDensity;

  @override
  ConsumerState<AddToPlaylistButton> createState() =>
      _AddToPlaylistButtonState();
}

class _AddToPlaylistButtonState extends ConsumerState<AddToPlaylistButton> {
  final _queueService = GetIt.instance<QueueService>();

  @override
  Widget build(BuildContext context) {
    if (widget.item == null) {
      return const SizedBox.shrink();
    }

    bool isFav = ref.watch(isFavoriteProvider(FavoriteRequest(widget.item)));
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: AppLocalizations.of(context)!.addToPlaylistTooltip,
        hint: AppLocalizations.of(context)!.playlistActionsMenuButtonTooltip,
        button: true,
      ),
      excludeSemantics: true,
      container: true,
      child: GestureDetector(
        onLongPress: () async {
          FeedbackHelper.feedback(FeedbackType.selection);
          ref
              .read(isFavoriteProvider(FavoriteRequest(widget.item)).notifier)
              .updateFavorite(!isFav);
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
              final currentTrack = _queueService.getCurrentTrack()?.baseItem;
              await showPlaylistActionsMenu(
                context: context,
                item: widget.item!,
                parentPlaylist:
                    inPlaylist ? widget.queueItem!.source.item : null,
                usePlayerTheme: widget.item?.blurHash != null &&
                    widget.item?.blurHash == currentTrack?.blurHash,
              );
            }),
      ),
    );
  }
}
