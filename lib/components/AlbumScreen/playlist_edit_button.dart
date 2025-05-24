import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../models/jellyfin_models.dart';
import 'playlist_edit_dialog.dart';

class PlaylistNameEditButton extends StatelessWidget {
  const PlaylistNameEditButton({
    super.key,
    required this.playlist,
  });

  final BaseItemDto playlist;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(TablerIcons.edit),
      tooltip: AppLocalizations.of(context)!
          .editItemTitle(BaseItemDtoType.fromItem(playlist).name),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => PlaylistEditDialog(playlist: playlist),
      ),
    );
  }
}
