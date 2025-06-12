import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/artist_content_provider.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class ItemAmount extends ConsumerStatefulWidget {
  const ItemAmount({
    required this.baseItem,
    this.color,
    super.key,
  });

  final BaseItemDto baseItem;
  final Color? color;

  @override
  ConsumerState<ItemAmount> createState() => _ItemAmountChipState();
}

class _ItemAmountChipState extends ConsumerState<ItemAmount> {
  bool showTrackCountForArtists = false;

  late Future<int?> itemCountFuture;
  late BaseItemDtoType itemType;
  late BaseItemDtoType childItemType;

  @override
  void initState() {
    super.initState();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final downloadsService = GetIt.instance<DownloadsService>();
    final library = GetIt.instance<FinampUserHelper>().currentUser?.currentView;
    final isOffline = ref.read(finampSettingsProvider.isOffline);

    showTrackCountForArtists =
        ref.read(finampSettingsProvider.artistListType) == ArtistType.artist;

    itemType = BaseItemDtoType.fromItem(widget.baseItem);

    Future<int?> getItemCountFuture() {
      return switch (itemType) {
        BaseItemDtoType.album => Future.value(widget.baseItem.childCount ?? 0),
        BaseItemDtoType.artist => isOffline
            ? ref
                .read((showTrackCountForArtists
                        ? getArtistAlbumsProvider(
                            widget.baseItem, library, null)
                        : getPerformingArtistTracksProvider(
                            widget.baseItem, library, null))
                    .future)
                .then((albums) => albums.length)
            : jellyfinApiHelper
                .getItemsWithTotalRecordCount(
                    libraryFilter: library,
                    parentItem: widget.baseItem,
                    includeItemTypes: showTrackCountForArtists
                        ? BaseItemDtoType.track.idString
                        : BaseItemDtoType.album.idString,
                    limit: 1,
                    artistType: showTrackCountForArtists
                        ? ArtistType.artist
                        : ArtistType.albumartist)
                .then((fetchedItems) => fetchedItems.totalRecordCount),
        BaseItemDtoType.genre => isOffline
            ? downloadsService
                .getAllCollections(
                    baseTypeFilter: BaseItemDtoType.album,
                    fullyDownloaded: ref
                        .read(finampSettingsProvider.onlyShowFullyDownloaded),
                    viewFilter: library?.id,
                    nullableViewFilters: ref.read(
                        finampSettingsProvider.showDownloadsWithUnknownLibrary),
                    genreFilter: widget.baseItem)
                .then((fetchedItems) =>
                    fetchedItems.map((e) => e.baseItem).nonNulls.length)
            : jellyfinApiHelper
                .getItemsWithTotalRecordCount(
                  parentItem: library,
                  genreFilter: widget.baseItem,
                  limit: 1,
                  includeItemTypes: "MusicAlbum",
                )
                .then((fetchedItems) => fetchedItems.totalRecordCount),
        BaseItemDtoType.playlist =>
          Future.value(widget.baseItem.childCount ?? 0),
        _ => Future.value(widget.baseItem.childCount ?? 0),
      };
    }

    itemCountFuture = getItemCountFuture().then((count) async {
      if (itemType == BaseItemDtoType.artist && count == 0) {
        showTrackCountForArtists = true;
        return await getItemCountFuture();
      }
      return count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: itemCountFuture,
        builder: (context, asyncSnapshot) {
          final itemCount = asyncSnapshot.data;

          childItemType = switch (itemType) {
            BaseItemDtoType.album => BaseItemDtoType.track,
            BaseItemDtoType.artist => showTrackCountForArtists
                ? BaseItemDtoType.track
                : BaseItemDtoType.album,
            BaseItemDtoType.genre => BaseItemDtoType.album,
            BaseItemDtoType.playlist => BaseItemDtoType.track,
            _ => BaseItemDtoType.unknown,
          };
          return Semantics.fromProperties(
            properties: SemanticsProperties(
              label: itemCount != null
                  ? AppLocalizations.of(context)!
                      .itemCount(childItemType.name, itemCount)
                  : AppLocalizations.of(context)!.itemCountCalculating,
              button: true,
            ),
            excludeSemantics: true,
            container: true,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4.0,
                children: [
                  if (itemCount == null)
                    CircularProgressIndicator(
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                        maxWidth: 16,
                        maxHeight: 16,
                      ),
                      padding: const EdgeInsets.all(2.0),
                      color: widget.color ??
                          Theme.of(context).textTheme.bodySmall!.color ??
                          Colors.white,
                      strokeWidth: 2.0,
                    ),
                  Text(
                    itemCount != null
                        ? AppLocalizations.of(context)!
                            .itemCount(childItemType.name, itemCount)
                        : AppLocalizations.of(context)!
                            .itemCountLoading(childItemType.name),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      color: widget.color ??
                          Theme.of(context).textTheme.bodySmall!.color ??
                          Colors.white,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
