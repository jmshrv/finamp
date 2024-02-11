import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/isar_downloads.dart';
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
      PagingController(firstPageKey: 0);

  Future<List<BaseItemDto>>? offlineSortedItems;

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _isarDownloader = GetIt.instance<IsarDownloads>();
  StreamSubscription<void>? _refreshStream;

  ScrollController? controller;
  String? letterToSearch;
  Timer? timer;
  int? refreshHash;
  int refreshCount = 0;

  // This function just lets us easily set stuff to the getItems call we want.
  Future<void> _getPage(int pageKey) async {
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
        parentItem: widget.view,
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
      if (localRefreshCount == refreshCount) {
        if (newItems!.length < _pageSize) {
          _pagingController.appendLastPage(newItems);
        } else {
          _pagingController.appendPage(newItems, pageKey + newItems.length);
        }
      }
      if (letterToSearch != null) {
        scrollToLetter(letterToSearch);
        timer?.cancel();
        timer = Timer(const Duration(seconds: 2, milliseconds: 500), () {
          scrollToNearbyLetter();
        });
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
    if (localRefreshCount == refreshCount) {
      if (settings.tabSortOrder[widget.tabContentType] ==
          SortOrder.descending) {
        // The above sort functions sort in ascending order, so we swap them
        // when sorting in descending order.
        _pagingController.appendLastPage(items.reversed.toList());
      } else {
        _pagingController.appendLastPage(items);
      }
    }
    if (letterToSearch != null) {
      scrollToLetter(letterToSearch);
      timer?.cancel();
      timer = Timer(const Duration(seconds: 2, milliseconds: 500), () {
        scrollToNearbyLetter();
      });
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getPage(pageKey);
    });
    controller = ScrollController();
    _refreshStream = _isarDownloader.offlineDeletesStream.listen((event) {
      _pagingController.refresh();
    });
    super.initState();
  }

  // Scrolls the list to the first occurrence of the letter in the list
  // If clicked in the # element, it goes to the first one ( pixels = 0 )
  void scrollToLetter(String? clickedLetter) async {
    String? letter = clickedLetter ?? letterToSearch;
    if (letter == null) return;

    letterToSearch = letter;

    if (letter == '#') {
      double targetScroll = FinampSettingsHelper
                  .finampSettings.tabSortOrder[widget.tabContentType] ==
              SortOrder.ascending
          ? -(controller!.position.maxScrollExtent * 10)
          : controller!.position.maxScrollExtent * 10;

      await controller?.animateTo(targetScroll,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    } else {
      final indexWhere = _pagingController.itemList!.indexWhere((element) {
        final name = element.name!;
        final firstLetter =
            name.startsWith(RegExp(r'^the', caseSensitive: false))
                ? name.split(RegExp(r'^the', caseSensitive: false))[1].trim()[0]
                : name[0].toUpperCase();
        return firstLetter == letter;
      });

      if (indexWhere >= 0) {
        final scrollTo = (indexWhere * 72).toDouble();
        await controller?.animateTo(scrollTo,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
        letterToSearch = null;
      } else {
        await controller?.animateTo(controller!.position.maxScrollExtent * 100,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
      }
    }
  }

  void scrollToNearbyLetter() {
    if (letterToSearch != null) {
      const standardAlphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      final closestLetterIndex = standardAlphabet.indexOf(letterToSearch!);
      if (closestLetterIndex != -1) {
        for (int offset = 0; offset <= standardAlphabet.length; offset++) {
          for (final direction in [1, -1]) {
            final nextIndex = closestLetterIndex + offset * direction;
            if (nextIndex >= 0 && nextIndex < standardAlphabet.length) {
              final nextLetter = standardAlphabet[nextIndex];
              final nextLetterIndex =
                  _pagingController.itemList!.indexWhere((element) {
                final firstLetter = element.name![0].toUpperCase();
                return firstLetter == nextLetter;
              });

              if (nextLetterIndex >= 0) {
                final scrollTo = (nextLetterIndex * 72).toDouble();
                controller?.animateTo(scrollTo,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease);
                letterToSearch = null;
                return;
              }
            }
          }
        }
      }
    }
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
            // This makes refreshing actually work in error cases
            _pagingController.value =
                const PagingState(nextPageKey: 0, itemList: []);
            _pagingController.refresh();
            refreshHash = newRefreshHash;
          }

          return RefreshIndicator(
            onRefresh: () async {
              refreshCount++;
              // This makes refreshing actually work in error cases
              _pagingController.value =
                  const PagingState(nextPageKey: 0, itemList: []);
              _pagingController.refresh();
            },
            child: Scrollbar(
              controller: controller,
              child: Stack(
                children: [
                  box.get("FinampSettings")!.contentViewType ==
                              ContentViewType.list ||
                          widget.tabContentType == TabContentType.songs
                      ? PagedListView<int, BaseItemDto>.separated(
                          pagingController: _pagingController,
                          scrollController: controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          builderDelegate:
                              PagedChildBuilderDelegate<BaseItemDto>(
                            itemBuilder: (context, item, index) {
                              if (widget.tabContentType ==
                                  TabContentType.songs) {
                                return SongListTile(
                                  key: ValueKey(item.id),
                                  item: item,
                                  isSong: true,
                                );
                              } else {
                                return AlbumItem(
                                  key: ValueKey(item.id),
                                  album: item,
                                  isPlaylist: widget.tabContentType ==
                                      TabContentType.playlists,
                                );
                              }
                            },
                            firstPageProgressIndicatorBuilder: (_) =>
                                const FirstPageProgressIndicator(),
                            newPageProgressIndicatorBuilder: (_) =>
                                const NewPageProgressIndicator(),
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            height: widget.tabContentType ==
                                        TabContentType.artists ||
                                    widget.tabContentType ==
                                        TabContentType.genres
                                ? 16.0
                                : 0.0,
                          ),
                        )
                      : PagedGridView(
                          pagingController: _pagingController,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          scrollController: controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          builderDelegate:
                              PagedChildBuilderDelegate<BaseItemDto>(
                            itemBuilder: (context, item, index) {
                              return AlbumItem(
                                key: ValueKey(item.id),
                                album: item,
                                isPlaylist: widget.tabContentType ==
                                    TabContentType.playlists,
                                isGrid: true,
                                gridAddSettingsListener: false,
                              );
                            },
                            firstPageProgressIndicatorBuilder: (_) =>
                                const FirstPageProgressIndicator(),
                            newPageProgressIndicatorBuilder: (_) =>
                                const NewPageProgressIndicator(),
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width >
                                    MediaQuery.of(context).size.height
                                ? box
                                    .get("FinampSettings")!
                                    .contentGridViewCrossAxisCountLandscape
                                : box
                                    .get("FinampSettings")!
                                    .contentGridViewCrossAxisCountPortrait,
                          ),
                        ),
                  box.get("FinampSettings")!.showFastScroller &&
                          settings.tabSortBy[widget.tabContentType] ==
                              SortBy.sortName
                      ? AlphabetList(
                          callback: scrollToLetter,
                          sortOrder:
                              settings.tabSortOrder[widget.tabContentType] ??
                                  SortOrder.ascending)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        });
  }
}
