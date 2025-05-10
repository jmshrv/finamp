import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';


Widget buildGenreItemFilterList(WidgetRef ref, BaseItemDtoType filterListFor){
  final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
  final genreCuratedItemSelectionTypeTracksSetting =
        ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeTracks);
  final genreCuratedItemSelectionType = (filterListFor == BaseItemDtoType.artist)
      ? ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeArtists)
      : ((filterListFor == BaseItemDtoType.album)
          ? ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeAlbums)
          : ((isOffline && genreCuratedItemSelectionTypeTracksSetting == CuratedItemSelectionType.mostPlayed)
          ? ref.watch(finampSettingsProvider.genreMostPlayedOfflineFallback)
          : genreCuratedItemSelectionTypeTracksSetting));

  return SliverToBoxAdapter(
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _getAvailableSelectionTypes(filterListFor).asMap().entries.expand((entry) {
                    final int index = entry.key;
                    final type = entry.value;
                    final bool isSelected = (genreCuratedItemSelectionType == type);
                    final colorScheme = Theme.of(context).colorScheme;
                    double leftPadding = index == 0 ? 8.0 : 0.0;
                    double rightPadding = index == CuratedItemSelectionType.values.length - 1 ? 8.0 : 6.0;
                    return [
                      Padding(
                        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
                        child: FilterChip(
                          label: Text(type.toLocalisedString(context)),
                          onSelected: (isOffline && type == CuratedItemSelectionType.mostPlayed)
                            ? null
                            : (_) {
                              if (filterListFor == BaseItemDtoType.track) {
                                FinampSetters.setGenreCuratedItemSelectionTypeTracks(type);
                              } else if (filterListFor == BaseItemDtoType.album) {
                                FinampSetters.setGenreCuratedItemSelectionTypeAlbums(type);
                              } else if (filterListFor == BaseItemDtoType.artist) {
                                FinampSetters.setGenreCuratedItemSelectionTypeArtists(type);
                              }
                            },
                          selected: isSelected,
                          tooltip: (isOffline && type == CuratedItemSelectionType.mostPlayed)
                              ? AppLocalizations.of(context)!.genreMostPlayedOfflineTooltip
                              : null,
                          showCheckmark: false,
                          selectedColor: colorScheme.primary,
                          backgroundColor: colorScheme.surface,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                          ),
                          shape: StadiumBorder(),
                        ),
                      ),
                    ];
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

List<CuratedItemSelectionType> _getAvailableSelectionTypes(BaseItemDtoType filterListFor) {
  switch (filterListFor) {
    case BaseItemDtoType.album:
      return CuratedItemSelectionType.values
          .where((type) => type != CuratedItemSelectionType.mostPlayed)
          .toList();
    case BaseItemDtoType.artist:
      return CuratedItemSelectionType.values
          .where((type) =>
              type != CuratedItemSelectionType.mostPlayed &&
              type != CuratedItemSelectionType.latestReleases)
          .toList();
    default:
      return CuratedItemSelectionType.values;
  }
}
