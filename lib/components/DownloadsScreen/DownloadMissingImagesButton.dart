import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';

class DownloadMissingImagesButton extends StatelessWidget {
  const DownloadMissingImagesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final downloadsHelper = GetIt.instance<DownloadsHelper>();
      },
      icon: const Icon(Icons.image),
      tooltip: "Download missing images",
    );
  }
}
