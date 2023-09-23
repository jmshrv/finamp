import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/downloads_helper.dart';
import '../error_snackbar.dart';

class DeleteDownloadButton extends StatelessWidget {
  const DeleteDownloadButton({
    super.key,
    required this.parent,
    required this.items,
    this.onDownloadsDeleted,
  });

  final BaseItemDto parent;
  final List<BaseItemDto> items;
  final VoidCallback? onDownloadsDeleted;

  @override
  Widget build(BuildContext context) {
    final downloadsHelper = GetIt.instance<DownloadsHelper>();

    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        downloadsHelper
            .deleteDownloads(
          jellyfinItemIds: items.map((e) => e.id).toList(),
          deletedFor: parent.id,
        )
            .then((_) {
          if (onDownloadsDeleted != null) {
            onDownloadsDeleted!();
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.downloadsDeleted),
          ));
        }, onError: (error, stackTrace) => errorSnackbar(error, context));
      },
    );
  }
}
