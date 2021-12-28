import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/JellyfinModels.dart';
import '../../models/FinampModels.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/FinampSettingsHelper.dart';
import '../../services/DownloadsHelper.dart';
import '../../components/AlbumScreen/SongListTile.dart';
import '../FirstPageProgressIndicator.dart';
import '../NewPageProgressIndicator.dart';
import '../errorSnackbar.dart';
import 'AlbumItem.dart';

class MusicScreenTabView extends StatefulWidget {
  const MusicScreenTabView({
    Key? key,
    required this.tabContentType,
    this.parentItem,
    this.searchTerm,
    required this.isFavourite,
    this.sortBy,
    this.sortOrder,
    this.view,
  }) : super(key: key);

  final TabContentType tabContentType;
  final BaseItemDto? parentItem;
  final String? searchTerm;
  final bool isFavourite;
  final SortBy? sortBy;
  final SortOrder? sortOrder;
  final BaseItemDto? view;

  @override
  _MusicScreenTabViewState createState() => _MusicScreenTabViewState();
}

// We use AutomaticKeepAliveClientMixin so that the view keeps its position after the tab is changed.
// https://stackoverflow.com/questions/49439047/how-to-preserve-widget-states-in-flutter-when-navigating-using-bottomnavigation
class _MusicScreenTabViewState extends State<MusicScreenTabView>
    with AutomaticKeepAliveClientMixin<MusicScreenTabView> {
  // If parentItem is null, we assume that this view is actually in a tab.
  // If it isn't null, this view is being used as an artist detail screen and shouldn't be kept alive.
  @override
  bool get wantKeepAlive => widget.parentItem == null;

  static const _pageSize = 100;

  final PagingController<int, BaseItemDto> _pagingController =
      PagingController(firstPageKey: 0);

  List<BaseItemDto>? offlineSortedItems;

  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  String? lastSearch;
  bool? oldIsFavourite;
  SortBy? oldSortBy;
  SortOrder? oldSortOrder;
  BaseItemDto? oldView;

  // This function just lets us easily set stuff to the getItems call we want.
  Future<void> _getPage(int pageKey) async {
    try {
      final newItems = await jellyfinApiData.getItems(
        // If no parent item is specified, we try the view given as an argument.
        // If the view argument is null, fall back to the user's current view.
        parentItem: widget.parentItem ??
            widget.view ??
            jellyfinApiData.currentUser?.currentView,
        includeItemTypes: _includeItemTypes(widget.tabContentType),

        // If we're on the songs tab, sort by "Album,SortName". This is what the
        // Jellyfin web client does. If this isn't the case, check if parentItem
        // is null. parentItem will be null when this widget is not used in an
        // artist view. If it's null, sort by "SortName". If it isn't null, check
        // if the parentItem is a MusicArtist. If it is, sort by year. Otherwise,
        // sort by SortName. If widget.sortBy is set, it is used instead.
        sortBy: widget.sortBy?.jellyfinName == null
            ? widget.tabContentType == TabContentType.songs
                ? "Album,SortName"
                : widget.parentItem == null
                    ? "SortName"
                    : widget.parentItem?.type == "MusicArtist"
                        ? "ProductionYear"
                        : "SortName"
            : widget.sortBy?.jellyfinName,
        sortOrder: widget.sortOrder?.humanReadableName ??
            SortOrder.ascending.humanReadableName,
        searchTerm: widget.searchTerm,
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
    } catch (e) {
      errorSnackbar(e, context);
    }
  }

  String _getParentType() =>
      widget.parentItem?.type! ??
      jellyfinApiData.currentUser!.currentView!.type!;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, _) {
        final isOffline = box.get("FinampSettings")?.isOffline ?? false;

        if (isOffline) {
          // We do the same checks we do when online to ensure that the list is
          // not resorted when it doesn't have to be.
          if (widget.searchTerm != lastSearch ||
              offlineSortedItems == null ||
              widget.isFavourite != oldIsFavourite ||
              widget.sortBy != oldSortBy ||
              widget.sortOrder != oldSortOrder ||
              widget.view != oldView) {
            lastSearch = widget.searchTerm;
            oldIsFavourite = widget.isFavourite;
            oldSortBy = widget.sortBy;
            oldSortOrder = widget.sortOrder;
            oldView = widget.view;

            DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();

            if (widget.tabContentType == TabContentType.artists) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 64,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    const Text("Offline artists view hasn't been implemented")
                  ],
                ),
              );
            }

            if (widget.searchTerm == null) {
              if (widget.tabContentType == TabContentType.songs) {
                // If we're on the songs tab, just get all of the downloaded items
                offlineSortedItems = downloadsHelper.downloadedItems
                    .where((element) =>
                        element.viewId ==
                        jellyfinApiData.currentUser!.currentViewId)
                    .map((e) => e.song)
                    .toList();
              } else {
                offlineSortedItems = downloadsHelper.downloadedParents
                    .where((element) =>
                        element.item.type ==
                            _includeItemTypes(widget.tabContentType) &&
                        element.viewId ==
                            jellyfinApiData.currentUser!.currentViewId)
                    .map((e) => e.item)
                    .toList();
              }
            } else {
              if (widget.tabContentType == TabContentType.songs) {
                offlineSortedItems = downloadsHelper.downloadedItems
                    .where(
                      (element) {
                        return _offlineSearch(
                            item: element.song,
                            searchTerm: widget.searchTerm!,
                            tabContentType: widget.tabContentType);
                      },
                    )
                    .map((e) => e.song)
                    .toList();
              } else {
                offlineSortedItems = downloadsHelper.downloadedParents
                    .where(
                      (element) {
                        return _offlineSearch(
                            item: element.item,
                            searchTerm: widget.searchTerm!,
                            tabContentType: widget.tabContentType);
                      },
                    )
                    .map((e) => e.item)
                    .toList();
              }
            }

            offlineSortedItems!.sort((a, b) {
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
              offlineSortedItems = offlineSortedItems!.reversed.toList();
            }
          }

          return Scrollbar(
              child: box.get("FinampSettings")!.contentViewType ==
                      ContentViewType.list
                  ? ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: offlineSortedItems!.length,
                      key: UniqueKey(),
                      itemBuilder: (context, index) {
                        if (widget.tabContentType == TabContentType.songs) {
                          return SongListTile(
                            item: offlineSortedItems![index],
                            isSong: true,
                          );
                        } else {
                          return AlbumItem(
                            album: offlineSortedItems![index],
                            parentType: _getParentType(),
                          );
                        }
                      },
                    )
                  : GridView.builder(
                      itemCount: offlineSortedItems!.length,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
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
                      itemBuilder: (context, index) {
                        if (widget.tabContentType == TabContentType.songs) {
                          return SongListTile(
                            item: offlineSortedItems![index],
                            isSong: true,
                          );
                        } else {
                          return AlbumItem(
                            album: offlineSortedItems![index],
                            parentType: _getParentType(),
                            isGrid: true,
                            gridAddSettingsListener: false,
                          );
                        }
                      },
                    ));
        } else {
          // If the searchTerm argument is different to lastSearch, the user has changed their search input.
          // This makes albumViewFuture search again so that results with the search are shown.
          // This also means we don't redo a search unless we actaully need to.
          if (widget.searchTerm != lastSearch ||
              _pagingController.itemList == null ||
              widget.isFavourite != oldIsFavourite ||
              widget.sortBy != oldSortBy ||
              widget.sortOrder != oldSortOrder ||
              widget.view != oldView) {
            lastSearch = widget.searchTerm;
            oldIsFavourite = widget.isFavourite;
            oldSortBy = widget.sortBy;
            oldSortOrder = widget.sortOrder;
            oldView = widget.view;
            _pagingController.refresh();
          }

          return RefreshIndicator(
            // RefreshIndicator wants an async function, so we use Future.sync()
            // to run refresh() inside an async function
            onRefresh: () => Future.sync(() => _pagingController.refresh()),
            child: Scrollbar(
              child: box.get("FinampSettings")!.contentViewType ==
                      ContentViewType.list
                  ? PagedListView<int, BaseItemDto>(
                      pagingController: _pagingController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      builderDelegate: PagedChildBuilderDelegate<BaseItemDto>(
                        itemBuilder: (context, item, index) {
                          if (widget.tabContentType == TabContentType.songs) {
                            return SongListTile(
                              item: item,
                              isSong: true,
                            );
                          } else {
                            return AlbumItem(
                              album: item,
                              parentType: _getParentType(),
                            );
                          }
                        },
                        firstPageProgressIndicatorBuilder: (_) =>
                            const FirstPageProgressIndicator(),
                        newPageProgressIndicatorBuilder: (_) =>
                            const NewPageProgressIndicator(),
                      ),
                    )
                  : PagedGridView(
                      pagingController: _pagingController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      builderDelegate: PagedChildBuilderDelegate<BaseItemDto>(
                        itemBuilder: (context, item, index) {
                          if (widget.tabContentType == TabContentType.songs) {
                            return SongListTile(
                              item: item,
                              isSong: true,
                            );
                          } else {
                            return AlbumItem(
                              album: item,
                              parentType: _getParentType(),
                              isGrid: true,
                              gridAddSettingsListener: false,
                            );
                          }
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
                    ),
            ),
          );
        }
      },
    );
  }
}

String _includeItemTypes(TabContentType tabContentType) {
  switch (tabContentType) {
    case TabContentType.songs:
      return "Audio";
    case TabContentType.albums:
      return "MusicAlbum";
    case TabContentType.artists:
      return "MusicArtist";
    case TabContentType.genres:
      return "MusicGenre";
    case TabContentType.playlists:
      return "Playlist";
    default:
      throw const FormatException("Unsupported TabContentType");
  }
}

bool _offlineSearch(
    {required BaseItemDto item,
    required String searchTerm,
    required TabContentType tabContentType}) {
  late bool containsName;

  // This horrible thing is for null safety
  if (item.name == null) {
    containsName = false;
  } else {
    containsName = item.name!.toLowerCase().contains(searchTerm.toLowerCase());
  }

  return item.type == _includeItemTypes(tabContentType) && containsName;
}
