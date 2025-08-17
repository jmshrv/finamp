import 'package:finamp/builders/annotations.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

part "show_artist_chip_image_toggle.g.dart";

@Searchable()
class ShowArtistChipImageToggle extends ConsumerWidget {
  const ShowArtistChipImageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.showArtistChipImage),
      subtitle: Text(AppLocalizations.of(context)!.showArtistChipImageSubtitle),
      value: ref.watch(finampSettingsProvider.showArtistChipImage),
      onChanged: FinampSetters.setShowArtistChipImage,
    );
  }
}
