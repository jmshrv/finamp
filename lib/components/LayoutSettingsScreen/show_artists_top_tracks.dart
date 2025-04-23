import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class ShowArtistsTopTracksSelector extends ConsumerWidget {
  const ShowArtistsTopTracksSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.showArtistsTopTracks),
      subtitle:
          Text(AppLocalizations.of(context)!.showArtistsTopTracksSubtitle),
      value: ref.watch(finampSettingsProvider.showArtistsTopTracks),
      onChanged: (value) => FinampSetters.setShowArtistsTopTracks(value),
    );
  }
}
