import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

Widget buildArtistTypeSelectionRow(BuildContext context, TabContentType tabType, ArtistListType artistListType, Function(TabContentType) refreshTab) {
  if (tabType == TabContentType.artists) {
    var currentSettings = FinampSettingsHelper.finampSettings;

    //Currently, album artists work only in online mode -> if we are in offline mode, we switch to performing artists and refresh
    if(currentSettings.isOffline && artistListType == ArtistListType.albumartist){
      FinampSettingsHelper.setArtistListType(ArtistListType.artist);
      refreshTab(tabType);
    }
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: currentSettings.isOffline ? 0.4 : 1.0,
            child: FilterChip(
              label: Text(AppLocalizations.of(context)!.albumArtists),
              onSelected: (_) {
                if (!currentSettings.isOffline) {
                  FinampSettingsHelper.setArtistListType(ArtistListType.albumartist);
                  refreshTab(tabType);
                }
              },
              selected: artistListType == ArtistListType.albumartist,
              showCheckmark: false,
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              labelStyle: TextStyle(
                color: artistListType == ArtistListType.albumartist
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              shape: StadiumBorder(),
            ),
          ),
          SizedBox(width: 8),
          FilterChip(
            label: Text(AppLocalizations.of(context)!.performingArtists),
            onSelected: (_) {
              FinampSettingsHelper.setArtistListType(ArtistListType.artist);
              refreshTab(tabType);
            }, 
            selected: artistListType == ArtistListType.artist,
            showCheckmark: false,
            selectedColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            labelStyle: TextStyle(
              color: artistListType == ArtistListType.artist
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface
            ),
            shape: StadiumBorder(),
          ),
        ],
      ),
    );
  }
  return SizedBox.shrink();
}