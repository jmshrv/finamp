import 'package:flutter/material.dart';

import '../models/JellyfinModels.dart';
import '../components/AddToPlaylistScreen/AddToPlaylistList.dart';

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
    );
  }
}
