import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/favorite_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../menus/playlist_actions_menu.dart';

class AddToPlaylistButton extends ConsumerWidget {
  const AddToPlaylistButton({super.key, required this.item, this.queueItem, this.color, this.size, this.visualDensity});

  final BaseItemDto? item;
  final FinampQueueItem? queueItem;
  final Color? color;
  final double? size;
  final VisualDensity? visualDensity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (item == null) {
      return const SizedBox.shrink();
    }

    bool isFav = ref.watch(isFavoriteProvider(item));
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
          ref.read(isFavoriteProvider(item).notifier).updateFavorite(!isFav);
        },
        onSecondaryTap: () async {
          FeedbackHelper.feedback(FeedbackType.selection);
          ref.read(isFavoriteProvider(item).notifier).updateFavorite(!isFav);
        },
        child: IconButton(
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_outline, size: size ?? 24.0),
          color: color ?? IconTheme.of(context).color,
          disabledColor: (color ?? IconTheme.of(context).color)!.withOpacity(0.3),
          visualDensity: visualDensity ?? VisualDensity.compact,
          // tooltip: AppLocalizations.of(context)!.addToPlaylistTooltip,
          onPressed: () async {
            if (FinampSettingsHelper.finampSettings.isOffline) {
              return GlobalSnackbar.message((context) => AppLocalizations.of(context)!.notAvailableInOfflineMode);
            }

            bool inPlaylist = queueItemInPlaylist(queueItem);
            await showPlaylistActionsMenu(
              context: context,
              items: [item!],
              parentPlaylist: inPlaylist ? queueItem!.source.item : null,
            );
          },
        ),
      ),
    );
  }
}
