import 'package:flutter/material.dart';

import '../../models/jellyfin_models.dart';
import 'playlist_name_edit_dialog.dart';

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
