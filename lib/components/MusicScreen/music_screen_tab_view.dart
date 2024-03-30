import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/song_list_tile.dart';
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
  });

  final TabContentType tabContentType;
  final String? searchTerm;
  final BaseItemDto? view;

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
        parentItem: widget.tabContentType.itemType == BaseItemDtoType.playlist ? null : widget.view,
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
        filters: settings.onlyShowFavourite ? "IsFavorite" : null,
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
          nullableViewFilters: settings.showDownloadsWithUnknownLibrary);
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
              settings.showDownloadsWithUnknownLibrary);
    }

    var items = offlineItems.map((e) => e.baseItem).whereNotNull().toList();
    items.sort((a, b) {
      switch (settings.tabSortBy[widget.tabContentType] ?? SortBy.sortName) {
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
          throw UnimplementedError(
              "Unimplemented offline sort mode ${settings.tabSortBy[widget.tabContentType]}");
      }
    });
    // Skip appending page if a refresh triggered while processing
    if (localRefreshCount == refreshCount && mounted) {
      if (settings.tabSortOrder[widget.tabContentType] ==
          SortOrder.descending) {
        // The above sort functions sort in ascending order, so we swap them
        // when sorting in descending order.
        _pagingController.appendLastPage(items.reversed.toList());
      } else {
        _pagingController.appendLastPage(items);
      }
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
      _pagingController.refresh();
    });
    super.initState();
  }

  // Scrolls the list to the first occurrence of the letter in the list
  // If clicked in the # element, it goes to the first one ( pixels = 0 )
  void scrollToLetter(String? clickedLetter) async {
    String? letter = clickedLetter ?? letterToSearch;
    bool reversed = FinampSettingsHelper
            .finampSettings.tabSortOrder[widget.tabContentType] ==
        SortOrder.descending;
    if (letter == null || letter.isEmpty) return;

    letterToSearch = letter;
    var letterCodePoint = letterToSearch!.toLowerCase().codeUnitAt(0);

    if (letter == '#') {
      letterCodePoint = 0;
    }
    for (var i = 0; i < _pagingController.itemList!.length; i++) {
      var itemCodePoint =
          _pagingController.itemList![i].nameForSorting!.codeUnitAt(0);
      var diff = itemCodePoint - letterCodePoint;
      if (reversed ? diff <= 0 : diff >= 0) {
        timer?.cancel();
        if (reversed ? diff < 0 : diff > 0) {
          await controller.scrollToIndex(i,
              duration: const Duration(milliseconds: 200),
              preferPosition: AutoScrollPosition.middle);
        } else {
          await controller.scrollToIndex(i,
              duration: const Duration(milliseconds: 200),
              preferPosition: AutoScrollPosition.begin);
        }
        letterToSearch = null;
        return;
      }
    }

    timer?.cancel();
    if (fullyLoadedRefresh == refreshCount) {
      letterToSearch = null;
    } else {
      timer = Timer(const Duration(seconds: 5), () {
        // If page loading takes >5 seconds, cancel search and allow image loading.
        letterToSearch = null;
      });

      _pagingController
          .notifyPageRequestListeners(_pagingController.nextPageKey!);
    }
    await controller.animateTo(controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void dispose() {
    _refreshStream?.cancel();
    _pagingController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder<Box<FinampSettings>>(
        valueListenable: FinampSettingsHelper.finampSettingsListener,
        builder: (context, box, _) {
          // If the searchTerm argument is different to lastSearch, the user has changed their search input.
          // This makes albumViewFuture search again so that results with the search are shown.
          // This also means we don't redo a search unless we actaully need to.
          var settings = box.get("FinampSettings")!;
          var newRefreshHash = Object.hash(
              widget.searchTerm,
              settings.onlyShowFavourite,
              settings.tabSortBy[widget.tabContentType],
              settings.tabSortOrder[widget.tabContentType],
              settings.onlyShowFullyDownloaded,
              widget.view?.id,
              settings.isOffline);
          if (refreshHash == null) {
            refreshHash = newRefreshHash;
          } else if (refreshHash != newRefreshHash) {
            refreshCount++;
            _requestedPageKey = -1;
            // This makes refreshing actually work in error cases
            _pagingController.value =
                const PagingState(nextPageKey: 0, itemList: []);
            _pagingController.refresh();
            refreshHash = newRefreshHash;
          }

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
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: widget.tabContentType == TabContentType.songs
                            ? SongListTile(
                                key: ValueKey(item.id),
                                item: item,
                                isSong: true,
                              )
                            : AlbumItem(
                                key: ValueKey(item.id),
                                album: item,
                                isPlaylist: widget.tabContentType ==
                                    TabContentType.playlists,
                              ),
                      );
                    },
                    firstPageProgressIndicatorBuilder: (_) =>
                        const FirstPageProgressIndicator(),
                    newPageProgressIndicatorBuilder: (_) =>
                        const NewPageProgressIndicator(),
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    height: widget.tabContentType == TabContentType.artists ||
                            widget.tabContentType == TabContentType.genres
                        ? 16.0
                        : 0.0,
                  ),
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
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width >
                            MediaQuery.of(context).size.height
                        ? box
                            .get("FinampSettings")!
                            .contentGridViewCrossAxisCountLandscape
                        : box
                            .get("FinampSettings")!
                            .contentGridViewCrossAxisCountPortrait,
                  ),
                );

          return RefreshIndicator(
            onRefresh: () async {
              refreshCount++;
              _requestedPageKey = -1;
              // This makes refreshing actually work in error cases
              _pagingController.value =
                  const PagingState(nextPageKey: 0, itemList: []);
              _pagingController.refresh();
            },
            child: Scrollbar(
              controller: controller,
              child: box.get("FinampSettings")!.showFastScroller &&
                      settings.tabSortBy[widget.tabContentType] ==
                          SortBy.sortName
                  ? AlphabetList(
                      callback: scrollToLetter,
                      sortOrder: settings.tabSortOrder[widget.tabContentType] ??
                          SortOrder.ascending,
                      child: tabContent)
                  : tabContent,
            ),
          );
        });
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
