import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../global_snackbar.dart';

class RepairDownloadsButton extends ConsumerStatefulWidget {
  const RepairDownloadsButton({super.key});

  @override
  ConsumerState<RepairDownloadsButton> createState() =>
      _DownloadMissingImagesButtonState();
}

class _DownloadMissingImagesButtonState
    extends ConsumerState<RepairDownloadsButton> {
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

              try {
                await GetIt.instance<DownloadsService>().repairAllDownloads();
              } catch (e) {
                GlobalSnackbar.error(e);
                return;
              }

              GlobalSnackbar.message(
                  (scaffold) => AppLocalizations.of(scaffold)!.repairComplete);

              if (!mounted) return;
              setState(() {
                _enabled = true;
              });
            }
          : null,
      icon: const Icon(Icons.handyman),
      tooltip: AppLocalizations.of(context)!.repairDownloads,
    );
  }
}
