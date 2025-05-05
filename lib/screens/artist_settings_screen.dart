import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ArtistSettingsScreen extends ConsumerStatefulWidget {
  const ArtistSettingsScreen({super.key});
  static const routeName = "/settings/artist";
  @override
  ConsumerState<ArtistSettingsScreen> createState() => _ArtistSettingsScreenState();
}

class _ArtistSettingsScreenState extends ConsumerState<ArtistSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.artistScreen),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetArtistSettings)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile.adaptive(
            title: Text(AppLocalizations.of(context)!.artistGenreChipsApplyFilterTitle),
            subtitle: Text(AppLocalizations.of(context)!.artistGenreChipsApplyFilterSubtitle),
            value: ref.watch(finampSettingsProvider.artistGenreChipsApplyFilter),
            onChanged: FinampSetters.setArtistGenreChipsApplyFilter,
          ),
          SizedBox(height: 16),
        ]
      ),
    );
  }
}
