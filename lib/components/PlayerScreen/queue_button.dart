import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'queue_list.dart';

class QueueButton extends StatelessWidget {
  const QueueButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.queue_music),
        tooltip: AppLocalizations.of(context)!.queue,
        onPressed: () {
          showQueueBottomSheet(context);
        });
  }
}
