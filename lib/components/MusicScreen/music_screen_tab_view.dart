import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/track_list_tile.dart';
import '../first_page_progress_indicator.dart';
import '../global_snackbar.dart';
import '../new_page_progress_indicator.dart';
import 'album_item.dart';
import 'alphabet_item_list.dart';

class MusicScreenTabView extends StatefulWidget {
  const MusicScreenTabView({
    super.key,
    required this.tabContentType,
    this.searchTerm,
    required this.view,
    this.refresh,
  });

  final TabContentType tabContentType;
  final String? searchTerm;
  final BaseItemDto? view;
  final MusicRefreshCallback? refresh;

  @override
  State<MusicScreenTabView> createState() => _MusicScreenTabViewState();
}

// We use AutomaticKeepAliveClientMixin so that the view keeps its position after the tab is changed.
// https://stackoverflow.com/questions/49439047/how-to-preserve-widget-states-in-flutter-when-navigating-using-bottomnavigation
class _MusicScreenTabViewState extends State<MusicScreenTabView>
    with AutomaticKeepAliveClientMixin<MusicScreenTabView> {
  // tabs on the music screen should be kept alive
  @override
  bool get wantKeepAlive => true;

  static const _pageSize = 100;

  final PagingController<int, BaseItemDto> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 70);

  Future<List<BaseItemDto>>? offlineSortedItems;

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _isarDownloader = GetIt.instance<DownloadsService>();
  StreamSubscription<void>? _refreshStream;

  late AutoScrollController controller;
  int _requestedPageKey = -1;
  String? letterToSearch;
  Timer? timer;
  int? refreshHash;
  int refreshCount = 0;
  int fullyLoadedRefresh = -1;

  // This function just lets us easily set stuff to the getItems call we want.
  Future<void> _getPage(int pageKey) async {
    // The jump-to-letter widget and main view scrolling may generate duplicate page
    // requests.  Only fetch page once in these cases.
    if (pageKey <= _requestedPageKey) {
      return;
    }
    _requestedPageKey = pageKey;
    var settings = FinampSettingsHelper.finampSettings;
    if (settings.isOffline) {
      return _getPageOffline();
    }
    int localRefreshCount = refreshCount;
    try {
      final sortOrder =
          settings.tabSortOrder[widget.tabContentType]?.toString() ??
              SortOrder.ascending.toString();
      final newItems = await _jellyfinApiHelper.getItems(
        // starting with Jellyfin 10.9, only automatically created playlists will have a specific library as parent. user-created playlists will not be returned anymore
        // this condition fixes this by not providing a parentId when fetching playlists
        parentItem: widget.tabContentType.itemType == BaseItemDtoType.playlist
            ? null
            : widget.view,
        includeItemTypes: widget.tabContentType.itemType.idString,

        // If we're on the songs tab, sort by "Album,SortName". This is what the
        // Jellyfin web client does. If this isn't the case, sort by "SortName".
        // If widget.sortBy is set, it is used instead.
        sortBy: settings.tabSortBy[widget.tabContentType]
                ?.jellyfinName(widget.tabContentType) ??
            (widget.tabContentType == TabContentType.songs
                ? "Album,SortName"
                : "SortName"),
        sortOrder: sortOrder,
        searchTerm: widget.searchTerm?.trim(),
        filters: settings.onlyShowFavourites ? "IsFavorite" : null,
        startIndex: pageKey,
        limit: _pageSize,
      );

      // Skip appending page if a refresh triggered while processing
      if (localRefreshCount == refreshCount && mounted) {
        if (newItems!.length < _pageSize) {
          _pagingController.appendLastPage(newItems);
          fullyLoadedRefresh = localRefreshCount;
        } else {
          _pagingController.appendPage(newItems, pageKey + newItems.length);
        }
        if (letterToSearch != null) {
          scrollToLetter(letterToSearch);
        }
      }
    } catch (e) {
      // Ignore errors when logging out
      if (GetIt.instance<FinampUserHelper>().currentUser != null) {
        GlobalSnackbar.error(e);
      }
    }
  }

  Future<void> _getPageOffline() async {
    var settings = FinampSettingsHelper.finampSettings;
    int localRefreshCount = refreshCount;

    List<DownloadStub> offlineItems;
    if (widget.tabContentType == TabContentType.songs) {
      // If we're on the songs tab, just get all of the downloaded items
      // We should probably try to page this, at least if we are sorting by name
      offlineItems = await _isarDownloader.getAllSongs(
          nameFilter: widget.searchTerm,
          viewFilter: widget.view?.id,
          nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
          onlyFavorites:
              settings.onlyShowFavourites && settings.trackOfflineFavorites);
    } else {
      offlineItems = await _isarDownloader.getAllCollections(
          nameFilter: widget.searchTerm,
          baseTypeFilter: widget.tabContentType.itemType,
          fullyDownloaded: settings.onlyShowFullyDownloaded,
          viewFilter: widget.tabContentType == TabContentType.albums
              ? widget.view?.id
              : null,
          childViewFilter: (widget.tabContentType != TabContentType.albums &&
                  widget.tabContentType != TabContentType.playlists)
              ? widget.view?.id
              : null,
          nullableViewFilters: widget.tabContentType == TabContentType.albums &&
              settings.showDownloadsWithUnknownLibrary,
          onlyFavorites:
              settings.onlyShowFavourites && settings.trackOfflineFavorites);
    }

    var items = offlineItems.map((e) => e.baseItem).whereNotNull().toList();

    items = sortItems(items, settings.tabSortBy[widget.tabContentType],
        settings.tabSortOrder[widget.tabContentType]);

    // Skip appending page if a refresh triggered while processing
    if (localRefreshCount == refreshCount && mounted) {
      _pagingController.appendLastPage(items);
      fullyLoadedRefresh = localRefreshCount;
      if (letterToSearch != null) {
        scrollToLetter(letterToSearch);
      }
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getPage(pageKey);
    });
    controller = AutoScrollController(
        suggestedRowHeight: 72,
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    _refreshStream = _isarDownloader.offlineDeletesStream.listen((event) {
      _refresh();
    });
    super.initState();
  }

  // Scrolls the list to the first occurrence of the letter in the list
  // If clicked in the # element, it goes to the first or last one item, depending on sort order
  void scrollToLetter(String? clickedLetter) async {
    String? letter = clickedLetter ?? letterToSearch;
    if (letter == null || letter.isEmpty) return;

    letterToSearch = letter;
    var codePointToScrollTo = letterToSearch!.toLowerCase().codeUnitAt(0);

    // Max code point is lower case z to increase the chance of seeing a character
    // past the target but below the ignore point
    final maxCodePoint = 'z'.codeUnitAt(0);

    if (letter == '#') {
      codePointToScrollTo = 0;
    }

    //TODO use binary search to improve performance for already loaded pages
    bool reversed = FinampSettingsHelper
            .finampSettings.tabSortOrder[widget.tabContentType] ==
        SortOrder.descending;
    for (var i = 0; i < _pagingController.itemList!.length; i++) {
      int itemCodePoint = _pagingController.itemList![i].nameForSorting!
          .toLowerCase()
          .codeUnitAt(0);
      if (itemCodePoint <= maxCodePoint) {
        final comparisonResult = itemCodePoint - codePointToScrollTo;
        if (comparisonResult == 0) {
          timer?.cancel();
          await controller.scrollToIndex(i,
              duration: _getAnimationDurationForOffsetToIndex(i),
              preferPosition: AutoScrollPosition.begin);

          letterToSearch = null;
          return;
        } else if (reversed ? comparisonResult < 0 : comparisonResult > 0) {
          // If the letter is before the current item, there was no previous match (letter doesn't seem to exist in library)
          // scroll to the previous item instead
          timer?.cancel();
          await controller.scrollToIndex(
              (i - 1).clamp(0, (_pagingController.itemList?.length ?? 1) - 1),
              // duration: scrollDuration,
              duration: _getAnimationDurationForOffsetToIndex(i),
              preferPosition: AutoScrollPosition.middle);

          letterToSearch = null;
          return;
        }
      }
    }

    timer?.cancel();
    if (fullyLoadedRefresh == refreshCount) {
      letterToSearch = null;
    } else {
      timer = Timer(const Duration(seconds: 8), () {
        // If page loading takes >5 seconds, cancel search and allow image loading.
        letterToSearch = null;
      });

      _pagingController
          .notifyPageRequestListeners(_pagingController.nextPageKey!);
    }
    await controller.animateTo(controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  Duration _getAnimationDurationForOffsetToIndex(int index) {
    final renderedIndices = controller.tagMap.keys;
    final medianIndex = renderedIndices.elementAt(renderedIndices.length ~/ 2);

    final duration = Duration(
      milliseconds:
          ((medianIndex - index).abs() / 50 * 300).clamp(200, 7500).round(),
    );
    return duration;
  }

  @override
  void dispose() {
    _refreshStream?.cancel();
    _pagingController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _refresh() {
    refreshCount++;
    _requestedPageKey = -1;
    // This makes refreshing actually work in error cases
    _pagingController.value = const PagingState(nextPageKey: 0, itemList: []);
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.refresh?.callback = _refresh;

    return ValueListenableBuilder<Box<FinampSettings>>(
        valueListenable: FinampSettingsHelper.finampSettingsListener,
        builder: (context, box, _) {
          // If the searchTerm argument is different to lastSearch, the user has changed their search input.
          // This makes albumViewFuture search again so that results with the search are shown.
          // This also means we don't redo a search unless we actaully need to.
          var settings = box.get("FinampSettings")!;
          var newRefreshHash = Object.hash(
            widget.searchTerm,
            settings.onlyShowFavourites,
            settings.tabSortBy[widget.tabContentType],
            settings.tabSortOrder[widget.tabContentType],
            settings.onlyShowFullyDownloaded,
            widget.view?.id,
            settings.isOffline,
            settings.tabOrder.indexOf(widget.tabContentType),
            settings.trackOfflineFavorites,
          );
          if (refreshHash == null) {
            refreshHash = newRefreshHash;
          } else if (refreshHash != newRefreshHash) {
            _refresh();
            refreshHash = newRefreshHash;
          }

          final emptyListIndicator = Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.emptyFilteredListTitle,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.emptyFilteredListSubtitle,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                CTAMedium(
                  icon: TablerIcons.filter_x,
                  text: AppLocalizations.of(context)!.resetFiltersButton,
                  onPressed: () {
                    FinampSettingsHelper.setonlyShowFavourites(
                        DefaultSettings.onlyShowFavourites);
                    FinampSettingsHelper.setOnlyShowFullyDownloaded(
                        DefaultSettings.onlyShowFullyDownloaded);
                  },
                )
              ],
            ),
          );

          var tabContent = box.get("FinampSettings")!.contentViewType ==
                      ContentViewType.list ||
                  widget.tabContentType == TabContentType.songs
              ? PagedListView<int, BaseItemDto>.separated(
                  pagingController: _pagingController,
                  scrollController: controller,
                  physics: _DeferredLoadingAlwaysScrollableScrollPhysics(
                      tabState: this),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  builderDelegate: PagedChildBuilderDelegate<BaseItemDto>(
                    itemBuilder: (context, item, index) {
                      // Use right padding inherited from fast scroller minus
                      // built-in icon padding
                      return Padding(
                        padding: EdgeInsets.only(
                            right: max(
                                0, MediaQuery.paddingOf(context).right - 20)),
                        child: AutoScrollTag(
                          key: ValueKey(index),
                          controller: controller,
                          index: index,
                          child: widget.tabContentType == TabContentType.songs
                              ? TrackListTile(
                                  key: ValueKey(item.id),
                                  item: item,
                                  isSong: true,
                                  index: Future.value(index),
                                  isShownInSearch: widget.searchTerm != null,
                                  allowDismiss: false,
                                )
                              : AlbumItem(
                                  key: ValueKey(item.id),
                                  album: item,
                                  isPlaylist: widget.tabContentType ==
                                      TabContentType.playlists,
                                ),
                        ),
                      );
                    },
                    firstPageProgressIndicatorBuilder: (_) =>
                        const FirstPageProgressIndicator(),
                    newPageProgressIndicatorBuilder: (_) =>
                        const NewPageProgressIndicator(),
                    noItemsFoundIndicatorBuilder: (_) => emptyListIndicator,
                  ),
                  separatorBuilder: (context, index) => const SizedBox.shrink(),
                )
              : PagedGridView(
                  pagingController: _pagingController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollController: controller,
                  physics: _DeferredLoadingAlwaysScrollableScrollPhysics(
                      tabState: this),
                  builderDelegate: PagedChildBuilderDelegate<BaseItemDto>(
                    itemBuilder: (context, item, index) {
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: AlbumItem(
                          key: ValueKey(item.id),
                          album: item,
                          isPlaylist:
                              widget.tabContentType == TabContentType.playlists,
                          isGrid: true,
                          gridAddSettingsListener: false,
                        ),
                      );
                    },
                    firstPageProgressIndicatorBuilder: (_) =>
                        const FirstPageProgressIndicator(),
                    newPageProgressIndicatorBuilder: (_) =>
                        const NewPageProgressIndicator(),
                    noItemsFoundIndicatorBuilder: (_) => emptyListIndicator,
                  ),
                  gridDelegate: FinampSettingsHelper
                          .finampSettings.useFixedSizeGridTiles
                      ? SliverGridDelegateWithFixedSizeTiles(
                          gridTileSize: FinampSettingsHelper
                              .finampSettings.fixedGridTileSize
                              .toDouble())
                      : SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width >
                                  MediaQuery.of(context).size.height
                              ? FinampSettingsHelper.finampSettings
                                  .contentGridViewCrossAxisCountLandscape
                              : FinampSettingsHelper.finampSettings
                                  .contentGridViewCrossAxisCountPortrait,
                        ),
                );

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: box.get("FinampSettings")!.showFastScroller &&
                    settings.tabSortBy[widget.tabContentType] == SortBy.sortName
                ? AlphabetList(
                    callback: scrollToLetter,
                    scrollController: controller,
                    sortOrder: settings.tabSortOrder[widget.tabContentType] ??
                        SortOrder.ascending,
                    child: tabContent)
                : tabContent,
          );
        });
  }
}

