import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
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
    Key? key,
    required this.tabContentType,
    this.searchTerm,
    required this.isFavourite,
    this.sortBy,
    this.sortOrder,
    required this.view,
  }) : super(key: key);

  final TabContentType tabContentType;
  final String? searchTerm;
  final bool isFavourite;
  final SortBy? sortBy;
  final SortOrder? sortOrder;
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

  String? _lastSearch;
  bool? _lastFullyDownloaded;
  bool? _oldIsFavourite;
  SortBy? _oldSortBy;
  SortOrder? _oldSortOrder;
  BaseItemDto? _oldView;
  ScrollController? controller;
  String? letterToSearch;
  String lastSortOrder = SortOrder.ascending.toString();
  Timer? timer;
  bool oldIsOffline = true;

  // This function just lets us easily set stuff to the getItems call we want.
  Future<void> _getPage(int pageKey) async {
    try {
      final sortOrder =
          widget.sortOrder?.toString() ?? SortOrder.ascending.toString();
      final newItems = await _jellyfinApiHelper.getItems(
        parentItem: widget.view,
        includeItemTypes: widget.tabContentType.itemType.idString,

        // If we're on the songs tab, sort by "Album,SortName". This is what the
        // Jellyfin web client does. If this isn't the case, sort by "SortName".
        // If widget.sortBy is set, it is used instead.
        sortBy: widget.sortBy?.jellyfinName(widget.tabContentType) ??
            (widget.tabContentType == TabContentType.songs
                ? "Album,SortName"
                : "SortName"),
        sortOrder: sortOrder,
        searchTerm: widget.searchTerm?.trim(),
        // If this is the genres tab, tell getItems to get genres.
        isGenres: widget.tabContentType == TabContentType.genres,
        filters: widget.isFavourite ? "IsFavorite" : null,
        startIndex: pageKey,
        limit: _pageSize,
      );

      if (newItems!.length < _pageSize) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, pageKey + newItems.length);
      }
      if (letterToSearch != null) {
        scrollToLetter(letterToSearch);
        timer?.cancel();
        timer = Timer(const Duration(seconds: 2, milliseconds: 500), () {
          scrollToNearbyLetter();
        });
      }
      setState(() {
        lastSortOrder = sortOrder;
      });
    } catch (e) {
      GlobalSnackbar.error(e);
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getPage(pageKey);
    });
    lastSortOrder =
        widget.sortOrder?.toString() ?? SortOrder.ascending.toString();
    controller = ScrollController();
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    setState(() {
      lastSortOrder =
          widget.sortOrder?.toString() ?? SortOrder.ascending.toString();
    });
    super.didUpdateWidget(oldWidget);
  }

  // Scrolls the list to the first occurrence of the letter in the list
  // If clicked in the # element, it goes to the first one ( pixels = 0 )
  void scrollToLetter(String? clickedLetter) async {
    String? letter = clickedLetter ?? letterToSearch;
    if (letter == null) return;

    letterToSearch = letter;

    if (letter == '#') {
      double targetScroll = lastSortOrder == SortOrder.ascending.toString()
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
        final isOffline = box.get("FinampSettings")?.isOffline ?? false;
        final onlyShowFullyDownloaded =
            box.get("FinampSettings")?.onlyShowFullyDownloaded ?? false;
        if (isOffline && !oldIsOffline) {
          offlineSortedItems = null;
        }
        oldIsOffline = isOffline;

        if (isOffline) {
          // We do the same checks we do when online to ensure that the list is
          // not resorted when it doesn't have to be.
          if (widget.searchTerm != _lastSearch ||
              offlineSortedItems == null ||
              widget.isFavourite != _oldIsFavourite ||
              widget.sortBy != _oldSortBy ||
              widget.sortOrder != _oldSortOrder ||
              widget.view != _oldView ||
              onlyShowFullyDownloaded != _lastFullyDownloaded) {
            _lastSearch = widget.searchTerm;
            _oldIsFavourite = widget.isFavourite;
            _oldSortBy = widget.sortBy;
            _oldSortOrder = widget.sortOrder;
            _oldView = widget.view;
            _lastFullyDownloaded = onlyShowFullyDownloaded;

            final isarDownloader = GetIt.instance<IsarDownloads>();

            // TODO refactor into a stream listener or something - we can only delete, not important?
            // TODO think about artists - what happens if one artist is in multiple libraries
            // TODO should we try to not load every item in all tabs?
            offlineSortedItems = Future.sync(() async {
              List<DownloadStub> offlineItems;
              if (widget.tabContentType == TabContentType.songs) {
                // If we're on the songs tab, just get all of the downloaded items
                offlineItems = await isarDownloader.getAllSongs(
                    nameFilter: widget.searchTerm, viewFilter: widget.view?.id);
              } else {
                offlineItems = await isarDownloader.getAllCollections(
                    nameFilter: widget.searchTerm,
                    baseTypeFilter: widget.tabContentType.itemType,
                    fullyDownloaded: onlyShowFullyDownloaded,
                    viewFilter:
                        widget.tabContentType == TabContentType.playlists
                            ? null
                            : widget.view?.id);
              }

              var items =
                  offlineItems.map((e) => e.baseItem).whereNotNull().toList();
              items.sort((a, b) {
                // if (a.name == null || b.name == null) {
                //   // Returning 0 is the same as both being the same
                //   return 0;
                // } else {
                //   return a.name!.compareTo(b.name!);
                // }
                if (a.name == null || b.name == null) {
                  // Returning 0 is the same as both being the same
                  return 0;
                } else {
                  switch (widget.sortBy) {
                    case SortBy.sortName:
                      if (a.name == null || b.name == null) {
                        // Returning 0 is the same as both being the same
                        return 0;
                      } else {
                        return a.name!.compareTo(b.name!);
                      }
                    case SortBy.albumArtist:
                      if (a.albumArtist == null || b.albumArtist == null) {
                        return 0;
                      } else {
                        return a.albumArtist!.compareTo(b.albumArtist!);
                      }
                    case SortBy.communityRating:
                      if (a.communityRating == null ||
                          b.communityRating == null) {
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
                          "Unimplemented offline sort mode ${widget.sortBy}");
                  }
                }
              });
              if (widget.sortOrder == SortOrder.descending) {
                // The above sort functions sort in ascending order, so we swap them
                // when sorting in descending order.
                return items.reversed.toList();
              }
              return items;
            });
          }

          return Scrollbar(
            controller: controller,
            child: Stack(
              children: [
                box.get("FinampSettings")!.contentViewType ==
                            ContentViewType.list ||
                        widget.tabContentType == TabContentType.songs
                    ? FutureBuilder(
                        future: offlineSortedItems,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: snapshot.data!.length,
                              key: UniqueKey(),
                              controller: controller,
                              itemBuilder: (context, index) {
                                if (widget.tabContentType ==
                                    TabContentType.songs) {
                                  return SongListTile(
                                    item: snapshot.data![index],
                                    isSong: true,
                                  );
                                } else {
                                  return AlbumItem(
                                    album: snapshot.data![index],
                                    isPlaylist: widget.tabContentType ==
                                        TabContentType.playlists,
                                  );
                                }
                              },
                            );
                          } else {
                            return const FirstPageProgressIndicator();
                          }
                        })
                    : FutureBuilder(
                        future: offlineSortedItems,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GridView.builder(
                              itemCount: snapshot.data!.length,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              controller: controller,
                              key: UniqueKey(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: MediaQuery.of(context)
                                            .size
                                            .width >
                                        MediaQuery.of(context).size.height
                                    ? box
                                        .get("FinampSettings")!
                                        .contentGridViewCrossAxisCountLandscape
                                    : box
                                        .get("FinampSettings")!
                                        .contentGridViewCrossAxisCountPortrait,
                              ),
                              itemBuilder: (context, index) {
                                return AlbumItem(
                                  album: snapshot.data![index],
                                  isPlaylist: widget.tabContentType ==
                                      TabContentType.playlists,
                                  isGrid: true,
                                  gridAddSettingsListener: false,
                                );
                              },
                            );
                          } else {
                            return const FirstPageProgressIndicator();
                          }
                        }),
                box.get("FinampSettings")!.showFastScroller &&
                        widget.sortBy == SortBy.sortName
                    ? AlphabetList(
                        callback: scrollToLetter, sortOrder: lastSortOrder)
                    : const SizedBox.shrink(),
              ],
            ),
          );
        } else {
          // If the searchTerm argument is different to lastSearch, the user has changed their search input.
          // This makes albumViewFuture search again so that results with the search are shown.
          // This also means we don't redo a search unless we actaully need to.
          if (widget.searchTerm != _lastSearch ||
              _pagingController.itemList == null ||
              widget.isFavourite != _oldIsFavourite ||
              widget.sortBy != _oldSortBy ||
              widget.sortOrder != _oldSortOrder ||
              widget.view != _oldView) {
            _lastSearch = widget.searchTerm;
            _oldIsFavourite = widget.isFavourite;
            _oldSortBy = widget.sortBy;
            _oldSortOrder = widget.sortOrder;
            _oldView = widget.view;
            _pagingController.refresh();
          }

          return RefreshIndicator(
            // RefreshIndicator wants an async function, so we use Future.sync()
            // to run refresh() inside an async function
            onRefresh: () => Future.sync(() => _pagingController.refresh()),
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
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          builderDelegate:
                              PagedChildBuilderDelegate<BaseItemDto>(
                            itemBuilder: (context, item, index) {
                              if (widget.tabContentType ==
                                  TabContentType.songs) {
                                return SongListTile(
                                  item: item,
                                  isSong: true,
                                );
                              } else {
                                return AlbumItem(
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
                          builderDelegate:
                              PagedChildBuilderDelegate<BaseItemDto>(
                            itemBuilder: (context, item, index) {
                              return AlbumItem(
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
                          widget.sortBy == SortBy.sortName
                      ? AlphabetList(
                          callback: scrollToLetter, sortOrder: lastSortOrder)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
