import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliver_fab/sliver_fab.dart';

import '../../models/JellyfinModels.dart';
import '../../services/JellyfinApiData.dart';
import '../../components/BlurredImage.dart';

class AlbumScreenContent extends StatefulWidget {
  const AlbumScreenContent({Key key, @required this.album}) : super(key: key);

  final BaseItemDto album;

  @override
  _AlbumScreenContentState createState() => _AlbumScreenContentState();
}

class _AlbumScreenContentState extends State<AlbumScreenContent> {
  Future albumScreenContentFuture;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  @override
  void initState() {
    super.initState();
    albumScreenContentFuture =
        jellyfinApiData.getAlbumPrimaryImage(widget.album);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: albumScreenContentFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverFab(
            floatingWidget: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.play_arrow),
            ),
            expandedHeight: MediaQuery.of(context).size.height / 3,
            slivers: [
              AlbumSliverAppBar(
                album: widget.album,
                imageBytes: snapshot.data,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
                ListTile(title: Text("Hello")),
              ]))
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class AlbumSliverAppBar extends StatelessWidget {
  const AlbumSliverAppBar({Key key, @required this.album, this.imageBytes})
      : super(key: key);

  final BaseItemDto album;
  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height / 3,
      flexibleSpace: FlexibleSpaceBar(
        background: BlurredImage(MemoryImage(imageBytes)),
        title: Text(album.name),
      ),
    );
  }
}
