import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/isar_downloads.dart';

class DownloadMissingImagesButton extends StatefulWidget {
  const DownloadMissingImagesButton({Key? key}) : super(key: key);

  @override
  State<DownloadMissingImagesButton> createState() =>
      _DownloadMissingImagesButtonState();
}

class _DownloadMissingImagesButtonState
    extends State<DownloadMissingImagesButton> {
  // The user shouldn't be able to check for missing downloads while offline
  bool _enabled = !FinampSettingsHelper.finampSettings.isOffline;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _enabled
          ? () async {
              // We don't want two checks to happen at once, so we disable the
              // button while a check is running (it shouldn't take long enough
              // for the user to be able to press twice, but you never know)
              setState(() {
                _enabled = false;
              });

              final isarDownloads = GetIt.instance<IsarDownloads>();
              // TODO put in widget with updated name and text
              await isarDownloads.repairAllDownloads();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!
                    .repairComplete),
              ));

              setState(() {
                _enabled = true;
              });
            }
          : null,
      icon: const Icon(Icons.handyman),
      tooltip: AppLocalizations.of(context)!.downloadMissingImages,
    );
  }
}
