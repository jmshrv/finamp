import 'package:collection/collection.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/album_screen_provider.dart';
import 'package:finamp/services/artist_content_provider.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

Future<List<BaseItemDto>?> loadChildTracks({
  required BaseItemDto baseItem,
  SortBy? sortBy,
  SortOrder? sortOrder,
  String? Function(BaseItemDto)? groupListBy,
  BaseItemDto? genreFilter,
  bool manuallyShuffle = false,
}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();
  final settings = FinampSettingsHelper.finampSettings;
  final ref = GetIt.instance<ProviderContainer>();

  final Future<List<BaseItemDto>?> newItemsFuture;
  List<BaseItemDto>? newItems;

  if (settings.isOffline) {
    newItemsFuture = loadChildTracksOffline(baseItem: baseItem);
  } else {
    switch (BaseItemDtoType.fromItem(baseItem)) {
      case BaseItemDtoType.track:
        newItemsFuture = Future.value([baseItem]);
        break;
      case BaseItemDtoType.album:
      case BaseItemDtoType.playlist:
        newItemsFuture = ref
            .read(getAlbumOrPlaylistTracksProvider(baseItem).future)
            .then((value) => value.$2); // get playable tracks
        break;
      case BaseItemDtoType.artist:
        newItemsFuture = ref.read(
          getArtistTracksProvider(baseItem, finampUserHelper.currentUser?.currentView, genreFilter).future,
        );
        break;
      case BaseItemDtoType.genre:
        newItemsFuture = jellyfinApiHelper.getItems(
          parentItem: finampUserHelper.currentUser?.currentView,
          includeItemTypes: [BaseItemDtoType.track.idString].join(","),
          sortBy: sortBy?.jellyfinName(null) ?? SortBy.album.jellyfinName(null),
          sortOrder: sortOrder?.toString(),
          genreFilter: baseItem,
        );
        break;
      default:
        newItemsFuture = jellyfinApiHelper.getItems(
          parentItem: baseItem,
          includeItemTypes: [BaseItemDtoType.track.idString].join(","),
          sortBy: sortBy?.jellyfinName(null) ?? "ParentIndexNumber,IndexNumber,SortName",
          sortOrder: sortOrder?.toString(),
          // filters: settings.onlyShowFavorites ? "IsFavorite" : null,
        );
    }
  }

  newItems = await newItemsFuture;

  if (newItems == null) {
    GlobalSnackbar.message(
      (scaffold) => AppLocalizations.of(scaffold)!.couldNotLoad(BaseItemDtoType.fromItem(baseItem).name),
    );
    return [];
  }

  if (groupListBy != null) {
    var albums = newItems.groupListsBy(groupListBy).values.toList();
    if (manuallyShuffle) {
      albums = albums..shuffle();
    }
    newItems = albums.flattened.toList();
  }

  return newItems;
}

Future<List<BaseItemDto>?> loadChildTracksOffline({
  required BaseItemDto baseItem,
  int? limit,
  BaseItemDto? genreFilter,
}) async {
  final downloadsService = GetIt.instance<DownloadsService>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();
  final settings = FinampSettingsHelper.finampSettings;

  List<BaseItemDto> items;

  switch (BaseItemDtoType.fromItem(baseItem)) {
    case BaseItemDtoType.track:
      items = [baseItem];
      break;
    case BaseItemDtoType.genre:
      items = (await downloadsService.getAllTracks(
        viewFilter: finampUserHelper.currentUser?.currentViewId,
        nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
        genreFilter: baseItem,
      )).map((e) => e.baseItem).nonNulls.toList();
      break;
    case BaseItemDtoType.artist:
      items = await GetIt.instance<ProviderContainer>().read(
        getArtistTracksProvider(baseItem, finampUserHelper.currentUser?.currentView, genreFilter).future,
      );
      break;
    default:
      items = await downloadsService.getCollectionTracks(baseItem, playable: true);
      break;
  }

  return (limit != null ? items.take(limit) : items).toList();
}
