import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/JellyfinApiData.dart';

class AlbumView extends StatefulWidget {
  const AlbumView({Key key}) : super(key: key);

  @override
  _AlbumViewState createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  Future albumViewFuture;

  @override
  void initState() {
    super.initState();
    jellyfinApiData.getView().then((view) {
      albumViewFuture = jellyfinApiData.getItems(
          parentItem: view, includeItemTypes: "MusicAlbum", sortBy: "SortName");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: albumViewFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              BaseItemDto album = snapshot.data[index];

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

class AlbumListTile extends StatefulWidget {
  const AlbumListTile({
    Key key,
    @required this.album,
  }) : super(key: key);

  final BaseItemDto album;

  @override
  _AlbumListTileState createState() => _AlbumListTileState();
}

class _AlbumListTileState extends State<AlbumListTile> {
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  Future albumListTileFuture;

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
  void initState() {
    super.initState();
    albumListTileFuture = jellyfinApiData.getAlbumPrimaryImage(widget.album);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .pushNamed("/music/albumscreen", arguments: widget.album),
      leading: AspectRatio(
        aspectRatio: 1 / 1,
        child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: FutureBuilder<Uint8List>(
              future: albumListTileFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(snapshot.data);
                } else if (snapshot.hasError) {
                  return Icon(Icons.album);
                } else {
                  return Container();
                }
              },
            )),
      ),
      title: Text(
        widget.album.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(_processArtist(widget.album)),
    );
  }
}
