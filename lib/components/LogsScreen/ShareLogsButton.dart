import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/FinampLogsHelper.dart';

class ShareLogsButton extends StatelessWidget {
  const ShareLogsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Platform.isIOS || Platform.isMacOS
          ? const Icon(Icons.ios_share)
          : const Icon(Icons.share),
      onPressed: () async {
        final finampLogsHelper = GetIt.instance<FinampLogsHelper>();

        await finampLogsHelper.shareLogs();
      },
    );
  }
}
