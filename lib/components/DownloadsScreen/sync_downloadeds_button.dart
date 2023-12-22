import 'package:finamp/services/isar_downloads.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class SyncDownloadsButton extends StatefulWidget {
  const SyncDownloadsButton({super.key});

  @override
  State<SyncDownloadsButton> createState() =>
      _SyncDownloadedPlaylistsButtonState();
}

class _SyncDownloadedPlaylistsButtonState
    extends State<SyncDownloadsButton> {

  bool _enabled = !FinampSettingsHelper.finampSettings.isOffline;

  @override
  Widget build(BuildContext context) {
    var scaffold = ScaffoldMessenger.of(context);
    var completeText = AppLocalizations.of(context)!.syncComplete;
    return IconButton(
      onPressed: _enabled
          ? () async {
        // We don't want two checks to happen at once
        setState(() {
          _enabled = false;
        });

        await GetIt.instance<IsarDownloads>().resyncAll();

        scaffold.showSnackBar(SnackBar(
          content: Text(completeText),
        ));

        if (!mounted) return;
        setState(() {
          _enabled = true;
        });
      }
          : null,
      icon: const Icon(Icons.sync),
      tooltip: AppLocalizations.of(context)!.syncDownloads,
    );
  }
}
