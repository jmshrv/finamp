import 'dart:io';

import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

Widget buildArtistTypeSelectionRow(BuildContext context, TabContentType tabType,
    ArtistType artistListType, Function(TabContentType) refreshTab) {
  if (tabType == TabContentType.artists) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool alignLeft = screenWidth > 600;

    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
            ? const EdgeInsets.symmetric(horizontal: 4)
            : EdgeInsets.zero,
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: Row(
            mainAxisAlignment:
                alignLeft ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              FilterChip(
                label: Text(AppLocalizations.of(context)!.albumArtists),
                onSelected: (_) {
                  FinampSetters.setArtistListType(ArtistType.albumartist);
                  refreshTab(tabType);
                },
                selected: artistListType == ArtistType.albumartist,
                showCheckmark: false,
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
                labelStyle: TextStyle(
                  color: artistListType == ArtistType.albumartist
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                shape: StadiumBorder(),
              ),
              SizedBox(width: 8),
              FilterChip(
                label: Text(AppLocalizations.of(context)!.performingArtists),
                onSelected: (_) {
                  FinampSetters.setArtistListType(ArtistType.artist);
                  refreshTab(tabType);
                },
                selected: artistListType == ArtistType.artist,
                showCheckmark: false,
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
                labelStyle: TextStyle(
                    color: artistListType == ArtistType.artist
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface),
                shape: StadiumBorder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return SizedBox.shrink();
}
