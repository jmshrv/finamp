import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';
import '../../services/processArtist.dart';
import '../AlbumImage.dart';
import 'ItemMediaSourceInfo.dart';
import 'AlbumFileSize.dart';

class DownloadedAlbumsList extends StatelessWidget {
  const DownloadedAlbumsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    final Iterable<DownloadedParent> downloadedParents =
        downloadsHelper.downloadedParents;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          DownloadedParent album = downloadedParents.elementAt(index);
          return ExpansionTile(
            key: PageStorageKey(album.item.id),
            leading: AlbumImage(itemId: album.item.id),
            title: Text(album.item.name),
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
  const DownloadedSongsInAlbumList({Key key, @required this.children})
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
      title: Text(song.name),
      subtitle: ItemMediaSourceInfo(
        songId: song.id,
      ),
    ));
  }

  return widgets;
}
