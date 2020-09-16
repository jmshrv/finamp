import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/JellyfinApi.dart';
import '../../models/JellyfinModels.dart';

class AlbumView extends StatefulWidget {
  const AlbumView({Key key}) : super(key: key);

  @override
  _AlbumViewState createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  Future albumViewFuture;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiProvider = Provider.of<JellyfinApi>(context);

    // Since jellyfinApiProvider has to be defined inside build(), we can't call getAlbums() in initState.
    // I've done this so that we don't have to put getAlbums() directly in the FutureBuilder (if we do this, it will call getAlbums() every rebuild).
    // Basically, albumViewFuture is initially null. If it is null, we set it to getAlbums(). Since albumViewFuture is outside of build(), it will not clear on rebuild.
    if (albumViewFuture == null) {
      albumViewFuture = jellyfinApiProvider.getAlbums();
    }

    return FutureBuilder(
      future: albumViewFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.items.length,
            itemBuilder: (context, index) {
              BaseItemDto album = snapshot.data.items[index];

              return AlbumListTile(album: album);
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class AlbumListTile extends StatelessWidget {
  const AlbumListTile({
    Key key,
    @required this.album,
  }) : super(key: key);

  final BaseItemDto album;

  String _processArtist(BaseItemDto item) {
    {
      if (item.albumArtist == null) {
        return "Unknown Artist";
      } else {
        return item.albumArtist;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final jellyfinApiProvider = Provider.of<JellyfinApi>(context);

    return ListTile(
      onTap: () {},
      leading: AspectRatio(
        aspectRatio: 1 / 1,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: jellyfinApiProvider.getAlbumPrimaryImage(),
        ),
      ),
      title: Text(
        album.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(_processArtist(album)),
    );
  }
}
