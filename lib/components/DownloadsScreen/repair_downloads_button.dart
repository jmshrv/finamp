import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../global_snackbar.dart';

class RepairDownloadsButton extends StatefulWidget {
  const RepairDownloadsButton({super.key});

  @override
  State<RepairDownloadsButton> createState() =>
      _DownloadMissingImagesButtonState();
}

class _DownloadMissingImagesButtonState extends State<RepairDownloadsButton> {
  // The user shouldn't be able to check for missing downloads while offline
  bool _enabled = !FinampSettingsHelper.finampSettings.isOffline;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _enabled
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
