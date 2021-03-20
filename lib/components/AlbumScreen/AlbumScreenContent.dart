import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/AudioServiceHelper.dart';
import '../AlbumImage.dart';
import '../printDuration.dart';
import 'DownloadedIndicator.dart';
import 'AlbumScreenContentFlexibleSpaceBar.dart';

class AlbumScreenContent extends StatefulWidget {
  const AlbumScreenContent({Key key, @required this.album}) : super(key: key);

  final BaseItemDto album;

  @override
  _AlbumScreenContentState createState() => _AlbumScreenContentState();
}

class _AlbumScreenContentState extends State<AlbumScreenContent> {
  Future<List<BaseItemDto>> albumScreenContentFuture;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  AudioServiceHelper audioServiceHelper = GetIt.instance<AudioServiceHelper>();

  @override
  void initState() {
    super.initState();
    albumScreenContentFuture = jellyfinApiData.getItems(
        parentItem: widget.album,
        sortBy: "SortName",
        includeItemTypes: "Audio");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: albumScreenContentFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<BaseItemDto> items = snapshot.data;
          return Scrollbar(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(widget.album.name),
                  // 181 is the total height of the widget we use as a FlexibleSpaceBar.
                  // We add the toolbar height since the widget should appear below the appbar.
                  // expandedHeight: kToolbarHeight +
                  //     (MediaQuery.of(context).size.width / (360 / 168)),
                  expandedHeight: kToolbarHeight + 181,
                  pinned: true,
                  flexibleSpace: AlbumScreenContentFlexibleSpaceBar(
                    album: widget.album,
                    items: items,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    final BaseItemDto item = items[index];
                    return ListTile(
                      leading: AlbumImage(
                        itemId: item.parentId,
                      ),
                      title: Text(item.name),
                      subtitle: Text(printDuration(
                        Duration(microseconds: (item.runTimeTicks ~/ 10)),
                      )),
                      trailing: DownloadedIndicator(item: item),
                      onTap: () async {
                        audioServiceHelper.replaceQueueWithItem(
                          itemList: items,
                          startAtIndex: index,
                        );
                      },
                    );
                  }, childCount: items.length),
                ),
              ],
            ),
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
