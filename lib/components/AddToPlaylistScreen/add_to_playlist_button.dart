import 'package:Finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:Finamp/components/global_snackbar.dart';
import 'package:Finamp/models/finamp_models.dart';
import 'package:Finamp/models/jellyfin_models.dart';
import 'package:Finamp/services/favorite_provider.dart';
import 'package:Finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  Widget build(BuildContext context) {
    if (widget.item == null) {
      return const SizedBox.shrink();
    }

    bool isFav = ref
        .watch(isFavoriteProvider(widget.item?.id, DefaultValue(widget.item)));
    return GestureDetector(
      onLongPress: () async {
        ref
            .read(isFavoriteProvider(widget.item?.id, DefaultValue()).notifier)
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
            await showPlaylistActionsMenu(
              context: context,
              item: widget.item!,
              parentPlaylist: inPlaylist ? widget.queueItem!.source.item : null,
              usePlayerTheme: true,
            );
          }),
    );
  }
}
