import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/favorite_provider.dart';

class FavoriteButton extends ConsumerStatefulWidget {
  const FavoriteButton({
    super.key,
    required this.item,
    this.onlyIfFav = false,
    this.inPlayer = false,
    this.color,
    this.size,
    this.visualDensity,
  });

  final BaseItemDto? item;
  final bool onlyIfFav;
  final bool inPlayer;
  final Color? color;
  final double? size;
  final VisualDensity? visualDensity;

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    final isOffline = FinampSettingsHelper.finampSettings.isOffline;

    if (widget.item == null) {
      return const SizedBox.shrink();
    }

    bool isFav = ref.watch(isFavoriteProvider(FavoriteRequest(widget.item)));
    if (widget.onlyIfFav) {
      if (isFav && !FinampSettingsHelper.finampSettings.onlyShowFavourites) {
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
            : () {
                ref
                    .read(isFavoriteProvider(FavoriteRequest(widget.item))
                        .notifier)
                    .updateFavorite(!isFav);
              },
      );
    }
  }
}
