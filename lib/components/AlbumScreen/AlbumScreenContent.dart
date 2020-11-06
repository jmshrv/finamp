import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/AlbumScreen/ItemInfo.dart';
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
  Future<List<BaseItemDto>> albumScreenContentFuture;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  AudioServiceHelper audioServiceHelper = AudioServiceHelper();

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
                  expandedHeight: MediaQuery.of(context).size.height / 2,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child:
                                          AlbumImage(itemId: widget.album.id),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: ItemInfo(
                                      item: widget.album,
                                      itemSongs: items.length,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RaisedButton(
                                      onPressed: () async =>
                                          await audioServiceHelper
                                              .replaceQueueWithItem(
                                                  itemList: items),
                                      color: Colors.green,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.play_arrow),
                                          Text(" PLAY")
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                      onPressed: () async =>
                                          await audioServiceHelper
                                              .replaceQueueWithItem(
                                                  itemList: items,
                                                  shuffle: true),
                                      color: Colors.green,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.shuffle),
                                          Text(" SHUFFLE PLAY")
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    final BaseItemDto item = items[index];
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
