import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../errorSnackbar.dart';
import '../../services/DownloadsHelper.dart';
import '../../services/processArtist.dart';
import '../AlbumImage.dart';
import 'ItemMediaSourceInfo.dart';

class DownloadedAlbumsList extends StatelessWidget {
  const DownloadedAlbumsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    final Box<DownloadedAlbum> downloadedAlbums =
        downloadsHelper.downloadedAlbumsBox;

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index >= downloadedAlbums.length) return null;
        DownloadedAlbum album = downloadedAlbums.getAt(index);
        return ExpansionTile(
          key: PageStorageKey(album.album.id),
          leading: AlbumImage(itemId: album.album.id),
          title: Text(album.album.name),
          subtitle: Text(
            processArtist(album.album.albumArtist),
          ),
          children: [DownloadedSongsInAlbumList(albumId: album.album.id)],
        );
      }),
    );
  }
}

class DownloadedSongsInAlbumList extends StatelessWidget {
  const DownloadedSongsInAlbumList({Key key, @required this.albumId})
      : super(key: key);

  final String albumId;

  @override
  Widget build(BuildContext context) {
    final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    final Box<DownloadedSong> downloadedItems =
        downloadsHelper.downloadedItemsBox;

    Iterable<DownloadedSong> albumSongs = downloadedItems.values
        .where((element) => element.song.albumId == albumId);

    return Column(children: _generateExpandedChildren(albumSongs));
  }
}

List<Widget> _generateExpandedChildren(Iterable<DownloadedSong> songs) {
  List<Widget> widgets = [];
  List<DownloadedSong> sortedSongs = songs.toList();
  sortedSongs.sort((a, b) => a.song.indexNumber.compareTo(b.song.indexNumber));

  for (DownloadedSong song in sortedSongs) {
    widgets.add(ListTile(
      title: Text(song.song.name),
      subtitle: ItemMediaSourceInfo(
        mediaSourceInfo: song.mediaSourceInfo,
      ),
    ));
  }

  return widgets;
}
