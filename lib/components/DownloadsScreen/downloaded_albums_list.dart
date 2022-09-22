import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/downloads_helper.dart';
import '../../models/jellyfin_models.dart';
import '../album_image.dart';
import 'item_media_source_info.dart';
import 'album_file_size.dart';

class DownloadedAlbumsList extends StatelessWidget {
  DownloadedAlbumsList({Key? key}) : super(key: key);
  final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  final JellyfinApiHelper jellyfinApiHelper = JellyfinApiHelper();

  void deleteAlbum(BuildContext context, DownloadedParent downloadedParent) {
    List<String> itemIds = [];
    for (BaseItemDto item in downloadedParent.downloadedChildren.values) {
      itemIds.add(item.id);
    }
    downloadsHelper.deleteDownloads(
        jellyfinItemIds: itemIds, deletedFor: downloadedParent.item.id);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deleted ${downloadedParent.item.id}")));
  }

  @override
  Widget build(BuildContext context) {
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
            trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteAlbum(context, album)),
            subtitle: AlbumFileSize(
              downloadedParent: album,
            ),
            children: [
              DownloadedSongsInAlbumList(
                children: album.downloadedChildren.values,
                parent: album,
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
  DownloadedSongsInAlbumList({Key? key, required this.children, required this.parent})
      : super(key: key);

  final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  final Iterable<BaseItemDto> children;
  final DownloadedParent parent;

  @override
  Widget build(BuildContext context) {
    return Column(children: _generateExpandedChildren(context, children));
  }

  void deleteSong(BuildContext context, BaseItemDto itemDto){
    parent.downloadedChildren.removeWhere((key, value) => value == itemDto);
    downloadsHelper.deleteDownloads(jellyfinItemIds: [itemDto.id]);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deleted ${itemDto.id}")));
  }

  List<Widget> _generateExpandedChildren(BuildContext context, Iterable<BaseItemDto> children) {
    List<Widget> widgets = [];

    for (final song in children) {
      widgets.add(ListTile(
        title: Text(song.name ?? "Unknown Name"),
        leading: AlbumImage(item: song),
        trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => deleteSong(context, song)),
        subtitle: ItemMediaSourceInfo(
          songId: song.id,
        ),
      ));
    }

    return widgets;
  }
}

