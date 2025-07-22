import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/finamp_models.dart';
import '../../../services/finamp_settings_helper.dart';

class TileAdditionalInfoTypeTitleListTile extends ConsumerWidget {
  const TileAdditionalInfoTypeTitleListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.additionalBaseItemInfoTitle),
      subtitle: Text(AppLocalizations.of(context)!.additionalBaseItemInfoSubtitle),
    );
  }
}

class TileAdditionalInfoTypeDropdownListTile extends ConsumerWidget {
  final TabContentType tabContentType;

  const TileAdditionalInfoTypeDropdownListTile({required this.tabContentType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileAdditionalInfoType = ref.watch(finampSettingsProvider.tileAdditionalInfoType(tabContentType));
    final currentType = tileAdditionalInfoType ?? TileAdditionalInfoType.adaptive;

    // Filter dropdown items based on tabContentType
    final dropdownItems = [
      TileAdditionalInfoType.adaptive,
      TileAdditionalInfoType.dateAdded,
      if ([TabContentType.tracks, TabContentType.albums].contains(tabContentType)) TileAdditionalInfoType.dateReleased,
      if ([TabContentType.tracks].contains(tabContentType)) TileAdditionalInfoType.playCount,
      if ([TabContentType.tracks].contains(tabContentType)) TileAdditionalInfoType.dateLastPlayed,
      if ([TabContentType.albums, TabContentType.artists, TabContentType.playlists].contains(tabContentType))
        TileAdditionalInfoType.duration,
      TileAdditionalInfoType.none,
    ];

    return ListTile(
      title: Text(tabContentType.toLocalisedString(context)),
      trailing: DropdownButton<TileAdditionalInfoType>(
        value: currentType,
        items: dropdownItems
            .map((e) => DropdownMenuItem<TileAdditionalInfoType>(value: e, child: Text(e.toLocalisedString(context))))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            FinampSetters.setTileAdditionalInfoType(tabContentType, value);
          }
        },
      ),
    );
  }
}
