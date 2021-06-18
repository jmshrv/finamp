import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/JellyfinApiData.dart';
import '../MusicScreen/AlbumListTile.dart';
import '../errorSnackbar.dart';

class AddToPlaylistList extends StatefulWidget {
  AddToPlaylistList({
    Key? key,
    required this.itemToAddId,
  }) : super(key: key);

  final String itemToAddId;

  @override
  _AddToPlaylistListState createState() => _AddToPlaylistListState();
}

class _AddToPlaylistListState extends State<AddToPlaylistList> {
  final jellyfinApiData = GetIt.instance<JellyfinApiData>();
  late Future<List<BaseItemDto>?> addToPlaylistListFuture;

  @override
  void initState() {
    super.initState();
    addToPlaylistListFuture = jellyfinApiData.getItems(
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
                return AlbumListTile(
                  album: snapshot.data![index],
                  parentType: snapshot.data![index].type,
                  onTap: () async {
                    try {
                      await jellyfinApiData.addItemstoPlaylist(
                          playlistId: snapshot.data![index].id,
                          ids: [widget.itemToAddId]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added to playlist"),
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
          return Center(
            child: Icon(Icons.error, size: 64),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
