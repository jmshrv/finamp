import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_logs_helper.dart';

class ExportLogsButton extends StatelessWidget {
  const ExportLogsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      text: AppLocalizations.of(context)!.exportLogs,
      icon: TablerIcons.file_download,
      onPressed: () async {
        final finampLogsHelper = GetIt.instance<FinampLogsHelper>();
        await finampLogsHelper.exportLogs();
      },
    );
  }
}
