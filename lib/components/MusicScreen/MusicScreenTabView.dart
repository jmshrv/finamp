import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/processArtist.dart';
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
      sortBy: "SortName",
      searchTerm: widget.searchTerm,
    );
  }

  @override
  void initState() {
    super.initState();
    albumViewFuture = _setFuture();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // If the searchTerm argument is different to lastSearch, the user has changed their search input.
    // This makes albumViewFuture search again so that results with the search are shown.
    // This also means we don't redo a search unless we actaully need to.
    if (widget.searchTerm != lastSearch) {
      albumViewFuture = _setFuture();
    }

    return FutureBuilder(
      future: albumViewFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scrollbar(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                BaseItemDto album = snapshot.data[index];

                return AlbumListTile(album: album);
              },
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
  const AlbumListTile({Key key, @required this.album}) : super(key: key);

  final BaseItemDto album;

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
      subtitle: _generateSubtitle(album),
    );
  }

  Widget _generateSubtitle(BaseItemDto item) {
    // TODO: Make it so that album subtitle on the artist screen isn't the artist's name (maybe something like the number of songs in the album)
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
