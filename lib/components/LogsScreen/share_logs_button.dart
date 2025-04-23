import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_logs_helper.dart';

class ShareLogsButton extends StatelessWidget {
  const ShareLogsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      text: AppLocalizations.of(context)!.shareLogs,
      icon: Icons.adaptive.share,
      onPressed: () async {
        final finampLogsHelper = GetIt.instance<FinampLogsHelper>();
        await finampLogsHelper.shareLogs();
      },
    );
  }
}