class MusicRefreshCallback {
  void call() => callback?.call();
  void Function()? callback;
}

class SliverGridDelegateWithFixedSizeTiles extends SliverGridDelegate {
  SliverGridDelegateWithFixedSizeTiles({
    required this.gridTileSize,
  });

  final double gridTileSize;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    int crossAxisCount = (constraints.crossAxisExtent / gridTileSize).floor();
    // Ensure a minimum count of 1, can be zero and result in an infinite extent
    // below when the window size is 0.
    crossAxisCount = max(1, crossAxisCount);
    final double crossAxisSpacing =
        (constraints.crossAxisExtent / crossAxisCount);
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: gridTileSize,
      crossAxisStride: crossAxisSpacing,
      childMainAxisExtent: gridTileSize,
      childCrossAxisExtent: gridTileSize,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithFixedSizeTiles oldDelegate) {
    return oldDelegate.gridTileSize != gridTileSize;
  }
}

class _DeferredLoadingAlwaysScrollableScrollPhysics
    extends AlwaysScrollableScrollPhysics {
  const _DeferredLoadingAlwaysScrollableScrollPhysics(
      {super.parent, required this.tabState});

  final _MusicScreenTabViewState tabState;

  @override
  _DeferredLoadingAlwaysScrollableScrollPhysics applyTo(
      ScrollPhysics? ancestor) {
    return _DeferredLoadingAlwaysScrollableScrollPhysics(
        parent: buildParent(ancestor), tabState: tabState);
  }

  @override
  bool recommendDeferredLoading(
      double velocity, ScrollMetrics metrics, BuildContext context) {
    if (tabState.letterToSearch != null) {
      return true;
    }
    return super.recommendDeferredLoading(velocity, metrics, context);
  }
}

