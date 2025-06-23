import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/favorite_provider.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class ToggleFavoriteMenuEntry extends ConsumerWidget implements HideableMenuEntry {
  final BaseItemDto baseItem;

  const ToggleFavoriteMenuEntry({super.key, required this.baseItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isFav = ref.watch(isFavoriteProvider(baseItem));

    return Visibility(
      visible: !ref.watch(finampSettingsProvider.isOffline),
      child: MenuEntry(
        icon: isFav ? TablerIcons.heart_filled : TablerIcons.heart,
        title: isFav ? AppLocalizations.of(context)!.removeFavorite : AppLocalizations.of(context)!.addFavorite,
        onTap: () async {
          ref.read(isFavoriteProvider(baseItem).notifier).updateFavorite(!isFav);
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  bool get isVisible => !FinampSettingsHelper.finampSettings.isOffline;
}
