import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../models/JellyfinModels.dart';
import '../../models/FinampModels.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/FinampSettingsHelper.dart';
import '../../services/DownloadsHelper.dart';
import '../../components/AlbumScreen/SongListTile.dart';
import '../errorSnackbar.dart';
import 'AlbumListTile.dart';

enum TabContentType { songs, albums, artists, genres, playlists }

class MusicScreenTabView extends StatefulWidget {
  const MusicScreenTabView({
    Key? key,
    required this.tabContentType,
    this.parentItem,
    this.searchTerm,
  }) : super(key: key);

  final TabContentType tabContentType;
  final BaseItemDto? parentItem;
  final String? searchTerm;

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

  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  Future<List<BaseItemDto>?>? albumViewFuture;
  String? lastSearch;

  // This function just lets us easily set stuff to the getItems call we want.
  Future<List<BaseItemDto>?> _setFuture() {
    lastSearch = widget.searchTerm;
    return jellyfinApiData.getItems(
      // If no parent item is specified, we should set the whole music library as the parent item (for getting all albums/playlists)
      parentItem: widget.parentItem ?? jellyfinApiData.currentUser!.view!,

      includeItemTypes: _includeItemTypes(widget.tabContentType),

      // If we're on the songs tab, sort by "Album,SortName". This is what the
      // Jellyfin web client does. If this isn't the case, check if parentItem
      // is null. parentItem will be null when this widget is not used in an
      // artist view. If it's null, sort by "SortName". If it isn't null, check
      // if the parentItem is a MusicArtist. If it is, sort by year. Otherwise,
      // sort by SortName.
      sortBy: widget.tabContentType == TabContentType.songs
          ? "Album,SortName"
          : widget.parentItem == null
              ? "SortName"
              : widget.parentItem!.type == "MusicArtist"
                  ? "ProductionYear"
                  : "SortName",
      searchTerm: widget.searchTerm,
    );
  }

  String _getParentType() =>
      widget.parentItem?.type! ?? jellyfinApiData.currentUser!.view!.type!;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, _) {
        bool isOffline = box.get("FinampSettings")?.isOffline ?? false;

        if (isOffline) {
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
                  Padding(padding: const EdgeInsets.all(8.0)),
                  Text("Offline artists view hasn't been implemented")
                ],
              ),
            );
          }

          List<BaseItemDto> sortedItems;

          if (widget.searchTerm == null) {
            if (widget.tabContentType == TabContentType.songs) {
              // If we're on the songs tab, just get all of the downloaded items
              sortedItems =
                  downloadsHelper.downloadedItems.map((e) => e.song).toList();
            } else {
              sortedItems = downloadsHelper.downloadedParents
                  .where(
                    (element) =>
                        element.item.type ==
                        _includeItemTypes(widget.tabContentType),
                  )
                  .map((e) => e.item)
                  .toList();
            }
          } else {
            sortedItems = downloadsHelper.downloadedParents
                .where(
                  (element) {
                    late bool containsName;

                    // This horrible thing is for null safety
                    if (element.item.name == null) {
                      containsName = false;
                    } else {
                      element.item.name!
                          .toLowerCase()
                          .contains(widget.searchTerm!.toLowerCase());
                    }

                    return element.item.type ==
                            _includeItemTypes(widget.tabContentType) &&
                        containsName;
                  },
                )
                .map((e) => e.item)
                .toList();
          }

          sortedItems.sort((a, b) {
            if (a.name == null || b.name == null) {
              // Returning 0 is the same as both being the same
              return 0;
            } else {
              return a.name!.compareTo(b.name!);
            }
          });

          return AlbumList(
            items: sortedItems,
            parentType: _getParentType(),
            tabContentType: widget.tabContentType,
            isOffline: isOffline,
          );
        } else {
          // If the searchTerm argument is different to lastSearch, the user has changed their search input.
          // This makes albumViewFuture search again so that results with the search are shown.
          // This also means we don't redo a search unless we actaully need to.
          if (widget.searchTerm != lastSearch || albumViewFuture == null) {
            albumViewFuture = _setFuture();
          }

          return FutureBuilder<List<BaseItemDto>?>(
            future: albumViewFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      albumViewFuture = _setFuture();
                    });
                    // RefreshIndicator is picky about what type of future it
                    // has for some reason.
                    return albumViewFuture as Future<void>;
                  },
                  child: AlbumList(
                    items: snapshot.data!,
                    parentType: _getParentType(),
                    tabContentType: widget.tabContentType,
                    isOffline: isOffline,
                  ),
                );
              } else if (snapshot.hasError) {
                errorSnackbar(snapshot.error, context);
                return Center(
                  child: Icon(Icons.error, size: 64),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        }
      },
    );
  }
}

class AlbumList extends StatelessWidget {
  const AlbumList({
    Key? key,
    required this.items,

    /// parentType is used when deciding what to use as the subtitle text on AlbumListTiles.
    /// It is usually passed from AlbumScreenTabView, which gets it from the _getParentType() method.
    required this.parentType,
    required this.tabContentType,

    /// If offline, we don't need to have AlwaysScrollableScrollPhysics for
    /// pull-to-refresh.
    required this.isOffline,
  }) : super(key: key);

  final List<BaseItemDto> items;
  final String parentType;
  final TabContentType tabContentType;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        // We need AlwaysScrollableScrollPhysics for pull-to-refresh
        physics: isOffline ? null : const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: items.length,
        itemBuilder: (context, index) {
          if (tabContentType == TabContentType.songs) {
            return SongListTile(
              item: items[index],
              children: items,
              index: index,
              isSong: true,
            );
          }

          return AlbumListTile(
            album: items[index],
            parentType: parentType,
          );
        },
      ),
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
      throw UnimplementedError("Genre view hasn't been added yet");
    case TabContentType.playlists:
      return "Playlist";
    default:
      throw FormatException("Unsupported TabContentType");
  }
}
