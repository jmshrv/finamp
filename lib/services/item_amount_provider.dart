import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/artist_content_provider.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'item_amount_provider.g.dart';

@riverpod
Future<(int, BaseItemDtoType)> itemAmount(
  Ref ref, {
  required BaseItemDto baseItem,
  bool showTrackCountForArtists = false,
}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final library = GetIt.instance<FinampUserHelper>().currentUser?.currentView;

  BaseItemDtoType itemType = BaseItemDtoType.fromItem(baseItem);

  showTrackCountForArtists = showTrackCountForArtists ||
      ref.watch(finampSettingsProvider.defaultArtistType) == ArtistType.artist;

  Future<int> getItemCountFuture() {
    return switch (itemType) {
      BaseItemDtoType.album => Future.value(baseItem.childCount ?? 0),
      BaseItemDtoType.artist => ref.watch(finampSettingsProvider.isOffline)
          ? ref
              .watch((showTrackCountForArtists
                      ? getArtistAlbumsProvider(baseItem, library, null)
                      : getPerformingArtistTracksProvider(
                          baseItem, library, null))
                  .future)
              .then((items) => items.length)
          : jellyfinApiHelper
              .getItemsWithTotalRecordCount(
                  libraryFilter: library,
                  parentItem: baseItem,
                  includeItemTypes: showTrackCountForArtists
                      ? BaseItemDtoType.track.idString
                      : BaseItemDtoType.album.idString,
                  limit: 1,
                  artistType: showTrackCountForArtists
                      ? ArtistType.artist
                      : ArtistType.albumArtist)
              .then((fetchedItems) => fetchedItems.totalRecordCount),
      BaseItemDtoType.genre => ref.watch(finampSettingsProvider.isOffline)
          ? downloadsService
              .getAllCollections(
                  baseTypeFilter: BaseItemDtoType.album,
                  fullyDownloaded:
                      ref.watch(finampSettingsProvider.onlyShowFullyDownloaded),
                  viewFilter: library?.id,
                  nullableViewFilters: ref.watch(
                      finampSettingsProvider.showDownloadsWithUnknownLibrary),
                  genreFilter: baseItem)
              .then((fetchedItems) =>
                  fetchedItems.map((e) => e.baseItem).nonNulls.length)
          : jellyfinApiHelper
              .getItemsWithTotalRecordCount(
                parentItem: library,
                genreFilter: baseItem,
                limit: 1,
                includeItemTypes: BaseItemDtoType.album.idString,
              )
              .then((fetchedItems) => fetchedItems.totalRecordCount),
      BaseItemDtoType.playlist => Future.value(baseItem.childCount ?? 0),
      _ => Future.value(baseItem.childCount ?? 0),
    };
  }

  final Future<(int, BaseItemDtoType)> itemCountFuture =
      getItemCountFuture().then((count) async {
    if (itemType == BaseItemDtoType.artist && count == 0) {
      if (!showTrackCountForArtists) {
        // If artist has 0 albums, try counting tracks instead
        return await ref.refresh(itemAmountProvider(
          baseItem: baseItem,
          showTrackCountForArtists: true,
        ).future);
      }
    }
    return (
      count,
      getChildItemType(
          baseItem,
          showTrackCountForArtists
              ? ArtistType.artist
              : ref.watch(finampSettingsProvider.defaultArtistType)),
    );
  });

  return itemCountFuture;
}

BaseItemDtoType getChildItemType(BaseItemDto item, ArtistType artistType) {
  return switch (BaseItemDtoType.fromItem(item)) {
    BaseItemDtoType.album => BaseItemDtoType.track,
    BaseItemDtoType.artist => artistType == ArtistType.albumArtist
        ? BaseItemDtoType.album
        : BaseItemDtoType.track,
    BaseItemDtoType.genre => BaseItemDtoType.album,
    BaseItemDtoType.playlist => BaseItemDtoType.track,
    _ => BaseItemDtoType.unknown,
  };
}
