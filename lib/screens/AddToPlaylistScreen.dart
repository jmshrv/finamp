import 'package:flutter/material.dart';

import '../models/JellyfinModels.dart';
import '../components/AddToPlaylistScreen/AddToPlaylistList.dart';
import '../components/AddToPlaylistScreen/NewPlaylistDialog.dart';

class AddToPlaylistScreen extends StatelessWidget {
  const AddToPlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BaseItemDto item =
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add to Playlist"),
      ),
      body: AddToPlaylistList(
        itemToAddId: item.id,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // The dialog returns true if a playlist is created. If this is the
          // case, we also pop this page. It will return false if the user
          // cancels the dialog.
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => NewPlaylistDialog(itemToAdd: item.id),
          );

          if (result == true) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
