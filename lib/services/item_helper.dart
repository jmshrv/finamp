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

Future<List<BaseItemDto>> loadChildTracks({required PlayableItem item, BaseItemDto? genreFilter}) {
  switch (item) {
    case AlbumDisc():
      return Future.value(item.tracks);
    case BaseItemDto():
      return loadChildTracksFromBaseItem(baseItem: item, genreFilter: genreFilter);
  }
}

Future<List<BaseItemDto>> loadChildTracksFromBaseItem({required BaseItemDto baseItem, BaseItemDto? genreFilter}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();
  final settings = FinampSettingsHelper.finampSettings;
  final ref = GetIt.instance<ProviderContainer>();

  final Future<List<BaseItemDto>?> newItemsFuture;

  if (settings.isOffline) {
    newItemsFuture = loadChildTracksOffline(baseItem: baseItem, genreFilter: genreFilter);
  } else {
    switch (BaseItemDtoType.fromItem(baseItem)) {
      case BaseItemDtoType.track:
        newItemsFuture = Future.value([baseItem]);
        break;
      case BaseItemDtoType.album:
        newItemsFuture = ref
            .read(getAlbumOrPlaylistTracksProvider(baseItem).future)
            .then((value) => value.$2); // get playable tracks
      case BaseItemDtoType.playlist:
        newItemsFuture = ref
            .read(getSortedPlaylistTracksProvider(baseItem, genreFilter: genreFilter).future)
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
          genreFilter: baseItem,
        );
        break;
      default:
        newItemsFuture = jellyfinApiHelper.getItems(
          parentItem: baseItem,
          includeItemTypes: [BaseItemDtoType.track.idString].join(","),
          sortBy: "ParentIndexNumber,IndexNumber,SortName",
          sortOrder: null,
          genreFilter: genreFilter,
          // filters: settings.onlyShowFavorites ? "IsFavorite" : null,
        );
    }
  }

  final List<BaseItemDto>? newItems = await newItemsFuture;

  if (newItems == null) {
    GlobalSnackbar.message(
      (scaffold) => AppLocalizations.of(scaffold)!.couldNotLoad(BaseItemDtoType.fromItem(baseItem).name),
    );
    return [];
  }

  return newItems;
}

List<BaseItemDto> groupItems({
  required List<BaseItemDto> items,
  required String? Function(BaseItemDto) groupListBy,
  bool manuallyShuffle = false,
}) {
  var albums = items.groupListsBy(groupListBy).values.toList();
  if (manuallyShuffle) {
    albums = albums..shuffle();
  }
  return albums.flattened.toList();
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
    case BaseItemDtoType.playlist:
      items = await GetIt.instance<ProviderContainer>()
          .read(getSortedPlaylistTracksProvider(baseItem, genreFilter: genreFilter).future)
          .then((value) => value.$2); // get playable tracks
    case BaseItemDtoType.artist:
      items = await GetIt.instance<ProviderContainer>().read(
        getArtistTracksProvider(baseItem, finampUserHelper.currentUser?.currentView, genreFilter).future,
      );
      break;
    default:
      items = await downloadsService.getCollectionTracks(baseItem, playable: true, genreFilter: genreFilter);
      break;
  }

  return (limit != null ? items.take(limit) : items).toList();
}
