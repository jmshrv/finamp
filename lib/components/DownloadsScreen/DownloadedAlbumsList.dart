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
    final Iterable<DownloadedAlbum> downloadedAlbums =
        downloadsHelper.downloadedAlbums;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          DownloadedAlbum album = downloadedAlbums.elementAt(index);
          return ExpansionTile(
            key: PageStorageKey(album.album.id),
            leading: AlbumImage(itemId: album.album.id),
            title: Text(album.album.name),
            subtitle: AlbumFileSize(
              downloadedAlbum: album,
            ),
            children: [
              DownloadedSongsInAlbumList(
                  children: album.downloadedChildren.values)
            ],
          );
        },
        childCount: downloadedAlbums.length,
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
  List<BaseItemDto> sortedSongs = children.toList();
  sortedSongs.sort((a, b) => a.indexNumber.compareTo(b.indexNumber));

  for (final song in sortedSongs) {
    widgets.add(ListTile(
      title: Text(song.name),
      subtitle: ItemMediaSourceInfo(
        songId: song.id,
      ),
    ));
  }

  return widgets;
}
