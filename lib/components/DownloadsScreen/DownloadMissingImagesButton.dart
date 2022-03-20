import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';
import '../../services/FinampSettingsHelper.dart';

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

              final downloadsHelper = GetIt.instance<DownloadsHelper>();

              final imagesDownloaded =
                  await downloadsHelper.downloadMissingImages();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Downloaded $imagesDownloaded missing images")));

              setState(() {
                _enabled = true;
              });
            }
          : null,
      icon: const Icon(Icons.image),
      tooltip: "Download missing images",
    );
  }
}
