import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_logs_helper.dart';

class ShareLogsButton extends StatelessWidget {
  const ShareLogsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.adaptive.share),
      tooltip: AppLocalizations.of(context)!.shareLogs,
      onPressed: () async {
        final finampLogsHelper = GetIt.instance<FinampLogsHelper>();

        await finampLogsHelper.shareLogs();
      },
    );
  }
}
