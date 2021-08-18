import 'package:flutter/material.dart';

import '../models/JellyfinModels.dart';
import '../components/AddToPlaylistScreen/AddToPlaylistList.dart';
import '../components/AddToPlaylistScreen/NewPlaylistDialog.dart';

class AddToPlaylistScreen extends StatelessWidget {
  const AddToPlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add to Playlist"),
      ),
      body: AddToPlaylistList(
        itemToAddId: itemId,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // The dialog returns true if a playlist is created. If this is the
          // case, we also pop this page. It will return false if the user
          // cancels the dialog.
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => NewPlaylistDialog(itemToAdd: itemId),
          );

          if (result == true) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
