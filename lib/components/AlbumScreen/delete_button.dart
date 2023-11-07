import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../error_snackbar.dart';

class DeleteButton extends StatefulWidget {
  const DeleteButton({
    Key? key,
    required this.parent,
    required this.items,
  }) : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> items;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void checkIfDownloaded() {
      if (!mounted) return;
    }

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? isOffline = box.get("FinampSettings")?.isOffline;

        return IconButton(
          icon: const Icon(Icons.delete),
          // If offline, we don't allow the user to delete items.
          // If we did, we'd have to implement listeners for MusicScreenTabView so that the user can't delete a parent, go back, and select the same parent.
          // If they did, AlbumScreen would show an error since the item no longer exists.
          // Also, the user could delete the parent and immediately re-download it, which will either cause unwanted network usage or cause more errors because the user is offline.
          onPressed: isOffline ?? false
              ? null
              : () {
                _downloadsHelper
                    .deleteParentAndChildDownloads(
                  jellyfinItemIds: widget.items.map((e) => e.id).toList(),
                  deletedFor: widget.parent.id,
                ).then((_) {
                  checkIfDownloaded();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        AppLocalizations.of(context)!.downloadsDeleted),
                  ));
                },onError: (error, stackTrace) =>
                    errorSnackbar(error, context));
                },
        );
      },
    );
  }
}
