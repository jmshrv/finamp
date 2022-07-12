import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_logs_helper.dart';

class ShareLogsButton extends StatelessWidget {
  const ShareLogsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.adaptive.share),
      onPressed: () async {
        final finampLogsHelper = GetIt.instance<FinampLogsHelper>();

        await finampLogsHelper.shareLogs();
      },
    );
  }
}
