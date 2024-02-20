import 'dart:async';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../MusicScreen/album_item.dart';
import '../global_snackbar.dart';

class AddToPlaylistList extends StatefulWidget {
  const AddToPlaylistList({
    Key? key,
    required this.itemToAddId,
  }) : super(key: key);

  final String itemToAddId;

  @override
  State<AddToPlaylistList> createState() => _AddToPlaylistListState();
}

class _AddToPlaylistListState extends State<AddToPlaylistList> {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  late Future<List<BaseItemDto>?> addToPlaylistListFuture;

  @override
  void initState() {
    super.initState();
    addToPlaylistListFuture = jellyfinApiHelper.getItems(
      includeItemTypes: "Playlist",
      sortBy: "SortName",
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BaseItemDto>?>(
      future: addToPlaylistListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scrollbar(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return AlbumItem(
                  album: snapshot.data![index],
                  parentType: snapshot.data![index].type,
                  isPlaylist: true,
                  onTap: () async {
                    try {
                      await jellyfinApiHelper.addItemstoPlaylist(
                        playlistId: snapshot.data![index].id,
                        ids: [widget.itemToAddId],
                      );
                      final downloadsService =
                          GetIt.instance<DownloadsService>();
                      unawaited(downloadsService.resync(
                          DownloadStub.fromItem(
                              type: DownloadItemType.collection,
                              item: snapshot.data![index]),
                          null,
                          keepSlow: true));

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added to playlist."),
                          // action: SnackBarAction(
                          //   label: "OPEN",
                          //   onPressed: () {
                          //     Navigator.of(context).pushNamed(
                          //         "/music/albumscreen",
                          //         arguments: snapshot.data![index]);
                          //   },
                          // ),
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      errorSnackbar(e, context);
                      return;
                    }
                  },
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          errorSnackbar(snapshot.error, context);
          return const Center(
            child: Icon(Icons.error, size: 64),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
