import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/processArtist.dart';
import '../AlbumImage.dart';
import '../errorSnackbar.dart';

enum TabContentType { songs, albums, artists, genres, playlists }

class MusicScreenTabView extends StatefulWidget {
  const MusicScreenTabView({Key key, @required this.tabContentType})
      : super(key: key);

  final TabContentType tabContentType;

  @override
  _MusicScreenTabViewState createState() => _MusicScreenTabViewState();
}

// We use AutomaticKeepAliveClientMixin so that the view keeps its position after the tab is changed.
// https://stackoverflow.com/questions/49439047/how-to-preserve-widget-states-in-flutter-when-navigating-using-bottomnavigation
class _MusicScreenTabViewState extends State<MusicScreenTabView>
    with AutomaticKeepAliveClientMixin<MusicScreenTabView> {
  @override
  bool get wantKeepAlive => true;

  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  Future albumViewFuture;

  @override
  void initState() {
    super.initState();
    jellyfinApiData.getView().then((view) {
      albumViewFuture = jellyfinApiData.getItems(
          parentItem: view,
          includeItemTypes: _includeItemTypes(widget.tabContentType),
          sortBy: "SortName");

      // We need to run setState to rebuild the widget with this new data
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      throw UnimplementedError("Artist view hasn't been added yet");
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
      onTap: () => Navigator.of(context)
          .pushNamed("/music/albumscreen", arguments: album),
      leading: AlbumImage(itemId: album.id),
      title: Text(
        album.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(processArtist(album.albumArtist)),
    );
  }
}
