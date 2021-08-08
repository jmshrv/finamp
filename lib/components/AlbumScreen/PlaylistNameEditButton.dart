import 'package:flutter/material.dart';

import '../../models/JellyfinModels.dart';
import 'PlaylistNameEditDialog.dart';

class PlaylistNameEditButton extends StatelessWidget {
  const PlaylistNameEditButton({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final BaseItemDto playlist;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: "Edit playlist name",
      onPressed: () => showDialog(
        context: context,
        builder: (context) => PlaylistNameEditDialog(playlist: playlist),
      ),
    );
  }
}
