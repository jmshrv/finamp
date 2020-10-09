import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sliver_fab/sliver_fab.dart';

import '../../models/JellyfinModels.dart';
import '../../models/MusicPlayerProvider.dart';
import '../../services/JellyfinApiData.dart';
import '../BlurredImage.dart';
import '../printDuration.dart';

class AlbumScreenContent extends StatefulWidget {
  const AlbumScreenContent({Key key, @required this.album}) : super(key: key);

  final BaseItemDto album;

  @override
  _AlbumScreenContentState createState() => _AlbumScreenContentState();
}

class _AlbumScreenContentState extends State<AlbumScreenContent> {
  List<Future> albumScreenContentFuture;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  @override
  void initState() {
    super.initState();
    albumScreenContentFuture = [
      // jellyfinApiData.getAlbumPrimaryImage(widget.album),
      Future.delayed(Duration(microseconds: 1)),
      jellyfinApiData.getItems(
          parentItem: widget.album,
          sortBy: "SortName",
          includeItemTypes: "Audio")
    ];
  }

  @override
  Widget build(BuildContext context) {
    MusicPlayerProvider musicPlayerProvider =
        Provider.of<MusicPlayerProvider>(context, listen: false);
    return FutureBuilder(
      future: Future.wait(albumScreenContentFuture),
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
                // imageBytes: snapshot.data[0],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[1][index].name),
                    subtitle: Text(printDuration(
                      Duration(
                          microseconds:
                              (snapshot.data[1][index].runTimeTicks ~/ 10)),
                    )),
                    onTap: () {
                      musicPlayerProvider.setUrl(snapshot.data[1][index]);
                      Navigator.of(context).pushNamed("/nowplaying",
                          arguments: snapshot.data[1][index]);
                    },
                  );
                }, childCount: snapshot.data[1].length),
              )
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
  const AlbumSliverAppBar({
    Key key,
    @required this.album,
    // this.imageBytes,
  }) : super(key: key);

  final BaseItemDto album;
  // final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height / 3,
      flexibleSpace: FlexibleSpaceBar(
        // background: BlurredImage(MemoryImage(imageBytes)),
        title: Text(album.name),
      ),
    );
  }
}
