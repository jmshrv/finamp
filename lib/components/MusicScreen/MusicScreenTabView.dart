import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../models/JellyfinModels.dart';
import '../../models/FinampModels.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/FinampSettingsHelper.dart';
import '../../services/processArtist.dart';
import '../../services/processProductionYear.dart';
import '../../services/DownloadsHelper.dart';
import '../AlbumImage.dart';
import '../errorSnackbar.dart';

enum TabContentType { songs, albums, artists, genres, playlists }

class MusicScreenTabView extends StatefulWidget {
  const MusicScreenTabView(
      {Key key,
      @required this.tabContentType,
      this.parentItem,
      this.searchTerm})
      : super(key: key);

  final TabContentType tabContentType;
  final BaseItemDto parentItem;
  final String searchTerm;

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
  Future albumViewFuture;
  String lastSearch;

  // This function just lets us easily set stuff to the getItems call we want.
  Future _setFuture() {
    lastSearch = widget.searchTerm;
    return jellyfinApiData.getItems(
      // If no parent item is specified, we should set the whole music library as the parent item (for getting all albums/playlists)
      parentItem: widget.parentItem == null
          ? jellyfinApiData.currentUser.view
          : widget.parentItem,
      includeItemTypes: _includeItemTypes(widget.tabContentType),
      sortBy: widget.parentItem == null
          ? "SortName"
          : widget.parentItem.type == "MusicArtist"
              ? "ProductionYear"
              : "SortName",
      searchTerm: widget.searchTerm,
    );
  }

  String _getParentType() => widget.parentItem == null
      ? jellyfinApiData.currentUser.view.type
      : widget.parentItem.type;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, _) {
        bool isOffline = box.get("FinampSettings").isOffline;

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
            sortedItems = downloadsHelper.downloadedParents
                .where(
                  (element) =>
                      element.item.type ==
                      _includeItemTypes(widget.tabContentType),
                )
                .map((e) => e.item)
                .toList();
          } else {
            sortedItems = downloadsHelper.downloadedParents
                .where(
                  (element) =>
                      element.item.type ==
                          _includeItemTypes(widget.tabContentType) &&
                      element.item.name
                          .toLowerCase()
                          .contains(widget.searchTerm.toLowerCase()),
                )
                .map((e) => e.item)
                .toList();
          }

          sortedItems.sort((a, b) => a.name.compareTo(b.name));

          return AlbumList(
            items: sortedItems,
            parentType: _getParentType(),
          );
        } else {
          // If the searchTerm argument is different to lastSearch, the user has changed their search input.
          // This makes albumViewFuture search again so that results with the search are shown.
          // This also means we don't redo a search unless we actaully need to.
          if (widget.searchTerm != lastSearch || albumViewFuture == null) {
            albumViewFuture = _setFuture();
          }

          return FutureBuilder<List<BaseItemDto>>(
            future: albumViewFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AlbumList(
                  items: snapshot.data,
                  parentType: _getParentType(),
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
    Key key,
    @required this.items,

    /// parentType is used when deciding what to use as the subtitle text on AlbumListTiles.
    /// It is usually passed from AlbumScreenTabView, which gets it from the _getParentType() method.
    @required this.parentType,
  }) : super(key: key);

  final List<BaseItemDto> items;
  final String parentType;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: items.length,
        itemBuilder: (context, index) {
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
      break;
    case TabContentType.albums:
      return "MusicAlbum";
      break;
    case TabContentType.artists:
      return "MusicArtist";
      break;
    case TabContentType.genres:
      throw UnimplementedError("Genre view hasn't been added yet");
    case TabContentType.playlists:
      return "Playlist";
      break;
    default:
      throw FormatException("Unsupported TabContentType");
  }
}

class AlbumListTile extends StatelessWidget {
  const AlbumListTile(
      {Key key, @required this.album, @required this.parentType})
      : super(key: key);

  final BaseItemDto album;
  final String parentType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (album.type == "MusicArtist") {
          Navigator.of(context)
              .pushNamed("/music/artistscreen", arguments: album);
        } else {
          Navigator.of(context)
              .pushNamed("/music/albumscreen", arguments: album);
        }
      },
      leading: AlbumImage(itemId: album.id),
      title: Text(
        album.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: _generateSubtitle(album, parentType),
    );
  }

  Widget _generateSubtitle(BaseItemDto item, String parentType) {
    // TODO: Make it so that album subtitle on the artist screen isn't the artist's name (maybe something like the number of songs in the album)

    // If the parentType is MusicArtist, this is being called by an AlbumListTile in an AlbumView of an artist.
    if (parentType == "MusicArtist") {
      return Text(processProductionYear(item.productionYear));
    }

    switch (item.type) {
      case "MusicAlbum":
        return Text(processArtist(item.albumArtist));
        break;
      case "Playlist":
        return Text("${item.childCount} Songs");
        break;
      default:
        return null;
    }
  }
}
