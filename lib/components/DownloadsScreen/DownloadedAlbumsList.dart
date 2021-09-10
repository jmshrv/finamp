import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';
import '../../models/JellyfinModels.dart';
import '../AlbumImage.dart';
import 'ItemMediaSourceInfo.dart';
import 'AlbumFileSize.dart';

class DownloadedAlbumsList extends StatelessWidget {
  const DownloadedAlbumsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    final Iterable<DownloadedParent> downloadedParents =
        downloadsHelper.downloadedParents;

    // downloadedParents.sort((a, b) {
    //   // This may not work, haven't tested it :)
    //   if (a.item.name != null && b.item.name != null) {
    //     return a.item.name!.compareTo(b.item.name!);
    //   }
    //   return 0;
    // });

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          DownloadedParent album = downloadedParents.elementAt(index);
          return ExpansionTile(
            key: PageStorageKey(album.item.id),
            leading: AlbumImage(item: album.item),
            title: Text(album.item.name ?? "Unknown Name"),
            subtitle: AlbumFileSize(
              downloadedParent: album,
            ),
            children: [
              DownloadedSongsInAlbumList(
                children: album.downloadedChildren.values,
              )
            ],
          );
        },
        childCount: downloadedParents.length,
      ),
    );
  }
}

class DownloadedSongsInAlbumList extends StatelessWidget {
  const DownloadedSongsInAlbumList({Key? key, required this.children})
      : super(key: key);

  final Iterable<BaseItemDto> children;

  @override
  Widget build(BuildContext context) {
    return Column(children: _generateExpandedChildren(children));
  }
}

List<Widget> _generateExpandedChildren(Iterable<BaseItemDto> children) {
  List<Widget> widgets = [];

  for (final song in children) {
    widgets.add(ListTile(
      title: Text(song.name ?? "Unknown Name"),
      leading: AlbumImage(item: song),
      subtitle: ItemMediaSourceInfo(
        songId: song.id,
      ),
    ));
  }

  return widgets;
}
