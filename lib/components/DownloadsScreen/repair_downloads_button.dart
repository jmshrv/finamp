import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_settings_helper.dart';
import '../../services/isar_downloads.dart';

class RepairDownloadsButton extends StatefulWidget {
  const RepairDownloadsButton({Key? key}) : super(key: key);

  @override
  State<RepairDownloadsButton> createState() =>
      _DownloadMissingImagesButtonState();
}

class _DownloadMissingImagesButtonState extends State<RepairDownloadsButton> {
  // The user shouldn't be able to check for missing downloads while offline
  bool _enabled = !FinampSettingsHelper.finampSettings.isOffline;

  @override
  Widget build(BuildContext context) {
    var scaffold = ScaffoldMessenger.of(context);
    var completeText = AppLocalizations.of(context)!.repairComplete;
    return IconButton(
      onPressed: _enabled
          ? () async {
              // We don't want two checks to happen at once
              setState(() {
                _enabled = false;
              });

              await GetIt.instance<IsarDownloads>().repairAllDownloads();

              scaffold.showSnackBar(SnackBar(
                content: Text(completeText),
              ));

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
