import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      tooltip: AppLocalizations.of(context)!.editPlaylistNameTooltip,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => PlaylistNameEditDialog(playlist: playlist),
      ),
    );
  }
}
