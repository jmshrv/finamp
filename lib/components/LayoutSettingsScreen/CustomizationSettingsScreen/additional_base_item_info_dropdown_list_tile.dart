import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/finamp_models.dart';
import '../../../services/finamp_settings_helper.dart';

class AdditionalBaseItemInfoTitleListTile extends ConsumerWidget {
  const AdditionalBaseItemInfoTitleListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.additionalBaseItemInfoTitle),
      subtitle: Text(AppLocalizations.of(context)!.additionalBaseItemInfoSubtitle),
    );
  }
}

class AdditionalBaseItemInfoDropdownListTile extends ConsumerWidget {
  final BaseItemDtoType baseItemDtoType;

  const AdditionalBaseItemInfoDropdownListTile({required this.baseItemDtoType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final additionalBaseItemInfos = ref.watch(finampSettingsProvider.additionalBaseItemInfo);
    final currentType = additionalBaseItemInfos[baseItemDtoType] ?? AdditionalBaseItemInfoTypes.adaptive;

    final locTitle = switch (baseItemDtoType) {
      BaseItemDtoType.track => AppLocalizations.of(context)!.tracks,
      BaseItemDtoType.album => AppLocalizations.of(context)!.albums,
      BaseItemDtoType.artist => AppLocalizations.of(context)!.artists,
      BaseItemDtoType.playlist => AppLocalizations.of(context)!.playlists,
      BaseItemDtoType.genre => AppLocalizations.of(context)!.genres,
      _ => baseItemDtoType.idString,
    };

    // Filter dropdown items based on baseItemDtoType
    final dropdownItems = AdditionalBaseItemInfoTypes.values.where((type) {
      if (type == AdditionalBaseItemInfoTypes.adaptive ||
          type == AdditionalBaseItemInfoTypes.dateAdded ||
          type == AdditionalBaseItemInfoTypes.none) {
        return true;
      }

      switch (baseItemDtoType) {
        case BaseItemDtoType.track:
          return type == AdditionalBaseItemInfoTypes.playCount ||
              type == AdditionalBaseItemInfoTypes.dateLastPlayed ||
              type == AdditionalBaseItemInfoTypes.dateReleased;
        case BaseItemDtoType.album:
          return type == AdditionalBaseItemInfoTypes.duration || type == AdditionalBaseItemInfoTypes.dateReleased;
        case BaseItemDtoType.playlist:
        case BaseItemDtoType.artist:
          return type == AdditionalBaseItemInfoTypes.duration;
        default:
          return false;
      }
    }).toList();

    return ListTile(
      title: Text(locTitle ?? "Unknown Item Type"),
      trailing: DropdownButton<AdditionalBaseItemInfoTypes>(
        value: currentType,
        items: dropdownItems
            .map(
              (e) => DropdownMenuItem<AdditionalBaseItemInfoTypes>(value: e, child: Text(e.toLocalisedString(context))),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            final newAdditionalBaseItemInfos = Map<BaseItemDtoType, AdditionalBaseItemInfoTypes>.from(
              additionalBaseItemInfos,
            );
            newAdditionalBaseItemInfos[baseItemDtoType] = value;
            FinampSetters.setAdditionalBaseItemInfo(newAdditionalBaseItemInfos);
          }
        },
      ),
    );
  }
}
