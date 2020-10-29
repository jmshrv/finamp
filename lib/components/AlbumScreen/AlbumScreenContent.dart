import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliver_fab/sliver_fab.dart';

import '../../models/JellyfinModels.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/AudioServiceHelper.dart';
import '../AlbumImage.dart';
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
  AudioServiceHelper audioServiceHelper = AudioServiceHelper();

  @override
  void initState() {
    super.initState();
    albumScreenContentFuture = [
      // jellyfinApiData.getAlbumPrimaryImage(widget.album),
      // TODO: Remove the need for this first item since we don't get the image directly anymore.
      Future.delayed(Duration(microseconds: 1)),
      jellyfinApiData.getItems(
          parentItem: widget.album,
          sortBy: "SortName",
          includeItemTypes: "Audio")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(albumScreenContentFuture),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverFab(
            floatingWidget: FloatingActionButton(
              backgroundColor: Colors.green,
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
                  final BaseItemDto item = snapshot.data[1][index];
                  return ListTile(
                    leading: AlbumImage(
                      itemId: item.id,
                    ),
                    title: Text(item.name),
                    subtitle: Text(printDuration(
                      Duration(microseconds: (item.runTimeTicks ~/ 10)),
                    )),
                    onTap: () async {
                      audioServiceHelper.replaceQueueWithItem(
                        itemList: snapshot.data[1],
                        startAtIndex: index,
                      );
                      // Navigator.of(context).pushNamed("/nowplaying",
                      //     arguments: snapshot.data[1][index]);
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
