import 'package:finamp/services/offline_listen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

class ShareOfflineListensButton extends StatelessWidget {
  const ShareOfflineListensButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.adaptive.share),
      tooltip: AppLocalizations.of(context)!.shareOfflineListens,
      onPressed: () async {
        final finampLogsHelper = GetIt.instance<OfflineListenLogHelper>();

        await finampLogsHelper.shareOfflineListens();
      },
    );
  }
}
