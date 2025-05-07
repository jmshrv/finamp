import 'package:finamp/models/finamp_models.dart';
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
    var artistCuratedItemSelectionTypeValue = ref.watch(finampSettingsProvider.artistCuratedItemSelectionType);
    var artistMostPlayedOfflineFallbackValue = ref.watch(finampSettingsProvider.artistMostPlayedOfflineFallback);
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
          SizedBox(height: 8),
          ListTile(
              title: Text(AppLocalizations.of(context)!.artistCuratedItemSelectionTypeTitle),
              subtitle:
                  Text(AppLocalizations.of(context)!.artistCuratedItemSelectionTypeSubtitle),
              trailing: DropdownButton<CuratedItemSelectionType>(
                  value: artistCuratedItemSelectionTypeValue,
                  items: CuratedItemSelectionType.values
                      .map((e) => DropdownMenuItem<CuratedItemSelectionType>(
                            value: e,
                            child: Text(e.toLocalisedString(context)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      FinampSetters.setArtistCuratedItemSelectionType(value);
                    }
                  },
                ),
            ),
          if (artistCuratedItemSelectionTypeValue == CuratedItemSelectionType.mostPlayed)
            SizedBox(height: 8),
          if (artistCuratedItemSelectionTypeValue == CuratedItemSelectionType.mostPlayed)
            ListTile(
              title: Text(AppLocalizations.of(context)!.artistMostPlayedOfflineFallbackTitle),
              subtitle:
                  Text(AppLocalizations.of(context)!.artistMostPlayedOfflineFallbackSubtitle),
              trailing: DropdownButton<CuratedItemSelectionType>(
                  value: artistMostPlayedOfflineFallbackValue,
                  items: CuratedItemSelectionType.values
                      .where((e) => e != CuratedItemSelectionType.mostPlayed)
                      .map((e) => DropdownMenuItem<CuratedItemSelectionType>(
                            value: e,
                            child: Text(e.toLocalisedString(context)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      FinampSetters.setArtistMostPlayedOfflineFallback(value);
                    }
                  },
                ),
            ),
          SizedBox(height: 16),
        ]
      ),
    );
  }
}
