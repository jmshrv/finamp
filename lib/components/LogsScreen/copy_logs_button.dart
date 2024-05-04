import 'package:finamp/components/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_logs_helper.dart';

class CopyLogsButton extends StatefulWidget {
  const CopyLogsButton({Key? key}) : super(key: key);

  @override
  State<CopyLogsButton> createState() => _CopyLogsButtonState();
}

class _CopyLogsButtonState extends State<CopyLogsButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy),
      onPressed: () async {
        final finampLogsHelper = GetIt.instance<FinampLogsHelper>();

        await finampLogsHelper.copyLogs();

        if (!mounted) return;

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(context)!.logsCopied,
            isConfirmation: true);
      },
    );
  }
}
