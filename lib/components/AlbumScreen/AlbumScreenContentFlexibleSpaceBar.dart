import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/AudioServiceHelper.dart';
import '../AlbumImage.dart';
import 'ItemInfo.dart';
import 'DownloadSwitch.dart';

class AlbumScreenContentFlexibleSpaceBar extends StatelessWidget {
  const AlbumScreenContentFlexibleSpaceBar({
    Key key,
    @required this.album,
    @required this.items,
  }) : super(key: key);

  final BaseItemDto album;
  final List<BaseItemDto> items;

  @override
  Widget build(BuildContext context) {
    AudioServiceHelper audioServiceHelper =
        GetIt.instance<AudioServiceHelper>();

    return FlexibleSpaceBar(
      background: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 125,
                      child: AlbumImage(itemId: album.id),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Expanded(
                      flex: 2,
                      child: ItemInfo(
                        item: album,
                        itemSongs: items.length,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(children: [
                    Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () =>
                              audioServiceHelper.replaceQueueWithItem(
                                itemList: items,
                              ),
                          icon: Icon(Icons.play_arrow),
                          label: Text("PLAY")),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8)),
                    Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () =>
                              audioServiceHelper.replaceQueueWithItem(
                                itemList: items,
                                shuffle: true,
                              ),
                          icon: Icon(Icons.shuffle),
                          label: Text("SHUFFLE")),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
