import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../errorSnackbar.dart';
import '../../services/DownloadsHelper.dart';
import '../../services/processArtist.dart';
import '../AlbumImage.dart';

class DownloadedAlbumsList extends StatelessWidget {
  const DownloadedAlbumsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    final Iterable<DownloadedAlbum> downloadedAlbums =
        downloadsHelper.downloadedAlbums;

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index >= downloadedAlbums.length) return null;
        DownloadedAlbum album = downloadedAlbums.elementAt(index);
        return ListTile(
          leading: AlbumImage(itemId: album.album.id),
          title: Text(album.album.name),
          subtitle: Text(processArtist(album.album.albumArtist)),
        );
      }),
    );
  }
}
