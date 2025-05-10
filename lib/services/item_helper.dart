import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'item_helper.g.dart';

@riverpod
Future<List<BaseItemDto>?> loadChildTracks(
  Ref ref, {
  required BaseItemDto baseItem,
  SortBy? sortBy,
  SortOrder? sortOrder,
}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final settings = FinampSettingsHelper.finampSettings;

  final Future<List<BaseItemDto>?> newItemsFuture;

  if (settings.isOffline) {
    newItemsFuture = loadChildTracksOffline(
      baseItem: baseItem,
    );
    return newItemsFuture;
  }

  switch (BaseItemDtoType.fromItem(baseItem)) {
    case BaseItemDtoType.album:
    case BaseItemDtoType.playlist:
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: baseItem,
        includeItemTypes: [
          BaseItemDtoType.track.idString,
        ].join(","),
        sortBy: sortBy?.jellyfinName(null) ??
            "ParentIndexNumber,IndexNumber,SortName",
        sortOrder: sortOrder?.toString(),
        // filters: settings.onlyShowFavourites ? "IsFavorite" : null,
      );
      break;
    case BaseItemDtoType.artist:
    case BaseItemDtoType.genre:
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: baseItem,
        includeItemTypes: [
          BaseItemDtoType.track.idString,
        ].join(","),
        sortBy: sortBy?.jellyfinName(null) ?? SortBy.album.jellyfinName(null),
        sortOrder: sortOrder?.toString(),
        // filters: settings.onlyShowFavourites ? "IsFavorite" : null,
      );
      break;
    default:
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: baseItem,
        includeItemTypes: [
          BaseItemDtoType.track.idString,
        ].join(","),
        sortBy: sortBy?.jellyfinName(null) ??
            "ParentIndexNumber,IndexNumber,SortName",
        sortOrder: sortOrder?.toString(),
        // filters: settings.onlyShowFavourites ? "IsFavorite" : null,
      );
  }

  final items = await newItemsFuture;

  if (items == null) {
    GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!
        .couldNotLoad(BaseItemDtoType.fromItem(baseItem).name));
    return [];
  }

  return await newItemsFuture;
}

Future<List<BaseItemDto>?> loadChildTracksOffline({
  required BaseItemDto baseItem,
  int? limit,
}) async {
  final downloadsService = GetIt.instance<DownloadsService>();

  List<BaseItemDto> items;

  switch (BaseItemDtoType.fromItem(baseItem)) {
    default:
      items = await downloadsService.getCollectionTracks(
        baseItem,
        playable: true,
      );
      break;
  }

  return (limit != null ? items.take(limit) : items).toList();
}