List<BaseItemDto> sortItems(
    List<BaseItemDto> itemsToSort, SortBy? sortBy, SortOrder? sortOrder) {
  itemsToSort.sort((a, b) {
    switch (sortBy ?? SortBy.sortName) {
      case SortBy.sortName:
        if (a.nameForSorting == null || b.nameForSorting == null) {
          // Returning 0 is the same as both being the same
          return 0;
        } else {
          return a.nameForSorting!.compareTo(b.nameForSorting!);
        }
      case SortBy.albumArtist:
        if (a.albumArtist == null || b.albumArtist == null) {
          return 0;
        } else {
          return a.albumArtist!.compareTo(b.albumArtist!);
        }
      case SortBy.communityRating:
        if (a.communityRating == null || b.communityRating == null) {
          return 0;
        } else {
          return a.communityRating!.compareTo(b.communityRating!);
        }
      case SortBy.criticRating:
        if (a.criticRating == null || b.criticRating == null) {
          return 0;
        } else {
          return a.criticRating!.compareTo(b.criticRating!);
        }
      case SortBy.dateCreated:
        if (a.dateCreated == null || b.dateCreated == null) {
          return 0;
        } else {
          return a.dateCreated!.compareTo(b.dateCreated!);
        }
      case SortBy.premiereDate:
        if (a.premiereDate == null || b.premiereDate == null) {
          return 0;
        } else {
          return a.premiereDate!.compareTo(b.premiereDate!);
        }
      case SortBy.random:
        // We subtract the result by one so that we can get -1 values
        // (see comareTo documentation)
        return Random().nextInt(2) - 1;
      default:
        throw UnimplementedError("Unimplemented offline sort mode $sortBy");
    }
  });
  return sortOrder == SortOrder.descending
      ? itemsToSort.reversed.toList()
      : itemsToSort;
}
