import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

/// Start Mix for Tracks, Add/Remove for item collections
class AudioMuseInstantMixMenuEntry extends ConsumerWidget implements HideableMenuEntry {
  final BaseItemDto baseItem;

  const AudioMuseInstantMixMenuEntry({super.key, required this.baseItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    if (BaseItemDtoType.fromItem(baseItem) == BaseItemDtoType.track) {
      return MenuEntry(
        icon: TablerIcons.compass,
        title: "Instant Mix via AudioMuse",
        onTap: () async {
          Navigator.pop(context); // close menu
          await audioServiceHelper.startAudioMuseInstantMixForItem(baseItem);

          GlobalSnackbar.message((context) => "${AppLocalizations.of(context)!.startingInstantMix} via AudioMuse", isConfirmation: true);
        },
      );
    }

    return SizedBox.shrink();
  }

  @override
  bool get isVisible => true;
}
