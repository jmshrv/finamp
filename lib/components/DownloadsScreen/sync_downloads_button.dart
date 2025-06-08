import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_settings_helper.dart';

class SyncDownloadsButton extends ConsumerStatefulWidget {
  const SyncDownloadsButton({super.key});

  @override
  ConsumerState<SyncDownloadsButton> createState() =>
      _SyncDownloadedPlaylistsButtonState();
}

class _SyncDownloadedPlaylistsButtonState
    extends ConsumerState<SyncDownloadsButton> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _enabled && !ref.watch(finampSettingsProvider.isOffline)
          ? () async {
              // We don't want two checks to happen at once
              setState(() {
                _enabled = false;
              });

              await GetIt.instance<DownloadsService>().resyncAll();

              GlobalSnackbar.message(
                  (scaffold) => AppLocalizations.of(scaffold)!.syncComplete);

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
